Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3FF37FF50;
	Sat, 12 Sep 2026 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241137; cv=none; b=KrIW3UnWnxfQIOgoWkOmbst4HuN5b2hTBjfrEd15WxFcHAjPa5c/DG+2PmCUy28yTXIyTTRmPp6DUnpsgCMdro9du4WJAZZ+S7i1kNH/OA907uYXPQ8tE8Bt9qLF0PSQwpaabv+qsnsTr/oS5awQJtO6EqYudOZAL5a2iQ8znAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241137; c=relaxed/simple;
	bh=mgtj0Bls1UWOXnTjHur9m53A3O8347dQUiV5k6WaecM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgSQsRzmurSQ3f2biOYsBZvA3Jwnz10DquqRNxGIlnUwSTY+Tjakw8udipkbSE30U3UWzgCZK9qCEMgLPhverm2PRbvzs6BoYOWto3ua8VDF4dlFZDPBy9QpBymz0tHBEOBjfFLPvaIQs5mZ+UlVH9X9LuE3o3jHt8c+du4mkaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtEOhvCk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtEOhvCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83511F000FF;
	Sat, 12 Sep 2026 19:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241135;
	bh=9LIPLFKGfXK7qYlKAMtzUWyQAGlcItXRNOwUdNqm2EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtEOhvCkxZXTUnBbwe+zFNebc7VjzgYBRS/9JcBdaUWPLZJ9F2VLNIzYILQuJRmaX
	 EbNmU+vcacX+posQ59I+0/3kL14QBnAH7bDQie7wv/LnNCkERtdevaxDh8v/U5atML
	 249UkrqpTbytHI737RCAbrjAcO+9cS0V/wthUFnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.10 057/798] eCryptfs: bound the packet-length peek to the user buffer
Date: Sat, 12 Sep 2026 08:54:45 +0200
Message-ID: <20260912065518.269822700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,7 +356,7 @@ ecryptfs_miscdev_write(struct file *file
 	u32 seq;
 	size_t packet_size, packet_size_length;
 	char *data;
-	unsigned char packet_size_peek[ECRYPTFS_MAX_PKT_LEN_SIZE];
+	unsigned char packet_size_peek[ECRYPTFS_MAX_PKT_LEN_SIZE] = { };
 	ssize_t rc;
 
 	if (count == 0) {
@@ -372,7 +372,8 @@ ecryptfs_miscdev_write(struct file *file
 	}
 
 	if (copy_from_user(packet_size_peek, &buf[PKT_LEN_OFFSET],
-			   sizeof(packet_size_peek))) {
+			   min_t(size_t, count - PKT_LEN_OFFSET,
+				 sizeof(packet_size_peek)))) {
 		printk(KERN_WARNING "%s: Error while inspecting packet size\n",
 		       __func__);
 		return -EFAULT;


