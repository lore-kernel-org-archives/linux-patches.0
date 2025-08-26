Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DB92F0671;
	Tue, 26 Aug 2025 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216150; cv=none; b=LgchChHnhkCSWZV7gmQ5qsOYJZ+Jv2RkZ1Jib6hZ6GpMiwEx8VlAGhwLDkHeN2FcM84rEwCjUMyTmcsNbV1TFSUr/ysm9DX4lm4FiP/zYKLmuBw3HYaI1oEQbPDXFslfHp39B4oOK5crEk0jaQ7XRS8IbQfu34myAFS7ppsM3/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216150; c=relaxed/simple;
	bh=y9EMGj110bNgym/Pv4ksRpHcOsdCpDpN0AuUkNVi+pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6xskGmhWx/+/jdp3QHtx6aEHCmpTHpa08ER+/68x+hcou0nHfxXaUSsN7PLujX2qhzPNfi2kLnyqwaYiZ7WmoYlzffd6lj1cf8z9fPYDaxwaEDcWhTbBQf0ElLfqOif6l1tTFAanVu36Zv9yLd/tdKNXYCG+zfqQkFXwVNX3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqtfbmx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqtfbmx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72B3C4CEF1;
	Tue, 26 Aug 2025 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216150;
	bh=y9EMGj110bNgym/Pv4ksRpHcOsdCpDpN0AuUkNVi+pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqtfbmx3X0qhIhQ3YDRa2VO5pCVv15mDKif2TRSNlISYim+mTdsW6gNoZr0iBuNLD
	 V0u6wE2dhD13Trpc2vCBalVKRdnVn8DO0214+LuiaM7JnxrdmIW8d9kCm6x8f94G+f
	 LWiNA/eJz8FG1+5rGrtx8N22wXuoLpV5JFhyeZBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Mommer <harald.mommer@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.15 261/644] gpio: virtio: Fix config space reading.
Date: Tue, 26 Aug 2025 13:05:52 +0200
Message-ID: <20250826110952.844093947@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Harald Mommer <harald.mommer@oss.qualcomm.com>

commit 4740e1e2f320061c2f0dbadc0dd3dfb58df986d5 upstream.

Quote from the virtio specification chapter 4.2.2.2:

"For the device-specific configuration space, the driver MUST use 8 bit
wide accesses for 8 bit wide fields, 16 bit wide and aligned accesses
for 16 bit wide fields and 32 bit wide and aligned accesses for 32 and
64 bit wide fields."

Signed-off-by: Harald Mommer <harald.mommer@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Fixes: 3a29355a22c0 ("gpio: Add virtio-gpio driver")
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20250724143718.5442-2-harald.mommer@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-virtio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -275,7 +275,6 @@ static const char **virtio_gpio_get_name
 
 static int virtio_gpio_probe(struct virtio_device *vdev)
 {
-	struct virtio_gpio_config config;
 	struct device *dev = &vdev->dev;
 	struct virtio_gpio *vgpio;
 	u32 gpio_names_size;
@@ -287,9 +286,11 @@ static int virtio_gpio_probe(struct virt
 		return -ENOMEM;
 
 	/* Read configuration */
-	virtio_cread_bytes(vdev, 0, &config, sizeof(config));
-	gpio_names_size = le32_to_cpu(config.gpio_names_size);
-	ngpio = le16_to_cpu(config.ngpio);
+	gpio_names_size =
+		virtio_cread32(vdev, offsetof(struct virtio_gpio_config,
+					      gpio_names_size));
+	ngpio =  virtio_cread16(vdev, offsetof(struct virtio_gpio_config,
+					       ngpio));
 	if (!ngpio) {
 		dev_err(dev, "Number of GPIOs can't be zero\n");
 		return -EINVAL;


