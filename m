Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F781F8935;
	Tue,  3 Dec 2024 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242320; cv=none; b=OJ4ZCCJeMV6qWGWsWm/nWl9ekQs34SNz0WB4dobHEEX8z1X92mwLLbWZCfFCrwifNUz6KaVa9X/ICQ0OblJgOKRJea7e5TosNDi4pn5YmzETDdh3lqOaEHrhf2b9HPa+LZbPqZr3oOJnW2Ry7qHRUM5Gpqi/Ao48d6YL/cljG9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242320; c=relaxed/simple;
	bh=9VBTBmF+2qhB1lqOuhScnjoK122dysrb821nFGyrlMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvWUTY+5Kxy975tpIsFG6w0/ZYqxWeusIwO/KO8S50ntGsNthNsuXRUeOYjhCuk59w4dv/YTn9CwSHqoHTwujFzkr3zdlm9KV+zPsZa4Lv7+EQVME7xQU/MPYVBmZWr+vKzWUhCkjmYbHCuA6KUN3NLGp5jn8kj23WywKQwaaFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYVCmC/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYVCmC/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230C9C4CECF;
	Tue,  3 Dec 2024 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242319;
	bh=9VBTBmF+2qhB1lqOuhScnjoK122dysrb821nFGyrlMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYVCmC/DrY864UX64hsXHsGJoAh6rIOtm5u5WhEwJG9yEDRFOl9dngSy8dErThMhs
	 zMOaU0SNfpMfzi7OIGZYq/2pceuENqjK2dvuQUHx+cpeyQGwubQAEpKoqvO7qfhL4Z
	 G8ZQIVi9gh/USTMh+691yX5NLM/ekdBzlTnFI3Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 671/826] exfat: fix out-of-bounds access of directory entries
Date: Tue,  3 Dec 2024 15:46:38 +0100
Message-ID: <20241203144809.928437472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit 184fa506e392eb78364d9283c961217ff2c0617b upstream.

In the case of the directory size is greater than or equal to
the cluster size, if start_clu becomes an EOF cluster(an invalid
cluster) due to file system corruption, then the directory entry
where ei->hint_femp.eidx hint is outside the directory, resulting
in an out-of-bounds access, which may cause further file system
corruption.

This commit adds a check for start_clu, if it is an invalid cluster,
the file or directory will be treated as empty.

Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -638,14 +638,26 @@ static int exfat_find(struct inode *dir,
 	info->size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
+
+	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
+	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
+		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
+				info->start_clu);
+		info->size = 0;
+		info->valid_size = 0;
+	}
+
+	if (info->valid_size > info->size) {
+		exfat_warn(sb, "valid_size(%lld) is greater than size(%lld)",
+				info->valid_size, info->size);
+		info->valid_size = info->size;
+	}
+
 	if (info->size == 0) {
 		info->flags = ALLOC_NO_FAT_CHAIN;
 		info->start_clu = EXFAT_EOF_CLUSTER;
-	} else {
+	} else
 		info->flags = ep2->dentry.stream.flags;
-		info->start_clu =
-			le32_to_cpu(ep2->dentry.stream.start_clu);
-	}
 
 	exfat_get_entry_time(sbi, &info->crtime,
 			     ep->dentry.file.create_tz,


