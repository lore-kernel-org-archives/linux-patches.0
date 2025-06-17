Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8B82264D6;
	Tue, 17 Jun 2025 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178848; cv=none; b=q2bfROzfnFmYzTl3GuIw/aXR/6uZ3iWZ0SdTeyjBJ6c6BJnPypeS5tTNIEkZtV9TSEzIzC24ie7sifhi1euwr1+TL5QTD4TdqASbm3S+tzV4exT4XTpMmPJPL/rKp5Py7qVniWlB3y49HvPr4vJI9vPI2uDPMeQXHq1mRqqOqMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178848; c=relaxed/simple;
	bh=T/op/sRBRW2D8enociCh9gc9eGDTt5qdEj4CXCC+COM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTvUgvDAxW99bIpPN2uin08DCrsI6of+Gc7EVAGjZBWh0JBbshCLXbFsoZwvkotWnHI6yqX46tqeOeVIKYVbu+UPXlgmZ2syRpm1tXQjCCaqe1ISJ97KI5pezflZbpoStEx6RdczQnHzf8zJZZ6xt8LQGD2P6kxoVdgF+H6EOeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eitw6sjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eitw6sjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FF1C4CEE7;
	Tue, 17 Jun 2025 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178848;
	bh=T/op/sRBRW2D8enociCh9gc9eGDTt5qdEj4CXCC+COM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eitw6sjf2A8xcsuJg9Om/Lxr/Q5jdlD7mGYIiv9KAQwzXu9ZXd/1Ud4dC5I8jeEzW
	 rVvl30EOJEmq3T5GoQWuZqq+GpbdP0tFuQZLin+NzDQCUrMoXuuKpDsg4Rl1GBzerV
	 bwDUgjKO8NzUoSfbYV2nuZU1DhyDWDQYx0fNUFF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 543/780] mei: vsc: Cast tx_buf to (__be32 *) when passed to cpu_to_be32_array()
Date: Tue, 17 Jun 2025 17:24:11 +0200
Message-ID: <20250617152513.623657933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 97ce0fe2b7240d47d9124daa92217e478c21a3ba ]

Commit f88c0c72ffb0 ("mei: vsc: Use struct vsc_tp_packet as vsc-tp tx_buf
and rx_buf type") changed the type of tx_buf from "void *" to "struct
vsc_tp_packet *" and added a cast to (u32 *) when passing it to
cpu_to_be32_array() and the same change was made for rx_buf.

This triggers the type-check warning in sparse:

vsc-tp.c:327:28: sparse: expected restricted __be32 [usertype] *dst
vsc-tp.c:327:28: sparse: got unsigned int [usertype] *

vsc-tp.c:343:42: sparse: expected restricted __be32 const [usertype] *src
vsc-tp.c:343:42: sparse: got unsigned int [usertype] *

Fix this by casting to (__be32 *) instead.

Note actually changing the type of the buffers to "be32 *" is not an option
this buffer does actually contain a "struct vsc_tp_packet" and is used
as such most of the time. vsc_tp_rom_xfer() re-uses the buffers as just
dumb arrays of 32 bit words to talk to the device before the firmware has
booted, to avoid needing to allocate a separate buffer.

Fixes: f88c0c72ffb0 ("mei: vsc: Use struct vsc_tp_packet as vsc-tp tx_buf and rx_buf type")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505071634.kZ0I7Va6-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20250507090728.115910-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index da26a080916c5..267d0de5fade8 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -324,7 +324,7 @@ int vsc_tp_rom_xfer(struct vsc_tp *tp, const void *obuf, void *ibuf, size_t len)
 	guard(mutex)(&tp->mutex);
 
 	/* rom xfer is big endian */
-	cpu_to_be32_array((u32 *)tp->tx_buf, obuf, words);
+	cpu_to_be32_array((__be32 *)tp->tx_buf, obuf, words);
 
 	ret = read_poll_timeout(gpiod_get_value_cansleep, ret,
 				!ret, VSC_TP_ROM_XFER_POLL_DELAY_US,
@@ -340,7 +340,7 @@ int vsc_tp_rom_xfer(struct vsc_tp *tp, const void *obuf, void *ibuf, size_t len)
 		return ret;
 
 	if (ibuf)
-		be32_to_cpu_array(ibuf, (u32 *)tp->rx_buf, words);
+		be32_to_cpu_array(ibuf, (__be32 *)tp->rx_buf, words);
 
 	return ret;
 }
-- 
2.39.5



