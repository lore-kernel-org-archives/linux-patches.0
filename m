Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68E318ED6;
	Fri,  4 Sep 2026 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500820; cv=none; b=OE9YwfQB1AqFoRSPPxf/tU0cTKF683t2tWVmt7h2uwr4+xNbQVdri7djNjjVYF/yUEWongS4FjVZWzsP8A7SRIvAdpabSnGpJaNSJtkejpoU6TBoiarZxDuc+lcQONYhLVOjsyMDgpUzabk3LLsLNv2dtT5YGrlw2wuDuJGTwas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500820; c=relaxed/simple;
	bh=XxGaDBjZ4JQwn1955AYsqnbpASy42qOLzkuegRewwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwNrWN+hoYMDU2jDrXayqaWlUplSAQLJ2OwmBRNyumU4ZSWoZBlZR4sEFUhesje68yA++twj0PAPivEGrQq79dwF8ESC0mNILqjkryNgjsY2Iu9taR2GfwMQqguX5wISPKyu7aw0tje5O3epRXnLqZHmv9zvS7MS34bRo3/FPWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4L7+PUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4L7+PUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965A81F00A3D;
	Fri,  4 Sep 2026 05:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500819;
	bh=yK6YaEGsBwC/zVCXsfowBv+7efbNgYk/l149TPT2e9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4L7+PURYukrtaUimHdE13EkCo+MSMPqLYUiBq9SePoOd0BSgCeoun3t3ms+p8P3q
	 JNlJ0nozg9Y3+ty/G2+uSdpZqLEY8Qo3+1Re49U+wICA80IV3X1atqOK+mh9fqMFIl
	 24OUu2O6zSXdaUXNCrx2AmjjPvgIrsG0sS6kah9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.18 191/552] eCryptfs: bound the packet-length peek to the user buffer
Date: Fri,  4 Sep 2026 06:55:48 +0200
Message-ID: <20260904045753.344231652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


