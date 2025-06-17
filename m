Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65512F2343;
	Tue, 17 Jun 2025 16:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177944; cv=none; b=nCRWw9utbKNxaJaAcLjiwMuWAqq1FNcQob+H2KkzgxpZwUW9L5ki9klsrNx17xRhcnvodWAx7r8pdiCCK71Yl8xPM5q+79CDM/QumWFPH39TadEjW4cVqBXoGeuhTc/KXWleOoe3wvVEly1czh7OfGX+j7BSPPdvpCNQEpkNzOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177944; c=relaxed/simple;
	bh=Oid3nVWEbLTz+/35mb7E7C03s2nN1ZPKfac2gkHrcFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWfm4xs6sfaruGq+T6wLdCsos+1oVZB0J/Y1Fsfm3x6BAOQe42LORlYqzickkpWUlNiXSQC/1KXyRanoKeUujzO2ZQQpEOU9xqiUBhflO2Tc5vEVv7hsb3lKV5zZ2qMrZT3r7oJk3Jcj6sd4Wl+6rHIfUfUa6Mk9WeOy8wCIJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG6zaD+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG6zaD+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FACC4CEE7;
	Tue, 17 Jun 2025 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177944;
	bh=Oid3nVWEbLTz+/35mb7E7C03s2nN1ZPKfac2gkHrcFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YG6zaD+ZU2E6wsSmrcQku781mJETr/FYfWGFOw+nK9oRSDfTmzpoDGsF4+ydyDCRy
	 gy/oGgC0oTp2i+7V/06n/o/Gigs9Wg5nZ8LgbWcY8zkPvY8wT+0oLmp/VuL8UWpZyb
	 atafA3UUgUiHsMCux1O3r5OBoR7sTB5cnhJUHAeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 422/512] Bluetooth: btintel_pcie: Reduce driver buffer posting to prevent race condition
Date: Tue, 17 Jun 2025 17:26:28 +0200
Message-ID: <20250617152436.673106340@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit bf2ffc4d14db29cab781549912d2dc69127f4d3e ]

Modify the driver to post 3 fewer buffers than the maximum rx buffers
(64) allowed for the firmware. This change mitigates a hardware issue
causing a race condition in the firmware, improving stability and data
handling.

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index c02d671396e24..34812bf7587d6 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -233,7 +233,11 @@ static int btintel_pcie_start_rx(struct btintel_pcie_data *data)
 	int i, ret;
 	struct rxq *rxq = &data->rxq;
 
-	for (i = 0; i < rxq->count; i++) {
+	/* Post (BTINTEL_PCIE_RX_DESCS_COUNT - 3) buffers to overcome the
+	 * hardware issues leading to race condition at the firmware.
+	 */
+
+	for (i = 0; i < rxq->count - 3; i++) {
 		ret = btintel_pcie_submit_rx(data);
 		if (ret)
 			return ret;
-- 
2.39.5



