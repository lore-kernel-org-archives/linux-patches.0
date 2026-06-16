Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9379B466B79;
	Tue, 16 Jun 2026 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627460; cv=none; b=YSP7MC5mirwaY8ZANjVEAV9xxgI3C2Kn82f35CRGgetIk93dWf8wwXoXhw9SdB/PNSHINRdbc8hu3lbd6w9uMz5nXgmuWfOD+joksvsbXhBKXQFY/eIoE+i9A4h54szmw2nn8lpB6TibfhEcCHGgBqO6RodN019669rlOuGajCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627460; c=relaxed/simple;
	bh=yV12tNu4GS6g3aXA0tR4vey7TYVSoTbLruDT1GwxUyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzPv8xV722R/2xGOQm/jmqRJx3I/lIfayF8cLvHSHI7SC0/n31Dau/4dZR0sIQxW0H2P+eyuoCwD4E/TqZT7TiMVKm5C/CiOi1/jVyqT+eEcKxgzWUeQflAyWEzu7hPqp0Glsq01QId5Di/lngzcG5J8jTadqhJhJyGbkZygzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRIxbrkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRIxbrkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348E91F000E9;
	Tue, 16 Jun 2026 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627459;
	bh=MECI/Z2yTLBq7aeXp+8JbH/CGO/VEbSpSC3z+GL12m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRIxbrkSDYjOb65sHZGE1CCLrjNoaQUSdFFD2HcnXhISbKtMjiyoCna8gX1WYkMIF
	 15PLjxLK4wrNDTe5PN/nE1QNL75w3w1q7q6fDRQfBgKK0s79bokp7ajdfQS51QR3ue
	 5fSHMzpvzhDkCW1TPcOmqqVmx3IUWTi+5Hz622F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Guillermo=20Rodr=C3=ADguez?= <guille.rodriguez@gmail.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 173/261] i2c: stm32f7: fix timing computation ignoring i2c-analog-filter
Date: Tue, 16 Jun 2026 20:30:11 +0530
Message-ID: <20260616145053.085937377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillermo Rodríguez <guille.rodriguez@gmail.com>

commit a124579c0763da7bc408f4cd7e8f606cadc94855 upstream.

stm32f7_i2c_compute_timing() uses i2c_dev->analog_filter to pick
the analog filter delay, but i2c_dev->analog_filter is parsed from
the "i2c-analog-filter" DT property only after the compute_timing
loop in stm32f7_i2c_setup_timing(), so in practice the timing
calculations always ignore the analog filter. On an STM32MP1 board
with clock-frequency = <400000> and i2c-analog-filter set, measured
SCL frequency was ~382 kHz.

This also affects (widens) the computed SDADEL range. At high bus
clock speeds, this can select an SDADEL value that violates tVD;DAT
(data valid time).

Fix by parsing "i2c-analog-filter" before the compute_timing loop.

Fixes: 83c3408f7b9c ("i2c: stm32f7: support DT binding i2c-analog-filter")
Signed-off-by: Guillermo Rodríguez <guille.rodriguez@gmail.com>
Cc: <stable@vger.kernel.org> # v5.13+
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260526091210.20383-1-guille.rodriguez@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -693,6 +693,9 @@ static int stm32f7_i2c_setup_timing(stru
 	if (!of_property_read_bool(i2c_dev->dev->of_node, "i2c-digital-filter"))
 		i2c_dev->dnf_dt = STM32F7_I2C_DNF_DEFAULT;
 
+	i2c_dev->analog_filter = of_property_read_bool(i2c_dev->dev->of_node,
+						       "i2c-analog-filter");
+
 	do {
 		ret = stm32f7_i2c_compute_timing(i2c_dev, setup,
 						 &i2c_dev->timing);
@@ -714,9 +717,6 @@ static int stm32f7_i2c_setup_timing(stru
 		return ret;
 	}
 
-	i2c_dev->analog_filter = of_property_read_bool(i2c_dev->dev->of_node,
-						       "i2c-analog-filter");
-
 	dev_dbg(i2c_dev->dev, "I2C Speed(%i), Clk Source(%i)\n",
 		setup->speed_freq, setup->clock_src);
 	dev_dbg(i2c_dev->dev, "I2C Rise(%i) and Fall(%i) Time\n",


