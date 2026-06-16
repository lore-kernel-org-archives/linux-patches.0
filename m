Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B6B3BFE5A;
	Tue, 16 Jun 2026 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634301; cv=none; b=hP98t9y40zqQMJg6qSoj2cZJMCq1AJR5bk2GQPe8A9q2V9GV7Kz/jZbyIA03ZKAaah65EemQklMdwQ+wPYSXp/Q1DKT4TzII9dQDqv0fUQafvhSK5Gt+q7u5N128ueXikhxEaIMp8Sied4KLiEOxFQuYc8zCxAcdonhbB1wu4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634301; c=relaxed/simple;
	bh=EuQPfIaWeStx0kA9Y+KZIyPy1SKitUMVKefBOhzbIps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nayJ5bBs3nL6D/lB6w1kp1HIQVDZjSMKfnYNykVBTemqg2Q0wBxXsgwRZ1NHMADFkVKVISSFkSCXxP0et12+cIFw6HLQjN63aqIerH4TFRINQGP+isTdQciYgk/4FPi1s+SabWerNo/7TCXu+2A7QNmxg0DwHjY3hrKm55lKXys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9Ee9Ot4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9Ee9Ot4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F081F000E9;
	Tue, 16 Jun 2026 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634300;
	bh=Ew2IUvP5/tAY0drFZO18RvNQ78s2blUi7BGxjLTeMjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9Ee9Ot43gqPDwio/D5W3l/yBjNLiGK1Ek55P6PlBmhdDj3yAkUngmCWOd4FWO3h4
	 EEOLFxNcPxlK1CJjuRqSDtL5Q/TlO+y+AliQuYTpUkXFxsSYPBAiteaUKLgjni0nzK
	 GIHgwEx7lAfdiWlBhjH/Gz4pSUlUKWslXMJ8Vk7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Guillermo=20Rodr=C3=ADguez?= <guille.rodriguez@gmail.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 222/411] i2c: stm32f7: fix timing computation ignoring i2c-analog-filter
Date: Tue, 16 Jun 2026 20:27:40 +0530
Message-ID: <20260616145112.603998958@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -673,6 +673,9 @@ static int stm32f7_i2c_setup_timing(stru
 	if (!of_property_read_bool(i2c_dev->dev->of_node, "i2c-digital-filter"))
 		i2c_dev->dnf_dt = STM32F7_I2C_DNF_DEFAULT;
 
+	i2c_dev->analog_filter = of_property_read_bool(i2c_dev->dev->of_node,
+						       "i2c-analog-filter");
+
 	do {
 		ret = stm32f7_i2c_compute_timing(i2c_dev, setup,
 						 &i2c_dev->timing);
@@ -694,9 +697,6 @@ static int stm32f7_i2c_setup_timing(stru
 		return ret;
 	}
 
-	i2c_dev->analog_filter = of_property_read_bool(i2c_dev->dev->of_node,
-						       "i2c-analog-filter");
-
 	dev_dbg(i2c_dev->dev, "I2C Speed(%i), Clk Source(%i)\n",
 		setup->speed_freq, setup->clock_src);
 	dev_dbg(i2c_dev->dev, "I2C Rise(%i) and Fall(%i) Time\n",


