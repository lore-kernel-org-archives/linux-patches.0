Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F78227B355;
	Mon, 18 Aug 2025 12:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521512; cv=none; b=kpnPRXwYaWdy+CNZXdKkVQmGLHnhQ0k8Hqlq19Tw4mny3kXLMi16KOW5OGERFQ+dxwqtMq5vpK0xL75I1oEZLEBB6A+F3tWrN1ISKh8FKofj7zAKzdqvOEaEhTl2509lXvfarbiKAUT8ph+D4aMPNDc+HcwKbZUovsMxXd3z8kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521512; c=relaxed/simple;
	bh=r4pY5sJzbDikd7A2nUDdeJGkPpIZzDpvTN6qp8HdCFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWBT1WEDP/M6MHBBCZhnHDWTW7BH+wGjpGU526dhBVa4ZqU+RQIFIuAHTkcsEIV8HvP4HYADTrY5FxHD4V28hzAVW+77edMj23Q5UHIGgJEBivaE5SaljHGQItc01ApQFN96tsDOMxX0n3uPVdK3uoMo8zFmFNjklRNM9tvf8gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Frtdg1MW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Frtdg1MW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C562C4CEEB;
	Mon, 18 Aug 2025 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521511;
	bh=r4pY5sJzbDikd7A2nUDdeJGkPpIZzDpvTN6qp8HdCFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Frtdg1MW0473QEwECBqrCUBdc6i+TkAURylnozQzXuRnv95Fdl/Fhct12qK0TCoc/
	 0jrhtJ6x5ZkZE4y9HU9BtbR2mvO99853V6Cclht9wszvAEtEEwGtw7lSxHWbVM19V4
	 gK1DQgZ1h2MtupC0hzxGhBdkM0KhladtwVw08JSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Mommer <harald.mommer@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 008/444] gpio: virtio: Fix config space reading.
Date: Mon, 18 Aug 2025 14:40:34 +0200
Message-ID: <20250818124449.217330621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -539,7 +539,6 @@ static const char **virtio_gpio_get_name
 
 static int virtio_gpio_probe(struct virtio_device *vdev)
 {
-	struct virtio_gpio_config config;
 	struct device *dev = &vdev->dev;
 	struct virtio_gpio *vgpio;
 	u32 gpio_names_size;
@@ -551,9 +550,11 @@ static int virtio_gpio_probe(struct virt
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


