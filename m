Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47CC52E047;
	Wed, 30 Sep 2026 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791083; cv=none; b=aHnHKO5jBbbFnBWo6vFcaMWCo6O9ZxvUoL55dxEBDOVy+OlWbZQUGqqsSr+f4EUYAQ76wvS1Poxr+7+MH41DTKJSAniDfN9rtFT/k3lDszkO7n3XfbO48MWqOA0as2T75jGTMGGB65ZJl1W2+gtLb4wAFzlnWkPuz4gwjOCP+2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791083; c=relaxed/simple;
	bh=xG5DUowCRPTg9958+OAd96ZSDUdJ90qW9HvCEOcJTVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqg513TD3EzD38Cir+bdbn2FijbCUVIWgWnYj9VR26qX7THZJ5KnOr/Ddbzvk3G0oLTSGJYMoKUDLuccTxoK8aU7dSp+tAQ5pC6ig3iuOGZWL+PBXw3qiEWZW3tlV6UbR6LhHeIQNzDvvGFBD/rViwuG4E9ufl6ZgrEJK/2vY+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHEnT05q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHEnT05q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247DB1F000FF;
	Wed, 30 Sep 2026 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791082;
	bh=oV33ms4+D7xbT2z38AswQl9i+qaDMlzO1uMem/SDjoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHEnT05quzzxUxR4XpzfOsDBnNviJuMDEMEDMUmD02GuMe9ZVeSCX71ZdGhR+uVt8
	 iGWaMRQpK++gQtyXFRVBO62eqfmX0rGyCqCgvxhbWmIEHP1SPas8xNKgWjwyJ0xDoC
	 vjHEVv8PMkRrgFZ4VVEnrXEcRIZkXIVoT0MGXbpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/752] ata: libata-pmp: add JMicron JMS562 quirk
Date: Wed, 30 Sep 2026 17:20:06 +0200
Message-ID: <20260930152401.121906311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit c62aff1174cf88e10716c7513702443c47551fc6 ]

JMicron JMS562, as used in QNAP QDA-A2AR RAID1 adapters, may
keep the exported ATA device not ready while the array is rebuilding.

In this state, libata may repeatedly try to softreset and classify
the fan-out link.  On the affected adapter, this can time out, make
PMP/SCR access fail, and eventually disable the fan-out link before
the RAID volume is exported.

A failing boot shows the fan-out link failing SRST, PMP access
timing out, SCR read failing, and the link being disabled:

  ata4.00: softreset failed (device not ready)
  ata4.15: qc timeout after 3000 msecs (cmd 0xe4)
  ata4.00: failed to read SCR 0 (Emask=0x4)
  ata4.00: failed to recover link after 3 tries, disabling

After that, the root filesystem on the exported RAID volume cannot
be found.

Add JMS562 to the existing JMicron PMP quirk that disables LPM,
avoids softreset on fan-out links, and assumes an ATA device.  This
prevents libata from dropping the exported RAID volume during rebuild
recovery.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-pmp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index ba7be3f386171..5347ed88f6386 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -446,8 +446,13 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		 * otherwise.  Don't try hard to recover it.
 		 */
 		ap->pmp_link[ap->nr_pmp_links - 1].flags |= ATA_LFLAG_NO_RETRY;
-	} else if (vendor == 0x197b && (devid == 0x2352 || devid == 0x0325)) {
+	} else if (vendor == 0x197b &&
+		   (devid == 0x0562 || devid == 0x2352 || devid == 0x0325)) {
 		/*
+		 * 0x0562: JMicron JMS562, as used in QNAP QDA-A2AR RAID1
+		 *         adapters.  The exported device may stay not ready
+		 *         while the array is rebuilding, and SRST/classify can
+		 *         time out before the RAID volume is exported.
 		 * 0x2352: found in Thermaltake BlackX Duet, jmicron JMB350?
 		 * 0x0325: jmicron JMB394.
 		 */
-- 
2.53.0



