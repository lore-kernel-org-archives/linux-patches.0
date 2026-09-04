Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75BA34A3A5;
	Fri,  4 Sep 2026 05:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500826; cv=none; b=G4YmDeN1uTxuR1OrR8VFaxw9svZ7Jip6HmRI9xcp8hxpeMCNRK64M+y15yn0MFtHYMik3ZYFa5Vf1XHeutRjKUB/gxztmyQgvcZwhzKe5nGsXGBGuzMW3Xb9cTqgH230JykV2DZKk9t6OFC9KHCing4T+53rajzCbkDaYg6dfYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500826; c=relaxed/simple;
	bh=bSPS6oNCGvI4UboJ/hlEwcSJlfHuNRzoVa+kDwQHCzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StD6oaI2Pmdpk+SEShrH7MMmGjp1aOqurA6l8VgpxKBg7MPQ7xwjxPuDAE17yc8UJFd77LguFqYPoQMem5rlCOIK9InWZmd0yfsgHdtXwYmxOi78JtwJ07eQz0HZKB6S4FNNqo4XPsMox/fgEbfHms7g2I6m6KDeojTs+lWZOBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvaDuWt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvaDuWt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBC01F00A3D;
	Fri,  4 Sep 2026 05:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500824;
	bh=ms4BvnBrL6vASQLCewSCK1TyqLi1+dxzgGmXtW6dI1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvaDuWt4RB7NerObpc7lEvxNhhGyPUBRUEB/iJvujGd6grA9w7XA1a/Y0pMrDZcv+
	 ZLTo+vn8VYp4jH462mo002ogngSbYnBTa2x8EjF+Xki/m9Ra6kZiAzj80fzA0xn3wA
	 s4EEa883MyBfBQ92pBNNciTQRwMpZjfBiJqzQc6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.18 192/552] ecryptfs: fix tag 11 packet exact-fit size check
Date: Fri,  4 Sep 2026 06:55:49 +0200
Message-ID: <20260904045753.369424315@linuxfoundation.org>
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


