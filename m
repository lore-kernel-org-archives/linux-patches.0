Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047DA1EF087;
	Wed, 19 Feb 2025 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957233; cv=none; b=aSay1OoWSsGbGAMaw8weXL6vYozq/ileJP0o7uHJKIYnstXTX3bxapHNMLo5cj8v2l9zOhCFJTrFAjuzsLAGi/ZDBsyWMFMAZLeb87MhjEfvhG8iECex3eAuUgxxafSdvCSmHZgEDHoHMjV/YHdNpeosULWeof1vv4vZiSS2nJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957233; c=relaxed/simple;
	bh=OHa69RYqT5hWWA85sHrUl+1DkTbNNoypHQnxCbBoP8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJ3sNwevegErPPtUQRAIV5sSwjwvbHq5RXZAisYQ9Q9EiFDl0xTSd1hMuT+mVdBr5BJ0E9/ggC2CuL+5n9TmenkDX2kCVvkXJnw9HzD+Z3nlPXsrIGKRsmQSSJ70xyFEhC9grw8MDBQOSmpDusMTT1Y3+kQo7CTdAJqlrJQ0ZvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puH9TGzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puH9TGzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD00C4CEE8;
	Wed, 19 Feb 2025 09:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957232;
	bh=OHa69RYqT5hWWA85sHrUl+1DkTbNNoypHQnxCbBoP8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puH9TGzw62PSk9yJ9g4MQvisS8Goump9xIKmhhtAr+/FgawfWZNRGkAEvC/dOmspF
	 JYL8qQYb0woOLds5oKMHaudZRwSEyGrgw+NMvUTzp3+Yg52sOpKiKmjZdmQu42st+g
	 o+iiYiQts0flAySb5gXEimRgngQrcC2JQTHjfyZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 423/578] vfio/platform: check the bounds of read/write syscalls
Date: Wed, 19 Feb 2025 09:27:07 +0100
Message-ID: <20250219082709.655807534@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,6 +396,11 @@ static ssize_t vfio_platform_read_mmio(s
 
 	count = min_t(size_t, count, reg->size - off);
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -477,6 +482,11 @@ static ssize_t vfio_platform_write_mmio(
 
 	if (off >= reg->size)
 		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
+	if (off >= reg->size)
+		return -EINVAL;
 
 	count = min_t(size_t, count, reg->size - off);
 


