Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD8946D2CB;
	Tue, 21 Jul 2026 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658865; cv=none; b=Sd1EQa08SFBP8HIqUc7DL2WCTmexWMdUbyWwqpaKRm3hiBVjjIpYuLuRziurQaYazrqcAtabO74wsmWzsRHbxx8yRexkaJCW+jlPznv09v5o71Xji6w+BPr49Odw9MgockpFWt5wuQkFmpxY6vWfESyPvos22tnMUAix81MehAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658865; c=relaxed/simple;
	bh=vtuPpb5c99rDLM+lvWfPX7sN0cY/cCV6kvT0S1ZG0P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQleyahJQUU2pltu4z8cYjZWIUPRUXrwOVtovhVAltQid9X1/OyZMS4xxuPBVZs8BPI+REsRwAXAKbXAhSM+IEneHy36pdrdETNctdD2Uc+r59xC8SlO3BxcAZqivWC8D3hXCl7cMnF/mXA4FzDO7F4jQm4rHOgSPB9Y2iNJYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/vIOU1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/vIOU1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDA11F000E9;
	Tue, 21 Jul 2026 18:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658864;
	bh=XMTgNeBRuKHa6XbhhBGgXvqGzic8Y3DTnS3s+OmnB2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/vIOU1kdOixRsHLZfUcH4aot+k2LkUs0vvJajaCAjOUK9LZ/KqkdPutURqVW8efX
	 EN80oBJ6zxFdPrtVZLxm1iORubC3buI1mvJUXWHRIT5RjnY7z3NDZsbzEDfhckm/87
	 NR1zGXDZaZwSjmkVZyQGV7CqUu2ASJ8K2qThxPZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gibson <daniel@gibson.sh>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 1298/1611] platform/x86/amd/pmc: Check for intermediate wakeup in function
Date: Tue, 21 Jul 2026 17:23:34 +0200
Message-ID: <20260721152544.641432319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gibson <daniel@gibson.sh>

commit 3bdd6fc11fbfa8249483f4b716ead51e43e3a0cd upstream.

Refactor code introduced by commit 9f5595d5f03f ("pmc: Require at
least 2.5 seconds between HW sleep cycles") to allow adding different
conditions for that delay in an upcoming change.

Signed-off-by: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611150426.3683372-2-daniel@gibson.sh
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -598,6 +598,19 @@ static int amd_pmc_verify_czn_rtc(struct
 	return rc;
 }
 
+static bool amd_pmc_intermediate_wakeup_need_delay(struct amd_pmc_dev *pdev)
+{
+	/*
+	 * Starting a new HW sleep cycle right after waking from one
+	 * can cause electrical problems triggering the over voltage protection.
+	 * That is avoided by delaying the next suspend a bit, see also
+	 * https://lore.kernel.org/all/20250414162446.3853194-1-superm1@kernel.org/
+	 */
+	struct smu_metrics table;
+
+	return get_metrics_table(pdev, &table) == 0 && table.s0i3_last_entry_status;
+}
+
 static void amd_pmc_s2idle_prepare(void)
 {
 	struct amd_pmc_dev *pdev = &pmc;
@@ -632,11 +645,9 @@ static void amd_pmc_s2idle_prepare(void)
 static void amd_pmc_s2idle_check(void)
 {
 	struct amd_pmc_dev *pdev = &pmc;
-	struct smu_metrics table;
 	int rc;
 
-	/* Avoid triggering OVP */
-	if (!get_metrics_table(pdev, &table) && table.s0i3_last_entry_status)
+	if (amd_pmc_intermediate_wakeup_need_delay(pdev))
 		msleep(2500);
 
 	/* Dump the IdleMask before we add to the STB */


