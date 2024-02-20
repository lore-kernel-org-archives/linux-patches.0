Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB7614A4D2;
	Tue, 20 Feb 2024 21:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464622; cv=none; b=eKeKTslKnOasjKYeCx8ztNlCsMWMIQfe+KMdsXFS/kRd0MF4Tp5+7UJdstVD/Frmc6NU/lGhb3XXAkuNy6PL0uYgQbCiWj19zLsqBwVxsxmUgz8q9ApLIM7+D/jL0tPWTRg2ttTSHu5sMRGLlMzbCM3kDrrByyl5Ksw/dXhiVsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464622; c=relaxed/simple;
	bh=V4zkgwg0DB0L529IYPfTWNMFqlDS+3m6tG59uED/DQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhVuUx07Q1R0dLDaIUhu67R1MSFoDTJ4K5psdTMx/4pkEBzWsGgc3D8W8uZmmLJxqoLK+f+5RO5RkhQLlMRQOMk0z5/KVEiNJDO41xgVKDbvoLaR//fOHReFE6Ozw9Dl1N1HwvCUcSVJL0rJXfvTjmBFVOLdLz3GXVdNXEGfFtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOqEZo4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOqEZo4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32323C433F1;
	Tue, 20 Feb 2024 21:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464622;
	bh=V4zkgwg0DB0L529IYPfTWNMFqlDS+3m6tG59uED/DQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOqEZo4NVP+DfhTSmJubjSO511yCpYPG7dHLc0b04srAhdhV20I10/7EkGENdEabT
	 kF8V7DQHG4fQRYWA5GpfxBXcjNNa5EaPqutMO3ZUjBLfDVgv7cUHtAZqzIDPPTN2AZ
	 bx8QH8z/YgydpZLNF9qK+/rOiPuKpfqlLqs9s7PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.7 083/309] HID: i2c-hid-of: fix NULL-deref on failed power up
Date: Tue, 20 Feb 2024 21:54:02 +0100
Message-ID: <20240220205635.789454553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 00aab7dcb2267f2aef59447602f34501efe1a07f upstream.

A while back the I2C HID implementation was split in an ACPI and OF
part, but the new OF driver never initialises the client pointer which
is dereferenced on power-up failures.

Fixes: b33752c30023 ("HID: i2c-hid: Reorganize so ACPI and OF are separate modules")
Cc: stable@vger.kernel.org      # 5.12
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-of.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/i2c-hid/i2c-hid-of.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of.c
@@ -87,6 +87,7 @@ static int i2c_hid_of_probe(struct i2c_c
 	if (!ihid_of)
 		return -ENOMEM;
 
+	ihid_of->client = client;
 	ihid_of->ops.power_up = i2c_hid_of_power_up;
 	ihid_of->ops.power_down = i2c_hid_of_power_down;
 


