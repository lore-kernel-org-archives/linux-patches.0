Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92782698B9;
	Tue,  8 Apr 2025 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115026; cv=none; b=EeTC800AI+8aGpsMQghFPdvJHhZmKMxrA7EZ46YvYXKgINCr7LS18lPKInXxproFcslp7kA2WBLlNL7Nex4rQ9tagYRxmTC0fEYGk/1QZzFaWHVI/aBAId2kjfWeDCYt2W8aKQlFsXU21uTf77XtsuiCfkIINrYT4/gJY17DP6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115026; c=relaxed/simple;
	bh=lfZsdqRESkfgNa5u9gSb4bOj9/66Gn/YchxXxePno34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCUzNu/JhUcmVf4aWDq6RtnsMghwfM6YqsT8Y+/pUp0Y2mfp4y0g8oqjY5qq68JGyPeqi8Yl0mFIPjwLV+OnJbXFszg7xZMKPbaDaWV7wIjmXORIJysmOaKMd60ayjqwr7klLdusFYUHige8YvTEMTXj0HXtTHOoeajo5QZ8BXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8VhRFnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8VhRFnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69313C4CEE5;
	Tue,  8 Apr 2025 12:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115026;
	bh=lfZsdqRESkfgNa5u9gSb4bOj9/66Gn/YchxXxePno34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8VhRFnKfB0Yho/DZKkXN61N9uxwD5z3+vuhtlp/wuB8fqU+jiAiU7JwQUsfj2BzC
	 pAKFrYUOij5lTDyu/WV2vhDysiEBhfKEBrW9g1pWSmG7JxqY30qQQB6fo1LK7vxvzo
	 Rya+s4oq2/tpAhBvj/nnimIoGwUF1iGp9cYk2RuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 322/499] exfat: add a check for invalid data size
Date: Tue,  8 Apr 2025 12:48:54 +0200
Message-ID: <20250408104859.254564903@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 13940cef95491472760ca261b6713692ece9b946 ]

Add a check for invalid data size to avoid corrupted filesystem
from being further corrupted.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 9996ca61c85b7..a8f9db2fcb491 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -651,6 +651,11 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
 
+	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
+		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
+		return -EIO;
+	}
+
 	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
 	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
 		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
-- 
2.39.5



