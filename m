Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DE524679D;
	Tue, 20 May 2025 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750848; cv=none; b=aUBaMytdpZ6kTbwjjL9x/IrTg08dIVfRP+Q3maQR0xShB9IavtSEMNWBnnLJJW5RaZFiLKz9uW28g3Fnc6GAyAFURnLWTG9DyZ9BHB1VGzf6m3WgdbE1PcXPM6Y8KUgfWq2dtZdBHHay2y8smcch/+pSpa4UZrd4Ccq5M+xCdG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750848; c=relaxed/simple;
	bh=eaZe2KldRdTN1oLfyJMCNduxwOekboiVUxRogwfdBv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivDIZkJmTUS6qgJnPt+/BG9JmR5wYkpv9tSTSRL7FKay2gFBYGrxkcTul/uKxfyipDA7QLAfJT2b1/LMLtWD30Cv9DCExevjAmEsq9apiXkquLNB5hbxDkb13qzzGZK4BrLYTT77Yi88cxDUPLFlfOriE48UdkZAxiUqbI1qUB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYUEpizG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYUEpizG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A175EC4CEEA;
	Tue, 20 May 2025 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750847;
	bh=eaZe2KldRdTN1oLfyJMCNduxwOekboiVUxRogwfdBv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYUEpizGro+VQPUOsge9sFYOvN8eDZph1/whgLQdq8Y2lOFeWYfCjRlGFTdGkPNsd
	 D4dOvkbr9ApWk147sN0wQblETFUqCTkQn2KLTgf9T64ha98Ifg0cYtP/0jmQ4rrhdh
	 Cfd7xSTcwp3hznL49YYFkSvCMUhY0cFay2CtH80s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.14 139/145] accel/ivpu: Fix missing MMU events from reserved SSID
Date: Tue, 20 May 2025 15:51:49 +0200
Message-ID: <20250520125815.986219701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

commit 353b8f48390d36b39276ff6af61464ec64cd4d5c upstream.

Generate recovery when fault from reserved context is detected.
Add Abort (A) bit to reserved (1) SSID to ensure NPU also receives a fault.

There is no way to create a file_priv with reserved SSID
but it is still possible to receive MMU faults from that SSID
as it is a default NPU HW setting. Such situation will occur if
FW freed context related resources but still performed access to DRAM.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250107173238.381120-9-maciej.falkowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/accel/ivpu/ivpu_mmu.c
+++ b/drivers/accel/ivpu/ivpu_mmu.c
@@ -725,8 +725,8 @@ static int ivpu_mmu_cdtab_entry_set(stru
 	cd[2] = 0;
 	cd[3] = 0x0000000000007444;
 
-	/* For global context generate memory fault on VPU */
-	if (ssid == IVPU_GLOBAL_CONTEXT_MMU_SSID)
+	/* For global and reserved contexts generate memory fault on VPU */
+	if (ssid == IVPU_GLOBAL_CONTEXT_MMU_SSID || ssid == IVPU_RESERVED_CONTEXT_MMU_SSID)
 		cd[0] |= IVPU_MMU_CD_0_A;
 
 	if (valid)
@@ -945,7 +945,8 @@ void ivpu_mmu_irq_evtq_handler(struct iv
 
 	while ((event = ivpu_mmu_get_event(vdev))) {
 		ssid = FIELD_GET(IVPU_MMU_EVT_SSID_MASK, *event);
-		if (ssid == IVPU_GLOBAL_CONTEXT_MMU_SSID) {
+		if (ssid == IVPU_GLOBAL_CONTEXT_MMU_SSID ||
+		    ssid == IVPU_RESERVED_CONTEXT_MMU_SSID) {
 			ivpu_mmu_dump_event(vdev, event);
 			ivpu_pm_trigger_recovery(vdev, "MMU event");
 			return;


