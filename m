Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46B430CEE;
	Thu, 16 Jul 2026 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212501; cv=none; b=PERPkb1dDNmbHAHkiS9h/r9xy4GVBnWLhBSOmwrYdcUehoTlXREYkFU1xB+a/B7SRnavrAc7ol+Lo8hA3fC3hhb6NK4bSIAIITp4wKn0yRRYazS10uJScP/ZPwoYFr5gXTq0fARwy14RKLs3D78n5lDCesfylJS6G8cB42m4uhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212501; c=relaxed/simple;
	bh=AcG4qp8joGLvNveV0tWCqV/q/L0bsfFZCY7YUqCzpnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH0Xbm5MH395uwBv1v+dhIJmyxtGxGpUWGOcHK1u+nnAWgULdEUepsUxv9xyR7Uk+hu6A0tIetfOXSmqr6Dvm7m8A8hZBKL0DM1/vg1EtGyQoGX2o1wiaGEEUD6lOVV9ATCXl6/X2XPHK4GnJwxfKq1EMfD/1AhyGcegbcoIV0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWsc1DNU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWsc1DNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF831F000E9;
	Thu, 16 Jul 2026 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212499;
	bh=vNhswsb92IGqpKS33OgyCYo8aTZtqqxT2DBhf2ekdq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWsc1DNUrjwDqFTE/zyknAUSHI1eCCNijYqVp+8kjJb8aYskL+Utn1ETbvZsGLwli
	 5P3Ufb+bIwQIAGyulpSPu+MaRxHKxhNl5vJsLxJD4fdu9KTOkjRT48U/b839hLf1cm
	 G20VjeI3T0pbiuddbviStPtpgKDanqQZ4Fx6ludc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 331/349] Input: synaptics-rmi4 - bound the F3A keymap to the GPIO count
Date: Thu, 16 Jul 2026 15:34:25 +0200
Message-ID: <20260716133040.721481440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 57c10915f2c16c90e0d46ad00876bf39ece40fc2 upstream.

rmi_f3a_initialize() takes the GPIO count from the device query register
(f3a->gpio_count = buf & RMI_F3A_GPIO_COUNT, range 0..127).
rmi_f3a_map_gpios() then allocates gpio_key_map with
min(gpio_count, TRACKSTICK_RANGE_END) == at most 6 entries, but
rmi_f3a_attention() iterates the full gpio_count and dereferences
gpio_key_map[i], and input->keycodemax is set to the full gpio_count
while input->keycode points at the 6-entry allocation.

A device that reports gpio_count > 6 therefore causes an out-of-bounds
read of gpio_key_map[] on every attention interrupt, and out-of-bounds
accesses through the input core's default keymap ioctls: EVIOCGKEYCODE
reads past the buffer (leaking adjacent slab memory to user space) and
EVIOCSKEYCODE writes a caller-controlled value past it, for any process
able to open the evdev node, since input_default_getkeycode() and
input_default_setkeycode() only bound the index against keycodemax.

Size the keymap for the full gpio_count. The mapping loop is unchanged:
it still assigns only the first min(gpio_count, TRACKSTICK_RANGE_END)
entries; the remaining slots stay KEY_RESERVED (devm_kcalloc zero-fills)
and are skipped when reporting.

Fixes: 9e4c596bfd00 ("Input: synaptics-rmi4 - add support for F3A")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260614-b4-disp-818d6bda-v1-1-cf39a3615085@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f3a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_f3a.c
+++ b/drivers/input/rmi4/rmi_f3a.c
@@ -132,7 +132,7 @@ static int rmi_f3a_map_gpios(struct rmi_
 	int button_count = min_t(u8, f3a->gpio_count, TRACKSTICK_RANGE_END);
 
 	f3a->gpio_key_map = devm_kcalloc(&fn->dev,
-						button_count,
+						f3a->gpio_count,
 						sizeof(f3a->gpio_key_map[0]),
 						GFP_KERNEL);
 	if (!f3a->gpio_key_map) {


