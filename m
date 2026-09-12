Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEFF2F6931;
	Sat, 12 Sep 2026 17:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232719; cv=none; b=uMe8WWYO9jN1SNYe6Tyn81qRekfmHiifrdEi4nB7zkksS+Vdl/1A7VujdXbPW0X3dJOXAkJteThXMfxKeQ4zSsu8pxDBO1yaGdcTi99CkSkm87lS3RVeBnJ5/l6t35QnjYLtZnRpzDjhOuWhEDRBG0jdkgL3vwi0mCd3kh2KuZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232719; c=relaxed/simple;
	bh=8aGdqt6nDnoNqLSMtNQp5b1aVxWEulbchOpsDNK4yYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw9gFUqkdlLvFEiuy0UVqmvS9oQqYuQQmOzCqexeKYN0JjcJDU2VihpJDeWfn+epvN93CIuPJsvQSuvh31/ihvLeiLBBg47gGgs/rBNNJ3xWGI1VvpCy5iKU9/CHwSbQfunYyTzR1ueACsvEBl1Qxt/Xj1j8h/4ZJmwxmaM5JLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xf/yy+sv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xf/yy+sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765D71F000FF;
	Sat, 12 Sep 2026 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232718;
	bh=XWYG5v9Heh1k/q7kHwbjugghwRcj47NBF3GrK31F1+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xf/yy+svCk9Cne56OzXoWZLlMueMocqCAgOLigjcPWpvmDDI4aUnSCowcK+6Oh7PZ
	 itJ6yfgI2mHLuPYccDSQjbHTCIczDIJCfhyf08UCoryisfWi7GpsPKaRKvLb6ze5lO
	 Xck7HwdJ1aP0FcxJJQYILMsR60UN2mdyioOegWsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 066/935] eCryptfs: bound the packet-length peek to the user buffer
Date: Sat, 12 Sep 2026 08:51:36 +0200
Message-ID: <20260912065528.353145359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 95540462e630edbc8504e9537d16453d6942d143 upstream.

ecryptfs_miscdev_write() accepts the minimum one-byte packet-length
encoding, but always copies the maximum two-byte encoding from userspace
before parsing it. A six-byte message therefore reads one byte beyond the
submitted user buffer.

Zero-initialize the peek buffer and copy only the packet-length bytes
present. The existing exact packet-size check still rejects truncated
two-byte encodings after the parser determines their encoded length.

Fixes: 8bf2debd5f7b ("eCryptfs: introduce device handle for userspace daemon communications")
Cc: <stable@vger.kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/miscdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -357,7 +357,7 @@ ecryptfs_miscdev_write(struct file *file
 	u32 seq;
 	size_t packet_size, packet_size_length;
 	char *data;
-	unsigned char packet_size_peek[ECRYPTFS_MAX_PKT_LEN_SIZE];
+	unsigned char packet_size_peek[ECRYPTFS_MAX_PKT_LEN_SIZE] = { };
 	ssize_t rc;
 
 	if (count == 0) {
@@ -373,7 +373,8 @@ ecryptfs_miscdev_write(struct file *file
 	}
 
 	if (copy_from_user(packet_size_peek, &buf[PKT_LEN_OFFSET],
-			   sizeof(packet_size_peek))) {
+			   min_t(size_t, count - PKT_LEN_OFFSET,
+				 sizeof(packet_size_peek)))) {
 		printk(KERN_WARNING "%s: Error while inspecting packet size\n",
 		       __func__);
 		return -EFAULT;


