Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D942494FE;
	Wed, 25 Feb 2026 01:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982835; cv=none; b=Dd7eytQHQ+oAbzgBthQabwwfxr7EaMuoC8CAX65E1GOz8ZHz2+cU2BxX3ZnbmXj097nlHMNftX0h89pXjZnaGJ6Fv/HzyJRfUVCuzIH55lJaDq0fIPwyGQcxqIZmIzremF9m/M6Azqs4PI7jrNmOwlfS1s4WbtJiVLmoBAdqEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982835; c=relaxed/simple;
	bh=D+tZIzwl3J9QxWznjzuz4kFu7eGeXywfOqj/oWuuN18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4ljR2ibbQYeqeyCWsOA3vPQytEliNGr9lNl2KgNmLmzMk/RqdWwkXx+4FqxJH9bUd5K6XysydLl2ik3Yna2dp3hxdF9/41Nn5IyDfj9UIoccWNqJNnABAfQkV8LqGqHqpdyBQNx0OkaXxp6z4W2ZqYlMkZIXIpZtDNyyp/2dOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8/D0Apw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8/D0Apw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8BFC116D0;
	Wed, 25 Feb 2026 01:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982835;
	bh=D+tZIzwl3J9QxWznjzuz4kFu7eGeXywfOqj/oWuuN18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8/D0ApwpGP/RbXGyEWBzgK0SQVQNBSjt8klbnseVaADuku0Nf8qFf+TMHmrGywDB
	 G1n7GvQ1Ol3TPM3z7jzW6HSaphoNVfuDOFwaLrZgCEdR3/5KUiiLkw0tmhDf1R6DCL
	 OmBdBS+aBdJiLDFgOW71CemblTLokqq/VtQkEeuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 028/781] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Tue, 24 Feb 2026 17:12:17 -0800
Message-ID: <20260225012400.389608650@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 51b1fcf71c88c3c89e7dcf07869c5de837b1f428 ]

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 206587820fec0..c634e01140514 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1607,8 +1607,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.51.0



