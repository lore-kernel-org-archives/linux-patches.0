Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E111C31578E;
	Fri,  7 Aug 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114162; cv=none; b=NGVV64SJnS2f4KZT+AQYy2eLEXvGwffBF/nFjXhNZGKwDw9c/bq+YkLTQxd5Vr93VEZbdLxcferx1SzSoWnQtYHbkrIGPIUdaDClc3nJM/l5j6G0C5oi43JaqhrFSvNUEd6RqN8277Lh6HliyPBVBYM1PAl3A4n+F5YfQtBcddI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114162; c=relaxed/simple;
	bh=SO/VvQVLx8bQXstk1KzVhnhkNNUPZ993C0a7X6zrc8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovZdJrChV2Gf2Wr6e5/g7BmbDNpBAh7Gr2kvn4R9a/dUgWVI8YlcBwlmCS9C136Tlws/b2QnmqMPkTsRN78gm2ISZagHxU1AF17mf9Gajh7hBS0b+aCAE7IRCUXxSWqU4BE628xSkccpldOSGSgKKm4ApWZ84+v2L+dFq9qatBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIJH9RHn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIJH9RHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497181F000E9;
	Fri,  7 Aug 2026 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114161;
	bh=uoWHrPJGnlMb5dTdjC/9/Ez21wZWlke3dUOwhdPfews=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIJH9RHntMLQphhl+yp5g/80XQ+QBDix77Q7P+tQqMW2CTMnw7ye+kLJpKmj7GyRK
	 cz5ET0jJSJUU5bcITuBwmoOgcTUaTcq8LFJnn0Qs5zOmIlc0Doxk4vH+GRdPXgQpY1
	 v86ILacCpijbeFSW2w4n4DOpjV69y0TdBQ0jcnsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 164/337] ata: libata-sata: fix ata_scsi_lpm_supported() iteration
Date: Fri,  7 Aug 2026 16:36:07 +0200
Message-ID: <20260807143422.107348726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

commit 3fd70e96914d761c17c376aadd0b0d1a3c9badba upstream.

The inner loop of ata_scsi_lpm_supported() uses the wrong variable when
iterating.

It should obviously use the link that we are currently iterating over,
rather than always using the host link.

ata_scsi_lpm_supported() is used to control if a user should be allowed
to change lpm policy (from the default) via sysfs.

Thus, this bug could potentially disallow users to change the LPM policy
for certain SATA devices via sysfs.

Cc: stable@vger.kernel.org
Fixes: 0060beec0bfa ("ata: libata-sata: Add link_power_management_supported sysfs attribute")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-ide/20260728112200.B99F21F000E9@smtp.kernel.org/
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-sata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b0706c30da05..ad40f516c6d4 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -913,7 +913,7 @@ static bool ata_scsi_lpm_supported(struct ata_port *ap)
 		return false;
 
 	ata_for_each_link(link, ap, EDGE) {
-		ata_for_each_dev(dev, &ap->link, ENABLED) {
+		ata_for_each_dev(dev, link, ENABLED) {
 			if (dev->quirks & ATA_QUIRK_NOLPM)
 				return false;
 		}
-- 
2.55.0



