Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC8713C816;
	Thu, 13 Feb 2025 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460850; cv=none; b=E72288Jg4WRwUg6lX01AhLR743CH8HKyhdsGLpbr3z1RX5NmsFzjIlAvFDiJeriJg7RS9PSeaEHZoPH9BcnX6leTRb9u11ukCxQCpmWwHXFclfsWxQsBUFS4ZwKyRIzSGjb0Gwml0/IYpBM/fbXK+lDkNa/XOqZunt+vM1bTgq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460850; c=relaxed/simple;
	bh=KfrXCcaFj0ldly/8Syb+McuRe599gUIFKTY/EIl1OR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GNv7/KZDKGT4Cqln/RXcPKguR7nmhFTYUZNOMAETXUq88wX/W5nekM2C5UTsDgnrktHU/hlts3dWV61B+hd0iHfz0BbjPNHvRcO6svMUMJN3T7bdmiFSWSovJnYdHsx1RTC21A2bbY6BbrQbSOFBsrIoSW2ZIN4AeoYIuAZ2AGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bUMB0DZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bUMB0DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D346C4CED1;
	Thu, 13 Feb 2025 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460849;
	bh=KfrXCcaFj0ldly/8Syb+McuRe599gUIFKTY/EIl1OR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bUMB0DZwX7lt6Wfiw51ehjBJ3kueX9iooeF8qQrHNsqLi9N5o4Hr2JSe7Jr3mSN8
	 nylDi4zEskpo4Aey7nCyufS7EU08tcOpB3wQ/W2hk7ALIq/NyQXNgjJmljUXY/EIXY
	 DsJiOcBR2Jym9+idnpYZSW+Y4I445k2Vz2l3zZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.6 230/273] vfio/platform: check the bounds of read/write syscalls
Date: Thu, 13 Feb 2025 15:30:02 +0100
Message-ID: <20250213142416.525095256@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,6 +393,11 @@ static ssize_t vfio_platform_read_mmio(s
 
 	count = min_t(size_t, count, reg->size - off);
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -474,6 +479,11 @@ static ssize_t vfio_platform_write_mmio(
 
 	if (off >= reg->size)
 		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
+	if (off >= reg->size)
+		return -EINVAL;
 
 	count = min_t(size_t, count, reg->size - off);
 


