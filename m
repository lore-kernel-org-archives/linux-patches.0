Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4847F53;
	Fri,  6 Dec 2024 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496400; cv=none; b=ux+NshLxXXBIIDBw0LFtVRIni3P86vSZ4D7h5YB/GEQy7aq7AajMAIs+2Kb9HLg1xzEyQhICb9mdjClWIkwX3ZJ19bHb7OucF7m4+KMJ0mO2hp1idzxzryRorxsou7wSQgeBSM/v45KFM9Va0lupydp1TV/GXIWW9uCYQwRt8wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496400; c=relaxed/simple;
	bh=jUn+HNFsLfoArHQZ6FCHWgJQWG+QBiB8mUOT6SJNTK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS7Ki98Tqu/98XUMCO/vZwexzpp/NmIMnOjOcvbs6iTcyPlXv8WLEj9Zk6QwPm7RHeRdzuqbTLUs9efIPYBLfth4FFVaJCP+SQ6OH1PNmmKGtl4J0kAIandKtqGHt0VT2Dijz4GhfiYwJAs/d+heQZsxCjNmS0eRSMC1hvkBSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HVfqG7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HVfqG7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2152DC4CED1;
	Fri,  6 Dec 2024 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496400;
	bh=jUn+HNFsLfoArHQZ6FCHWgJQWG+QBiB8mUOT6SJNTK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HVfqG7Vvzm+5SAd9R5x5jKBC3reQbpBw7saKwmN/uOm20NYNcsCkWaHb7WsnphUp
	 ZOjwV9njUhpcJhGKh3lVOJ80LZWCFOYXyNK56ffylAxZzFypS0HG6KW2GU36S70Pmb
	 V5/BzkuKgp/V6iZKE2fLvxDkJ3gp5w5X7qzaBS+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 141/146] drm/amd/pm: disable pcie speed switching on Intel platform for smu v14.0.2/3
Date: Fri,  6 Dec 2024 15:37:52 +0100
Message-ID: <20241206143533.081490862@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit b0df0e777874549c128b43f7bf4989a2ed24b37a upstream.

disable pcie speed switching on Intel platform for smu v14.0.2/3
based on Intel's requirement.
v2: align the setting with smu v13.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1477,15 +1477,35 @@ static int smu_v14_0_2_update_pcie_param
 	struct smu_14_0_dpm_context *dpm_context = smu->smu_dpm.dpm_context;
 	struct smu_14_0_pcie_table *pcie_table =
 				&dpm_context->dpm_tables.pcie_table;
+	int num_of_levels = pcie_table->num_of_link_levels;
 	uint32_t smu_pcie_arg;
 	int ret, i;
 
-	for (i = 0; i < pcie_table->num_of_link_levels; i++) {
-		if (pcie_table->pcie_gen[i] > pcie_gen_cap)
+	if (!num_of_levels)
+		return 0;
+
+	if (!(smu->adev->pm.pp_feature & PP_PCIE_DPM_MASK)) {
+		if (pcie_table->pcie_gen[num_of_levels - 1] < pcie_gen_cap)
+			pcie_gen_cap = pcie_table->pcie_gen[num_of_levels - 1];
+
+		if (pcie_table->pcie_lane[num_of_levels - 1] < pcie_width_cap)
+			pcie_width_cap = pcie_table->pcie_lane[num_of_levels - 1];
+
+		/* Force all levels to use the same settings */
+		for (i = 0; i < num_of_levels; i++) {
 			pcie_table->pcie_gen[i] = pcie_gen_cap;
-		if (pcie_table->pcie_lane[i] > pcie_width_cap)
 			pcie_table->pcie_lane[i] = pcie_width_cap;
+		}
+	} else {
+		for (i = 0; i < num_of_levels; i++) {
+			if (pcie_table->pcie_gen[i] > pcie_gen_cap)
+				pcie_table->pcie_gen[i] = pcie_gen_cap;
+			if (pcie_table->pcie_lane[i] > pcie_width_cap)
+				pcie_table->pcie_lane[i] = pcie_width_cap;
+		}
+	}
 
+	for (i = 0; i < num_of_levels; i++) {
 		smu_pcie_arg = i << 16;
 		smu_pcie_arg |= pcie_table->pcie_gen[i] << 8;
 		smu_pcie_arg |= pcie_table->pcie_lane[i];


