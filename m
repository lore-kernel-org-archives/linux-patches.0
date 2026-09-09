Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BFE56E054;
	Wed,  9 Sep 2026 14:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963493; cv=none; b=Bo9cp3q97v8oqsO0uXpQB5XXyQWyjJqz5VzL9ZlVsXe7AIPepDuWu9pYphlbt1q0Gz7vR+Hs9iHJWuwuVFpych/MrZNqJFHeCJUAbYJ/KaIp3qeeo5jo2xF+jR6Jq1seYCkXwfv436BcAG9mKSaFASVvsXnpUvejPfrJAdju4d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963493; c=relaxed/simple;
	bh=I4vJT/WJGVyS1tL/QIOG+VwWg4l03X6gcUEXhOUPZ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkzHjT0CWFgWRhwnNtBVN0Sz8jsCUXsb2l+bbB0QmIvaoz18mfOMLWkH4NQo3NdeXKqOh2r8FnvcK+O/99DCaRHDE7Fiz/K7TEWGu1lx3TmhsIz8hcmOLf1BwjJWq/0gDmmwT/rcgE+Ti13CrChgttdDHz90CGup2IiWhpdZo7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGocXB5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGocXB5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D6C1F00A3E;
	Wed,  9 Sep 2026 14:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963491;
	bh=wOvN7t+Di7CzUHwpncNyX3LKiHjZOk7bUJvNebErH/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGocXB5vDQyOWYlkDyL3Haa0caM7KaU+V+A8Ffh8FcBnFFv/srPYdUQU5jI2osbWr
	 0zOv8dCPahNlZX+OVJyz9K7JVZxLmjqFAuVt3aEbfiOGDBaSEvz3cMgM3LBOn67b38
	 +qIVduDc1oWBnBhISMPpdk7XfJYGOUkk+0//MkNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Yao <andy.xu@hj-micro.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 097/583] i2c: designware: Enable interrupt mask workaround for HJMC3001
Date: Wed,  9 Sep 2026 15:36:22 +0200
Message-ID: <20260909134241.487968890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -364,7 +364,7 @@ static const struct acpi_device_id dw_i2
 	{ "HISI02A1", 0 },
 	{ "HISI02A2", 0 },
 	{ "HISI02A3", 0 },
-	{ "HJMC3001", 0 },
+	{ "HJMC3001", ACCESS_INTR_MASK },
 	{ "HYGO0010", ACCESS_INTR_MASK },
 	{ "INT33C2", 0 },
 	{ "INT33C3", 0 },


