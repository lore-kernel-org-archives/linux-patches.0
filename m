Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF9B29B781;
	Fri,  4 Sep 2026 06:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502278; cv=none; b=a1OhX5tCSG7S2myls6TcE2bhCtQldDU0PbUVWLVaHzgtrQOFIwCeZJDJd5Yi/rmgKFfubRKWqKlFioO36tVIJ0j1SkkTw1p7hp+rXWvNLMItUz4djdiW4eC5k6DS3JflmorkCrqdWoaEZz8t9Bx+lY2+lIrLHH0l8K3xcrWbCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502278; c=relaxed/simple;
	bh=zgjt2ElqqtzyxQm/bXl6yPdFr7MJ/D1RwjNqwUI40c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQBcpa2DUF80PUfusfJNJapLiqVnvnu/LHm+ynMD0G6NeK8akSlnBuqnmM3miZLu0n8IOZ30Fpunv42VJ7SSWRfyKx8vcYVhXagFGhU9N16GjpYnMS9AGTe5WAHXxRE4HfFzI27JlRmkKffnK4YG0eCirMxIHtI5cTa8vyMcvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA2YkrpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA2YkrpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B071F00A3D;
	Fri,  4 Sep 2026 06:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502276;
	bh=orBxWghYgTdjrpJ3RJsYKqdp3pnWSt30hseO4HggoQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA2YkrpQy4I+yEegQlSqT6IxHpaUVrUilLphpZNChtzgkHPDCE27VOI1ybi2fzRbV
	 J1b4/SzDHF8rjtS2VUgTqZZcF05T0aNeqeLPlpMeEMCpiA7VHvCQ8EBsOcV7UZ23Se
	 GDaL6EonqYc2+ebByOEo6MSi+/1KbcueR01BcI0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.12 134/403] eCryptfs: bound the packet-length peek to the user buffer
Date: Fri,  4 Sep 2026 06:58:57 +0200
Message-ID: <20260904045737.884203985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


