Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC73BD64D;
	Fri,  9 Oct 2026 14:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556782; cv=none; b=fvv1BQsvsEd5gxW4zNY3TuKtT1G6cWUz/1qjHmSN9DwQ+N1o+K6qUo7ODqOoVXq0vzE57KGZkkBV5VPuceuFcCB7jHBtreHdN879X4b8U/k4bmIONBYPZzayEq75vHx2JcJQUve4yuTyAoy5k92U5sUSO9NXLDKzQb6Ub5nbWa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556782; c=relaxed/simple;
	bh=X74Q80FB0vyECt767IGXEgjerU3kITma2yPgilahnok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+1irANyPTgBT4/yESBoakG2h8pIxfxtDILmxeDU5FKC29I1aI7mtVAsbwqYRyZcl4AcF12ReA/ac34ezuzCCYK1PGwIuQJZ8G4xK1etps67DVHKEfw676xuAON/gJO2ZamRf+3YCq1j5ye1yHIZ/5fzLgxDXJgHDL9T0c5m8OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqQjlTXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqQjlTXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016191F000FF;
	Fri,  9 Oct 2026 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556781;
	bh=FLGFQEK/MM0bXmr95/k9qQzd2Pb/7NjgdG/m6OjUWuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqQjlTXAkWbdFDG/0FwZ9SN+dlA13vAlpW7SU6Ip3HCREyuBUdv7fnscOQ7/lhlja
	 P6qZC7Guk1ClHbuigBH15pLATyGQ/PuaH+9KyiS2+VuddA5o18rMB/ubleT525H9qt
	 n8zSQnzwueguLd8Yst5IZc4p/7M/93BgKsjZGdfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Lieber <kurt@lieber.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 292/403] thunderbolt: Disable CL states for the Anker Prime TB5 dock
Date: Fri,  9 Oct 2026 16:10:53 +0200
Message-ID: <20261009140959.031737993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


