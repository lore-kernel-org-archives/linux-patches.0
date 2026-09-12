Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F40533F59A;
	Sat, 12 Sep 2026 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220028; cv=none; b=L+zXLaARAH51tenrswJwQWzy46dgGlW2I5UOHT+FkEWVEQiJoENBRgSkciSZyTovraz4jsgGCQntgy+HI/AFsiZeQljBp7yGVFitHT9NkP/19RjogrUNbOeRdaO9lDL3/qI8CzrcAtY37ET2jFP2tD2LUXZVj6DIytBxbI0/7gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220028; c=relaxed/simple;
	bh=Cjk7MlyFWmY4xz1ERQ8C6WA3Fu92MY9y2/PrhuM+zFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6TRrUq7VmPgolwVmS9fkC1jwXFarORz3srJ8tFGSr3dvZMbNnaqgn02Hv2oH12lMt5k1xSv4ds7dVCbE7R59mSg5WeV2Wl+qVC+KYdc3/OY5v0urb9OUAuhIALzcbP+zaF9Unflygj/8dgnbOjj2Vw0y/UWsYXRu2R4FqREvZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0oDmWyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0oDmWyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF1A1F000FF;
	Sat, 12 Sep 2026 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220027;
	bh=hzHm6kyGpzuJswA1CvstGuyh9rf2L3m23rFW6HppzUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0oDmWyXYJtUqk9RZ2DfP6awd1XGFG00yrgxRpzPgf7tUnB0ljETD0TtBmm/PuQmK
	 4vSl4THHfiy22dER5H083/AXe2k+8JG92IaBe4AjlEFJ/V8ofclX5Scw77P10nxITQ
	 ghIvVHXj05Je8XXsmxRHV749mO0f4KiCwHhckRBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.6 0093/1424] eCryptfs: bound the packet-length peek to the user buffer
Date: Sat, 12 Sep 2026 08:42:05 +0200
Message-ID: <20260912065609.388129278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


