Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDA12144C1;
	Wed,  7 May 2025 19:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645001; cv=none; b=O3tOb/xgffG0SxtqEPsipJSi1L4ZGuHzitLYfzZ+v2OuTKtcAEb0vlDbhnulyujqQ0SI/RTMU/ZocA+9FVGHUOVqXL8B2CBOKnH6SpULKWDFrn6Ix+ISFtHQJLCmxHIPwU8XPHKFZG5p/AvScJj8Mjk2LXo7cfSpHpXqeEw95qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645001; c=relaxed/simple;
	bh=yP/CZ9+lbkJZD4VuOpROJft6ddEedhIiDNaoy4kjEnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4yKU/v7S0DerLeQyunHNJtgr29qW5oeK5cCNrzUbicY+5kMBtf+QWK+YOzeSbkTLAZOGFtJjLfbArpYaIEP497Kc66oQ+lHJX4qPJKGKuocRo36hi2uxNZ2gAhv/msph6vpO5nDhaOsOgEIl6C0H5wh/ZtqWZ/xfo8T2z7ZYBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjOroSBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjOroSBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA95C4CEE2;
	Wed,  7 May 2025 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645001;
	bh=yP/CZ9+lbkJZD4VuOpROJft6ddEedhIiDNaoy4kjEnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjOroSBh3A0roUgEQGf4elt1NWjEGZDlOoVd5+mvPQl4ds0TdR/UVZ8Hebdxn5fk4
	 YfLami3nrWWATJdYFiCmiJAfcxOuMRx/vBQNSa0sFeJWd2cTW2GOzw0EffuJRXUjXD
	 AUOf0UC+aRZmIvOkx1cA0btmUa0ra8yy+9PTjORM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/129] pds_core: check health in devcmd wait
Date: Wed,  7 May 2025 20:39:59 +0200
Message-ID: <20250507183816.077942689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit f7b5bd725b737de3f2c4a836e07c82ba156d75df ]

Similar to what we do in the AdminQ, check for devcmd health
while waiting for an answer.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dfd76010f8e8 ("pds_core: remove write-after-free of client_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/dev.c | 11 +++++++++--
 include/linux/pds/pds_core_if.h         |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index f0e39ab400450..e65a1632df505 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -42,6 +42,8 @@ int pdsc_err_to_errno(enum pds_core_status_code code)
 		return -ERANGE;
 	case PDS_RC_BAD_ADDR:
 		return -EFAULT;
+	case PDS_RC_BAD_PCI:
+		return -ENXIO;
 	case PDS_RC_EOPCODE:
 	case PDS_RC_EINTR:
 	case PDS_RC_DEV_CMD:
@@ -65,7 +67,7 @@ bool pdsc_is_fw_running(struct pdsc *pdsc)
 	/* Firmware is useful only if the running bit is set and
 	 * fw_status != 0xff (bad PCI read)
 	 */
-	return (pdsc->fw_status != 0xff) &&
+	return (pdsc->fw_status != PDS_RC_BAD_PCI) &&
 		(pdsc->fw_status & PDS_CORE_FW_STS_F_RUNNING);
 }
 
@@ -131,6 +133,7 @@ static int pdsc_devcmd_wait(struct pdsc *pdsc, u8 opcode, int max_seconds)
 	unsigned long max_wait;
 	unsigned long duration;
 	int timeout = 0;
+	bool running;
 	int done = 0;
 	int err = 0;
 	int status;
@@ -139,6 +142,10 @@ static int pdsc_devcmd_wait(struct pdsc *pdsc, u8 opcode, int max_seconds)
 	max_wait = start_time + (max_seconds * HZ);
 
 	while (!done && !timeout) {
+		running = pdsc_is_fw_running(pdsc);
+		if (!running)
+			break;
+
 		done = pdsc_devcmd_done(pdsc);
 		if (done)
 			break;
@@ -155,7 +162,7 @@ static int pdsc_devcmd_wait(struct pdsc *pdsc, u8 opcode, int max_seconds)
 		dev_dbg(dev, "DEVCMD %d %s after %ld secs\n",
 			opcode, pdsc_devcmd_str(opcode), duration / HZ);
 
-	if (!done || timeout) {
+	if ((!done || timeout) && running) {
 		dev_err(dev, "DEVCMD %d %s timeout, done %d timeout %d max_seconds=%d\n",
 			opcode, pdsc_devcmd_str(opcode), done, timeout,
 			max_seconds);
diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
index e838a2b90440c..17a87c1a55d7c 100644
--- a/include/linux/pds/pds_core_if.h
+++ b/include/linux/pds/pds_core_if.h
@@ -79,6 +79,7 @@ enum pds_core_status_code {
 	PDS_RC_EVFID	= 31,	/* VF ID does not exist */
 	PDS_RC_BAD_FW	= 32,	/* FW file is invalid or corrupted */
 	PDS_RC_ECLIENT	= 33,   /* No such client id */
+	PDS_RC_BAD_PCI	= 255,  /* Broken PCI when reading status */
 };
 
 /**
-- 
2.39.5



