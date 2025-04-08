Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF2E267B89;
	Tue,  8 Apr 2025 11:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112894; cv=none; b=eeSCzqQbCPD8uqOy7QHfiHxXYjeNpTJ5diw9hQaOvqW5qA3H3KIQ3OqthD9jUmaheYPqlQn+TwATqpu3VQ/KGYaRIz0RtURSyO/Nu50leS1sQ1JeGORSMNS5nxT4HkUDBf4GbdnA57UI5EQ4j1WfgPjEutiuMzs3M0c1hvbsY4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112894; c=relaxed/simple;
	bh=ky8MpmGoim+BG7ELKlMA+tWdF91mRs4n5aAs9WwIyBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsgWqp/nPnErrGfrsWk2Z4JGRGyf1t8hr+wy9/G7CW/erOnXpwaAljTlKfILKPW7Z5HfvSxQS7VomHzVwANR1Ip5TNWGYvKXipPewcHgbA3VgkZ9izF5xEY0nEDTaKVL04O11xg5KSXVRRIbtwnU754/KL+W38Octexg2BsgXpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB67JuDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB67JuDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF5EC4CEE7;
	Tue,  8 Apr 2025 11:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112894;
	bh=ky8MpmGoim+BG7ELKlMA+tWdF91mRs4n5aAs9WwIyBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB67JuDcbsQbvQltA5BYd11mgX5H4MhfNgmeFkMLoZg8jFsg4MRTwRandPZJUxvN2
	 M/zcFJdSt6pbgav+RdHhPzAk8c98Q87zeAVuMUIgH99Fds6zBh67EMCMd6vuTw65Bo
	 JSjA+rI9ZXSq292aTDq3rurzvbwc+p9jZESr5yDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/279] spufs: fix a leak in spufs_create_context()
Date: Tue,  8 Apr 2025 12:50:19 +0200
Message-ID: <20250408104832.753547482@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0f5cce3fc55b08ee4da3372baccf4bcd36a98396 ]

Leak fixes back in 2008 missed one case - if we are trying to set affinity
and spufs_mkdir() fails, we need to drop the reference to neighbor.

Fixes: 58119068cb27 "[POWERPC] spufs: Fix memory leak on SPU affinity"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 1095be5186ebf..ea3082f2f9d1d 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -436,8 +436,11 @@ spufs_create_context(struct inode *inode, struct dentry *dentry,
 	}
 
 	ret = spufs_mkdir(inode, dentry, flags, mode & 0777);
-	if (ret)
+	if (ret) {
+		if (neighbor)
+			put_spu_context(neighbor);
 		goto out_aff_unlock;
+	}
 
 	if (affinity) {
 		spufs_set_affinity(flags, SPUFS_I(d_inode(dentry))->i_ctx,
-- 
2.39.5



