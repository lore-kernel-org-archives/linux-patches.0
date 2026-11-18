Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061727;
	b=r3H42lfiOlhL0tt+lqcdL72TYw9k9IdG8fQVCQOhmDkyN4LNlI4JgD6c2hgqoVccCOAX
	 dNspS+91xbWmlhKrafd6YzJZ3Z0G+VtNIQ4M8+v8k+qWJV/M8WwceRPS3Zi8Vyrqaynfn
	 Gm/g6k0gs2lFoBOq2uU8074ekRgp3P4Z0mlvgY4XAZ1SBBAvE/xptzt/9dOqFC6p+J83d
	 Ag7nhMKtFWUy5DLiaA32dVIq4rFmKIJJeOPZ/r/kmdaU7wwcH9jEOnjb1CV9wLhdRDKGP
	 pj6stKi4P9qeBoEpFN/EOVokbZgoJXycnLEHza2xO+n3FuujmxwkBmPsszG9kt7wiPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mqqEkuVAptFQzxJoN26wELXVr9DGFZnA4Gsk458AZbg=;
	b=st1VDV9lepxsC9hpyy8zFJRCkAn1GJWdVcAlNPLF8CdvkyUApY22RnfdzWSHS0tKCy7U
	 I7xTHCdhAUag5JxfWl54qSWqUeqmD0BRA6Z531EFIklBMvnheCmgWu0j6teW5lv+iGSVP
	 VimWmbBg408n3gbVadDfV7ehrIpfrRFYCLzDO0tYckPcr+Ec8gCygn7I6BHna46weCfjA
	 5tNFkC3t6Dq/CMqj3ersGpRDu14YoTSpASym2HtCye5wnc7fvIGSgViruLhHwsSLugoe2
	 3FpDLO8crdfJf9ELbUxyxzOQkWTpFCSODjvL94GklH51PSdB+Wl2PQi/4yQ5+/E+UeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkkQ9S+A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D481D606A32A;
	Thu, 19 Nov 2026 04:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkkQ9S+A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4101F000C4;
	Thu, 19 Nov 2026 04:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061727;
	bh=mqqEkuVAptFQzxJoN26wELXVr9DGFZnA4Gsk458AZbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkkQ9S+A/bmgkL4WaWZNLGAVWaqZIVkGr6ja/OUv8Z+ljmHdTBDmpR0jfOTLMgJcc
	 +L7qXlMROMTdZiGYUT98CmlfoqkUP3WVewQsVaxE7JerSAmTBQr34Y25/E3wwfrlSD
	 NGAJ4CiknKYdR1gS2no+B0Sfh6MhVWT6/ENT79/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1657/1848] ata: libahci: re-enable FBS after error handling on a port multiplier
Date: Wed, 18 Nov 2026 16:01:35 +0100
Message-ID: <20261118150029.084899731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyrylo Biryuk <illofspeed@gmail.com>

[ Upstream commit 23eab9e877497397a0e2394ee9174d576816209e ]

ahci_do_softreset() disables FBS before resetting a device behind a port
multiplier, as required by AHCI 1.2 section 9.3.9, and re-enables it only
when that softreset succeeds. If it fails, for example because a
hot-plugged drive is still spinning up ("softreset failed (device not
ready)"), EH escalates to a hardreset of the PMP link, and nothing turns
FBS back on: only ahci_pmp_attach() does, which runs at the next boot.
The port keeps working with command-based switching until then.

Seen on a Marvell 88SE9235 (1b4b:9235) with Marvell 88SM9705 port
multipliers (1b4b:9705, in a Synology DX1222 expansion unit): after
hot-plugging a drive, the kernel logged "FBS is disabled" followed by
"softreset failed (device not ready)" and a PMP hardreset, and never
"FBS is enabled" again (twice, on two different ports).

At the end of ahci_error_handler(), re-enable FBS if a PMP is still
attached and FBS is supported but disabled.

Fixes: 89dafa20f3da ("ahci: disabled FBS prior to issuing software reset")
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261012103917.389-1-illofspeed@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index b51fdee5c3989..db7c29ac1ac82 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2095,6 +2095,21 @@ void ahci_error_handler(struct ata_port *ap)
 
 	sata_pmp_error_handler(ap);
 
+	/*
+	 * ahci_do_softreset() turns FBS off before resetting a fan-out link
+	 * and turns it back on only if that reset succeeds. When it fails
+	 * (e.g. a hot-plugged drive is still spinning up), EH escalates to a
+	 * PMP hardreset, which never re-enables FBS, so the port would keep
+	 * command-based switching until the PMP is attached again (reboot).
+	 * Restore FBS once recovery is done and the PMP is still attached.
+	 */
+	if (sata_pmp_attached(ap) && ata_dev_enabled(ap->link.device)) {
+		struct ahci_port_priv *pp = ap->private_data;
+
+		if (pp->fbs_supported && !pp->fbs_enabled)
+			ahci_enable_fbs(ap);
+	}
+
 	if (!ata_dev_enabled(ap->link.device))
 		hpriv->stop_engine(ap);
 }
-- 
2.53.0



