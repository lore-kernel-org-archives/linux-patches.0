Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6862B9C7;
	Sun,  1 Sep 2024 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208468; cv=none; b=a0HRcO++JBZ3dUfLh4uFQin1LaIu1k9Aei87jRs1KOO3yLlH3/yRJ03bivVCsGSIsOvxKv/1+TN3w5KsBdT6bO76uK6UXoy06KEb+Chmu3XvW8OfazKBDFDCMpc4XRjh0sp6sIhT8YXHMjDJXs10kwKYbf8304e5Z7Om3pOR1rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208468; c=relaxed/simple;
	bh=iW4c7ZNQ1EDnzPRsHIT5OiRErvFH2z1Y46HW/LLQdMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WupcFuWJQkL1WFBrn1ijNqD5RAFNgQedpco3jamRa9SYgd3L6m4XwgypBfiZtjpkDmJLn5fzwybSd69NT2Tc7JBc8rFxwxD+QL5w4S+HDzUvLjW2H15iHJewZew+P2BH9zDt9EdcytMIFAjFmYUxkkRZPssivp55+3O3pMbpyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ds5MhEj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ds5MhEj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044D4C4CEC3;
	Sun,  1 Sep 2024 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208468;
	bh=iW4c7ZNQ1EDnzPRsHIT5OiRErvFH2z1Y46HW/LLQdMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ds5MhEj62AKb2iMJVRpFzGwvtrbOu1yMjmz4dI+NYH+tZWoqGDF8PFylF105Tyckp
	 bHc3ykJUQ+0akpuyjUb+EosDxjLQx8RCiRAteqCfnBySJ34b66XPZXULFFQPOgXWqk
	 Pq9ySz9I6iKwjRo+YMTeFa3p25H/vEfsm+5kf8fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Tsai <ed.tsai@mediatek.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/149] backing-file: convert to using fops->splice_write
Date: Sun,  1 Sep 2024 18:16:11 +0200
Message-ID: <20240901160819.725179129@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Tsai <ed.tsai@mediatek.com>

[ Upstream commit 996b37da1e0f51314d4186b326742c2a95a9f0dd ]

Filesystems may define their own splice write. Therefore, use the file
fops instead of invoking iter_file_splice_write() directly.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
Link: https://lore.kernel.org/r/20240708072208.25244-1-ed.tsai@mediatek.com
Fixes: 5ca73468612d ("fuse: implement splice read/write passthrough")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/backing-file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index afb557446c27c..8860dac58c37e 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -303,13 +303,16 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	if (WARN_ON_ONCE(!(out->f_mode & FMODE_BACKING)))
 		return -EIO;
 
+	if (!out->f_op->splice_write)
+		return -EINVAL;
+
 	ret = file_remove_privs(ctx->user_file);
 	if (ret)
 		return ret;
 
 	old_cred = override_creds(ctx->cred);
 	file_start_write(out);
-	ret = iter_file_splice_write(pipe, out, ppos, len, flags);
+	ret = out->f_op->splice_write(pipe, out, ppos, len, flags);
 	file_end_write(out);
 	revert_creds(old_cred);
 
-- 
2.43.0



