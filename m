Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF37612D7;
	Tue, 20 Feb 2024 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463537; cv=none; b=rFQjSUos6lhoYyP2FRUFC09Ks5hMJdMYO2QdYL+xgz6hKMaHukM914CFVPMgeg5b4sbPFCaOnbILINy3DL7MQWdAaXbDoS08+35U6nkAc7YySAx9pC6+iGskBkLDhKfhJUShpZ7jgHmhqdQKywW7PAcF+g7qhj6adHqT1n6f0IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463537; c=relaxed/simple;
	bh=ETtGMtBKteFJvn1eSbkbURSjTXZ+yRwDoPQ/JMUxDn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km7CRAOSAXKGgyTxSog2GrVCJfMqXPVFnXQYXTmHunCUMlyETHGcDKAsD2xwC3lZ7uFg8PBxx72i9wtIb8OWRKXaSHRNLTZiqaR6sbOtTKjZP7oIuG/OUr0QoNwGwpqpuELKQoilzbAymT6JK3JE+2qyWNFUfdgxnh0HhlMXYGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15EPEb5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15EPEb5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21426C433A6;
	Tue, 20 Feb 2024 21:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463536;
	bh=ETtGMtBKteFJvn1eSbkbURSjTXZ+yRwDoPQ/JMUxDn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15EPEb5dhwXclTP2hFaBWs24TlAPvul2CI6c+ipHsH1QLRjtxHp+lZX3mpz+SM23/
	 Tee7msx33r7/mmKw5sdUeIw3BInxHyQ0JTTExJ4SzqfBpQReg09khPEW1oht9l0pjO
	 t4UqcktEFwvse+eoMwxbXNx7kC9/rjCsD1QJPztw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 073/331] HID: i2c-hid-of: fix NULL-deref on failed power up
Date: Tue, 20 Feb 2024 21:53:09 +0100
Message-ID: <20240220205639.861094153@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


