Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4564D1BDA95;
	Thu, 30 Jan 2025 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246879; cv=none; b=RiJEiy01InuUVk/2Xplea/JIGRVS8gGH0eGnpFYFb1yR65TPguF+5iGgvj+8kbQS8fJNK5uRxQJhHuwPMmbFxiWEUFLaAraGmUniI7HnCc9pf5jZ96CKZH2eAw/7Xv7wbI+JZPNRRfV4+39htjGFo5VFRs5cq+M6FFBlURqwJ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246879; c=relaxed/simple;
	bh=a1yj5/aeML5wgMGRnCIt9wxN/Bu89FWqz9QZVGod8Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2AeDI4lT/WMcFM+Ua3LtUg/G/KI8j/YEv9nBwgqwW/P554FtShux4Z4lBvtE2AVTBzt/x4RpsJ3jFGq2Vq+7KuECeMiNN3p91b7QWVKM33ZpU6Ac9mXwhAs5FXRfaEIRDpAc0Pc7s40BGaXfay7CtSsxagR0Gwcj6pKxiF76JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnOJnYC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnOJnYC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB7BC4CED2;
	Thu, 30 Jan 2025 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246879;
	bh=a1yj5/aeML5wgMGRnCIt9wxN/Bu89FWqz9QZVGod8Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnOJnYC2beFbxZEv0LgsIuAE16CHSRJIg3gPTpnd/c45DiHOAhAlgBu58TSHMoXTl
	 kg9OeZ73Uk1UOmEwURVKM974geqzlyyrR5LJt93YExsN9OUxBhxEMtvAzj6Z7HKgjO
	 oJtucYEEbrviE+b5YgxFAPy90MlDzDWSZPhwu78I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 84/91] vfio/platform: check the bounds of read/write syscalls
Date: Thu, 30 Jan 2025 15:01:43 +0100
Message-ID: <20250130140137.063628703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -405,6 +405,11 @@ static ssize_t vfio_platform_read_mmio(s
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap_nocache(reg->addr, reg->size);
@@ -482,6 +487,11 @@ static ssize_t vfio_platform_write_mmio(
 {
 	unsigned int done = 0;
 
+	if (off >= reg->size)
+		return -EINVAL;
+
+	count = min_t(size_t, count, reg->size - off);
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap_nocache(reg->addr, reg->size);


