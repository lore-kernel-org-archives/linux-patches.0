Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7A545D82;
	Wed,  9 Sep 2026 13:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962010; cv=none; b=jfbxtYDx8z0CWXgFfi1OQ3jNCfEqXqGCrWeQ06PJWCW5YFhXuaIbwQ4Fp6BJSJyOlGT8mYxBrV85P9OUF5vlnO1cTCUy8tWRnIPyJcgc+CyKipeTxHkcgaGsvTQFYOvMd79UUnen4abfz4wCyhVMdhK6aCQ16j029NKIPhHFwhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962010; c=relaxed/simple;
	bh=MGR4KDvPYaoAxAVgxZKnHewBgk9H0Si8dqwhsybT35M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bek45qth86W4hSF1w9Hlg4Do26QQcNH81QEDSa/Lk3PfpB2V3S4a9F5Jf1Euuv61yEBQk6+F0YzyxNWVlD8I3EDIcIr6ougCF3LHWRa+FsSRC+TYyJDmWCMZrmfsvItu0MI8orY5+cJ1V9NuQXy649n37d+fep+5TwyakjM1VFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XpyrJaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XpyrJaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D311F00A3A;
	Wed,  9 Sep 2026 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962007;
	bh=ZiXt3Ky6zijbCYnIERqdT8uP6QAUp4SAivDXnb/lA7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XpyrJafDVRHLvTd+AJQ181m8egONdBzVXgwt8taPKHlALgNvK6RrEGMR507+/dHF
	 TpLMeZpvuLGaI+PZODPzu/XKUZ6BsbLJyBmpMPhzdPp+9X0lhRCGxvQ+jnbzz5rsO2
	 rA1kRkM/qCBGv6gtG7AhUViLiftCI/0LtGIHN0GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Yao <andy.xu@hj-micro.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 141/556] i2c: designware: Enable interrupt mask workaround for HJMC3001
Date: Wed,  9 Sep 2026 15:37:01 +0200
Message-ID: <20260909134235.412732883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Yao <andy.xu@hj-micro.com>

commit 77549d01edecc20da73c8599e14648877198ce9b upstream.

On HJMicro ARM64 servers, the DesignWare I2C controller does not
retrigger a pending interrupt if the interrupt status changes after
the current status bits have been cleared.

The issue is exposed under heavy system load when the corresponding
SPI is routed across sockets to a core in the remote socket. The
interrupt is then lost and the I2C transfer times out.

Enable ACCESS_INTR_MASK for HJMC3001. This toggles DW_IC_INTR_MASK
before returning from the interrupt handler and retriggers any
pending interrupt.

Fixes: 6816ce57c479 ("i2c: designware: Add a new ACPI HID for HJMC01 I2C controller")
Signed-off-by: Hongbo Yao <andy.xu@hj-micro.com>
Cc: <stable@vger.kernel.org> # v6.13+
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260826070547.268672-1-andy.xu@hj-micro.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -272,7 +272,7 @@ static const struct acpi_device_id dw_i2
 	{ "HISI02A1", 0 },
 	{ "HISI02A2", 0 },
 	{ "HISI02A3", 0 },
-	{ "HJMC3001", 0 },
+	{ "HJMC3001", ACCESS_INTR_MASK },
 	{ "HYGO0010", ACCESS_INTR_MASK },
 	{ "INT33C2", 0 },
 	{ "INT33C3", 0 },


