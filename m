Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ED71BEF85;
	Thu, 30 Jan 2025 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245567; cv=none; b=fVz83BhIeX5YeLtlh4Gt2O4GL6xF0IFmCcfgzYqqltQzWVhuTUHPhC5catXTSIVKKLuYnUkdM0ogNXldUwsRlnJrbcfSCn1c3nUdKRNiWZ7mqkmhx1U7LXB07xHvgrlHmw2IxWMdbAlPU5GTqef7SFCXzlJrtgCXPkbooCrJ+P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245567; c=relaxed/simple;
	bh=YmhzmeJumT0Ktr8I79Xc+sVPI9dk84SzyrSaC5FBXhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBbVW5eJiQsWEIOV9wjt/s+VwGeN/8rlWTRYMU1ac30HNgAVW8bAV7nMV5yVrwvJIrgKiaYBy32EGiuUt7emN7oQmRgf5j+CqJwVR+FBo78e6OOguZkXY1sW/742jOhEWlo56idce4rmZTuplPdFsHNRrgZ31pUkhA84g/a86Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScaMRBRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScaMRBRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC91C4CED2;
	Thu, 30 Jan 2025 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245567;
	bh=YmhzmeJumT0Ktr8I79Xc+sVPI9dk84SzyrSaC5FBXhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScaMRBRAXAXM3NvIkv/JPlaYVWZVXPS1NTyhJaGb1SwV1zCXmKGdljEHDVJwM20UH
	 8JTGciPAMbIvIlhyi6QCgwQFoQTheomciYtBAbPSRhq6CN44SqgrMpSn2nc4QjweP0
	 vv3oLgmNpeb/zM/4dwz9Fe54Uu+IjLfB8RxQ6WE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.13 11/25] vfio/platform: check the bounds of read/write syscalls
Date: Thu, 30 Jan 2025 14:58:57 +0100
Message-ID: <20250130133457.381469643@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit ce9ff21ea89d191e477a02ad7eabf4f996b80a69 upstream.

count and offset are passed from user space and not checked, only
offset is capped to 40 bits, which can be used to read/write out of
bounds of the device.

Fixes: 6e3f26456009 (“vfio/platform: read and write support for the device fd”)
Cc: stable@vger.kernel.org
Reported-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -388,6 +388,11 @@ static ssize_t vfio_platform_read_mmio(s
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -467,6 +472,11 @@ static ssize_t vfio_platform_write_mmio(
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);


