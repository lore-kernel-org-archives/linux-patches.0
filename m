Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA153B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2860BC433C9;
	Wed,  9 Aug 2023 10:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578449;
	bh=4r/gPKm8RhZ12hkDca9EgcaHoF/eESdU0IKNTZ5h8Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFxya5GwQTiavco8QFKIoKmz8mKqTiLHKgGKKk+uAtvkvC3mQ0C3pQp+gHozXr4sq
	 bWRf34MjA7cY43XoELeyIc2a498qckqMFJLflTJ0CVGRMVAH4NVCxUSea6cRRSY0dI
	 lW1+/NtdNtLtfMLoCw+IDHNXiNTeU9yvKQ9s6KPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@bisdn.de>,
	Elad Nachman <enachman@marvell.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Taras Chornyi <taras.chornyi@plvision.eu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/127] prestera: fix fallback to previous version on same major version
Date: Wed,  9 Aug 2023 12:40:50 +0200
Message-ID: <20230809103638.752152587@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Gorski <jonas.gorski@bisdn.de>

[ Upstream commit b755c25fbcd568821a3bb0e0d5c2daa5fcb00bba ]

When both supported and previous version have the same major version,
and the firmwares are missing, the driver ends in a loop requesting the
same (previous) version over and over again:

    [   76.327413] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.1.img firmware, fall-back to previous 4.0 version
    [   76.339802] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.352162] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.364502] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.376848] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.389183] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.401522] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.413860] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    [   76.426199] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.0.img firmware, fall-back to previous 4.0 version
    ...

Fix this by inverting the check to that we aren't yet at the previous
version, and also check the minor version.

This also catches the case where both versions are the same, as it was
after commit bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0
support").

With this fix applied:

    [   88.499622] Prestera DX 0000:01:00.0: missing latest mrvl/prestera/mvsw_prestera_fw-v4.1.img firmware, fall-back to previous 4.0 version
    [   88.511995] Prestera DX 0000:01:00.0: failed to request previous firmware: mrvl/prestera/mvsw_prestera_fw-v4.0.img
    [   88.522403] Prestera DX: probe of 0000:01:00.0 failed with error -2

Fixes: 47f26018a414 ("net: marvell: prestera: try to load previous fw version")
Signed-off-by: Jonas Gorski <jonas.gorski@bisdn.de>
Acked-by: Elad Nachman <enachman@marvell.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Taras Chornyi <taras.chornyi@plvision.eu>
Link: https://lore.kernel.org/r/20230802092357.163944-1-jonas.gorski@bisdn.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 59470d99f5228..a37dbbda8de39 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -702,7 +702,8 @@ static int prestera_fw_get(struct prestera_fw *fw)
 
 	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
 	if (err) {
-		if (ver_maj == PRESTERA_SUPP_FW_MAJ_VER) {
+		if (ver_maj != PRESTERA_PREV_FW_MAJ_VER ||
+		    ver_min != PRESTERA_PREV_FW_MIN_VER) {
 			ver_maj = PRESTERA_PREV_FW_MAJ_VER;
 			ver_min = PRESTERA_PREV_FW_MIN_VER;
 
-- 
2.40.1



