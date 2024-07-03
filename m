Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955D19B3DA;
	Wed,  3 Jul 2024 10:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004086; cv=none; b=TRGaNqeU/5uCMnMoTclxJQ41gsg3iPgPD14VG4Xju8GWLM9SYw6ApZMdbXjfDO0YQo4QGIszdQ0MMu/lIWynGq/etPxN760qRZdL409CZwSp1TdkjzOpyr0HQ+htJb52ddKUSnvMjFQJ4jgfyOX0mnFfybz7sgzmde5f7Sa9upw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004086; c=relaxed/simple;
	bh=mxZzCTONHVGpgF1pVhqHbKIiFLaIvGBFH6HUfuumbRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLJpOa6Yq3VG24MWaSTlDWTXlS0SQejnstbAbx4VW8KOLX+Ekzln1CEVlyNBvbI5k2YW5uEEgxegnR0gMHNpPlxQ7zH1TGVGxj+1Y3jx4lIdXuhpt0cLbQry62vAlxl/jdN7cruClFQDZH2+p/lAiE93U7Ags/94ZGXlHjaLD40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uBvAW2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uBvAW2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EFDC2BD10;
	Wed,  3 Jul 2024 10:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004086;
	bh=mxZzCTONHVGpgF1pVhqHbKIiFLaIvGBFH6HUfuumbRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uBvAW2tFtX80C261eRBzwz1/Jpuf4fS39WtYJjPan2vCp7rwkKfWRcficLrO/87Z
	 kpGNz4NumbszunD06W/zIPMXczRnizdCkwomgmrj+WoRtwAfBUgFSkrFXh1Vo0r6j8
	 7raPxY5WhkWxrBEuOMR71/DPM54kBbxa/+vMpD8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 117/189] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:39:38 +0200
Message-ID: <20240703102845.913606540@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1621,6 +1621,8 @@ void sumo_construct_vid_mapping_table(st
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =


