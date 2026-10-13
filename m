Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C343360EF0;
	Tue, 13 Oct 2026 12:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895316; cv=none; b=EE8g+ercEPTEjSg6DroAX4Gf2cCPmx+Q2tZ0+F9B6wgFBgf5vHs1lwpBixv96LJT5NALZi2Y7Upm/G+n3wMWcgX7j1JFFWUlqwkM0m/VpRgppNRXPWNulmT2lvg0DEnMyCuCiZjUb4jBa8Zs9wc3q8a53OL+P0bJqEevN8sxSXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895316; c=relaxed/simple;
	bh=AfqKYkqPmZn5avgjCyVqVqe+rEIvLZ4MjLHO4hmFuJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSPQ6MuDMC3LErT59cYdaheFdz9lUQXafxH40vnKePaxvVcKCNlSm5djZWWleM5B6OAADFmrTpbPULtzl53UtvKJGJifTfIvUzfDLT0XA3J7BvBn84UNCQ46C0IPIfYimtIPmAQsEVhEXJYm3Bnv0TOdVnPhlffBO5gl04zEhWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iR7OhSaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iR7OhSaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A507B1F00893;
	Tue, 13 Oct 2026 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895315;
	bh=aDTWYTAxTdHdS8Qd0n1g2zGpk9SBLylTUwXsOcv//aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iR7OhSaKhE2WmPsUKJ4NG6x6Fn2vzBrM1mjJLdmNAsCaYciaZDeWBSRGSQr5aqBKZ
	 vBqT/GabUycrM/UEB0R2r95U6QI/+4MoKmKPuh6Jf/8pXPJNWAiVxzvpk98GpkYhtT
	 D9tTsiUnDC5U7BXwUyXuRslDn2bmZqeHp6keR7es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Lieber <kurt@lieber.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 226/497] thunderbolt: Disable CL states for the Anker Prime TB5 dock
Date: Tue, 13 Oct 2026 13:36:33 +0200
Message-ID: <20261013112913.258567710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Kurt Lieber <kurt@lieber.org>

commit 395e9f2967a7ac6898026e8f136c369805dc2fd9 upstream.

The Anker Prime TB5 dock identifies itself in the DROM as 01ea:83b5.
Its router config space is an Intel Barlow Ridge 80G hub (8087:5786).
The upstream lane adapter advertises CL0s, CL1, and CL2. With CLx left
enabled, TMU uni-directional LowRes setup fails with -ENOTCONN, the USB3
and DisplayPort tunnels are aborted, and the router reconnects in a loop.
Loading thunderbolt with clx=0 keeps the link up on this machine.

Match the DROM id together with the Barlow Ridge hub id and disable CL
states for this dock only. QUIRK_NO_CLX takes the same early-out as the
module parameter, without disabling CLx for every other router.

Closes: https://lore.kernel.org/linux-usb/SJ0PR15MB4696D491504DB667AA8E0617A3812@SJ0PR15MB4696.namprd15.prod.outlook.com/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Kurt Lieber <kurt@lieber.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -92,6 +92,9 @@ static const struct tb_quirk tb_quirks[]
 		  quirk_usb3_maximum_bandwidth },
 	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_40G_BRIDGE, 0x0000, 0x0000,
 		  quirk_usb3_maximum_bandwidth },
+	/* CLx is unstable on the Anker Prime TB5 dock (DROM 01ea:83b5) */
+	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_80G_BRIDGE, 0x01ea, 0x83b5,
+		  quirk_clx_disable },
 	/*
 	 * Block Runtime PM in DP redrive mode for Intel Barlow Ridge host
 	 * controllers.


