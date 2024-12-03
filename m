Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987F523CE;
	Tue,  3 Dec 2024 16:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241936; cv=none; b=nw/7/VT49FafWUAiDZbq9MGUhG0RRs08q6Ta4/Pf5w3lDkPFvbrSv91AlBRFuy9FS79YgH8n8h3A97Wvv7jqg1O6dy771qP9Uk85ojkLMhJA/eP5naMbD8tc1M8HsR0w0mAXzZTOkMevc9Mvnpnu31U9hWfDYKwV+FisLk7+71w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241936; c=relaxed/simple;
	bh=lygA2U4sZ93Ov89aWxS3ZShrHpSsefEBKdsFeRbmxA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAYaoa/LORHgIa0jEj8Z7fRuMuFpSjdWP2l8qPPOitwAd3uvHfbM3I6tSew9MheSXeOLpH+kZXEJUxY8FfobILwqXNzKyrGu9gnCk+oHZiEvpojWp1qLJaJ7i5QD80LrbbkPDD0/5gFzcrABZW8uipAh9oVDYMFvSpTmo/C9Z1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZhVjX2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZhVjX2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B1DC4CECF;
	Tue,  3 Dec 2024 16:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241936;
	bh=lygA2U4sZ93Ov89aWxS3ZShrHpSsefEBKdsFeRbmxA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZhVjX2/zM9cFO/Df/8k46eODKg5DYRhIqz3IalU9JsbMy+rkp+4lOAbSGr0ZfdZ1
	 8tFsSojD6DJWy/uliae16PtKVDJ3XhVlacWwLEQFU/8IedRGF4U/wRry+xtCFFvvfy
	 fYZrNZfQiCm4HYwRmqWlWwH4o0OxbYrkzmh1DIF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 560/826] exfat: fix file being changed by unaligned direct write
Date: Tue,  3 Dec 2024 15:44:47 +0100
Message-ID: <20241203144805.589341817@linuxfoundation.org>
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

[ Upstream commit 2e94e5bb94a3e641a25716a560bf474225fda83c ]

Unaligned direct writes are invalid and should return an error
without making any changes, rather than extending ->valid_size
and then returning an error. Therefore, alignment checking is
required before extending ->valid_size.

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index a25d7eb789f4c..fb38769c3e39d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -584,6 +584,16 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (ret < 0)
 		goto unlock;
 
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		unsigned long align = pos | iov_iter_alignment(iter);
+
+		if (!IS_ALIGNED(align, i_blocksize(inode)) &&
+		    !IS_ALIGNED(align, bdev_logical_block_size(inode->i_sb->s_bdev))) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+	}
+
 	if (pos > valid_size) {
 		ret = exfat_extend_valid_size(file, pos);
 		if (ret < 0 && ret != -ENOSPC) {
-- 
2.43.0



