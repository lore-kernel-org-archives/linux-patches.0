Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0811465A8;
	Tue, 25 Jun 2024 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308774; cv=none; b=YwE5Wydj485y5OYsJ/xo2bWmSAOeDY8HDAvA/74/O11cD78FEKL9rDhMxzfNCFXz5Ddnp615n4zgahOnOjDYfhpZXmYyDSXXdIqrKuD+XaS//cYaBIni1s91H3gvGzmbQktcBJV6RLK/hSp+uMNGQ1uMBOBlmft68bBuN9nsCb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308774; c=relaxed/simple;
	bh=23EoCVj6K+7nup2r27lSVYHIxfeiB4bmYGAJossaEjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbELVmBRCAGX+EEau90Ch9uz1z58aqZokwnN7uiPrQkmqnK9x1v+7SPy7mfm7FCZmXT2Cc6vo0AK/xpSFR2gdUmH+XFlbqHkrq11ovcN3uPIO5lqT4ipVcvJ/WCQMyHvPwAK+nPJAZdFSxwV8QjNbHTaCoQm7e3vmXvl5ywSSrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BRPuSli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BRPuSli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618B4C32781;
	Tue, 25 Jun 2024 09:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308774;
	bh=23EoCVj6K+7nup2r27lSVYHIxfeiB4bmYGAJossaEjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BRPuSliBxGuOu3xScGqiHqbpolmURl3y2jRhRE9Te8c3KWlL2PDKlXx3oUDxccsa
	 VIGEcb5H1zvWv/31gwWV2O9tyO/LaDaXD3kwyF0i+2rdVjWHHI8njQVUn+1FgVdQxs
	 fRcE35tRmWzGha2hZ2Mkk9RE5zqhnwr6UTAKVpr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 204/250] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Tue, 25 Jun 2024 11:32:42 +0200
Message-ID: <20240625085555.884477036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a498df5421fd737d11bfd152428ba6b1c8538321 upstream.

Adds bounds check for sumo_vid_mapping_entry.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/sumo_dpm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/sumo_dpm.c
+++ b/drivers/gpu/drm/radeon/sumo_dpm.c
@@ -1619,6 +1619,8 @@ void sumo_construct_vid_mapping_table(st
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =


