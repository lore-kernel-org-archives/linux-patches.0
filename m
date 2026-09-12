Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22DA31F9B4;
	Sat, 12 Sep 2026 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232724; cv=none; b=CQ7HFSAO3tcpauVTZhgIV5n6k3U7xczjYG1gK5MtAonacLZjR1iDMwE15FBJvVVfx5a+rUVeNXRFENnxBZKoChEGg2bWNKt4jtHVshvUvPreI0nr/NF1uis2MqH6ftpH00SduDVEAkgmYpy6Ab0IFwSukBCEwto/81UC5NVvxqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232724; c=relaxed/simple;
	bh=dh93EoKv6lXfcGaD7YMyjNIre39x3OVZh9bofhFAzGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjTOsMylwI8extzOvcaWsBBm7f2Scw2IKVTLYAjsJfUurCSNlV5HewUp/cBJdZRxaUl5IK4OVEjl4wFoH9TBCEDv55WKcCNoSMWpA4vVHRByO46LJ99ycokiEMarkgMGmCytTzC9vhjMz+qiwQrQahOXDsggzGTn3xzgQLbFfTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkQL8aTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkQL8aTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5341F000FF;
	Sat, 12 Sep 2026 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232723;
	bh=UOJPM4R35dIo8pXShfnPwlnW9Ryng8ZdlYK6+TIc/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkQL8aTeuBpMjMBd+OTF1T3osScdurp3SG8awiJePJMZhkPvGKvBzmf0VBG8BTtyH
	 D8ysLZfL+FE3Q7V/MJO9KiybVeuaqVTKAgLqeNRwMKIhyL6yKcyxM3eOBioVKWrAcy
	 MwKqSOl+CJdMg5mDxUKv0rcs1becUvTogsA5oUfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 067/935] ecryptfs: fix tag 11 packet exact-fit size check
Date: Sat, 12 Sep 2026 08:51:37 +0200
Message-ID: <20260912065528.376333414@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

commit 8b2ec0f56f55477f547d332526c9ae2a8fabc0a5 upstream.

parse_tag_11_packet() rejects a packet when the already-consumed tag and
length bytes plus the packet body exceed the caller supplied maximum
packet size.  The check currently adds one extra byte, even though
*packet_size already includes the tag byte before the length is parsed.

Remove the extra byte so a tag 11 packet that exactly fits the available
buffer is accepted while oversized packets are still rejected.

Fixes: 237fead61998 ("[PATCH] ecryptfs: fs/Makefile and fs/Kconfig")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1576,7 +1576,7 @@ parse_tag_11_packet(unsigned char *data,
 	}
 	(*packet_size) += length_size;
 	(*tag_11_contents_size) = (body_size - 14);
-	if (unlikely((*packet_size) + body_size + 1 > max_packet_size)) {
+	if (unlikely((*packet_size) + body_size > max_packet_size)) {
 		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out;


