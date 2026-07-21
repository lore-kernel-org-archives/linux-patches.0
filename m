Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EFD42EEA2;
	Tue, 21 Jul 2026 19:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660852; cv=none; b=fGAizasfNKOr0t6gHgh24Xz4mn2pkkW9B27RwjO80OJFTPn0ZnMG3tx1A3MJKchz9P6K1xg+p0pL+YpnfGbBaZTdaG1GXxvXPHSZIH3DAkdJxuAZKCW+QI1AQV2Cdjsh8E4x8kR/Ivx0wwjUAASy0yh1Ghus010G18QGgXh7IQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660852; c=relaxed/simple;
	bh=voisOzT2bJsrsn09YXgoabbiqDofMmnUbBbZl1G3tvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oStVFfMrtepo0MnYHyqkQ87X1fgYcmsbxY+ZdHSfDLivFObiumo87bQs04/cWsLid2pi/cwcBf+TpUSYqAYdmzxzgqJwnGV6INrsHlpbEWTJgAwfACbq7U4tCJabAW4oBP+fAij7EWkww4pewUhMkOLR4Dq7BGlnzPG8TFwJzNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAe2adPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAe2adPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EA01F000E9;
	Tue, 21 Jul 2026 19:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660851;
	bh=hRZ8RRvxk+e439OdBfLkIdNwBQTN09CktOWA6WmVpag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAe2adPiAzMLJ+/b8+SNRubY/ls4SRftNDaiujbhMv8Nwl3mk6Y/9K4nVq6h+f186
	 dTzQwqqN2SzScM89NQBs1zBjROxYKl2NVCKAHb1MI80gE+XOQNJj36mf3cu9FH+JJi
	 ANf11fWPM2a1ifTpJ+wt47hTSUwYen8G54mJFIb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1135/2077] ACPI: IPMI: Fix inverted interface check in ipmi_bmc_gone()
Date: Tue, 21 Jul 2026 17:13:28 +0200
Message-ID: <20260721152619.592701080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 71b57aca295d61276a60e131d8f62b0cc7cf1a35 ]

Before commit a1a69b297e47 ("ACPI / IPMI: Fix race caused by the
unprotected ACPI IPMI user"), ipmi_bmc_gone() skipped entries whose
interface number did not match the SMI being removed, then killed the
matching entry:

	if (ipmi_device->ipmi_ifnum != iface)
		continue;

	__ipmi_dev_kill(ipmi_device);

That commit folded the removal block into the existing non-match test
while converting the object lifetime handling, but left the comparison
unchanged. The old != meant "continue past this entry"; after the
refactor it meant "kill this entry".

As a result, a single ACPI IPMI interface is never removed when its SMI
disappears. If multiple interfaces are tracked, the first interface
whose number differs from iface is removed instead, while the interface
that actually disappeared remains on driver_data.ipmi_devices. The
stale entry is not marked dead and can continue to be selected for ACPI
IPMI transactions. It can also prevent the same ACPI handle from being
registered again.

Change the comparison to == so ipmi_bmc_gone() removes exactly the
interface reported as gone by the SMI watcher. This restores the
pre-a1a69b297e47 behavior and is the correct interface matching logic.

Fixes: a1a69b297e47 ("ACPI / IPMI: Fix race caused by the unprotected ACPI IPMI user")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/B486593E06E6F6E0+20260616093621.1039943-1-raoxu@uniontech.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_ipmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 79ce6e72bf295a..2dbed92d54b30d 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -490,7 +490,7 @@ static void ipmi_bmc_gone(int iface)
 	mutex_lock(&driver_data.ipmi_lock);
 	list_for_each_entry_safe(iter, temp,
 				 &driver_data.ipmi_devices, head) {
-		if (iter->ipmi_ifnum != iface) {
+		if (iter->ipmi_ifnum == iface) {
 			ipmi_device = iter;
 			__ipmi_dev_kill(iter);
 			break;
-- 
2.53.0



