Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CC813C90B;
	Tue, 25 Jun 2024 10:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309792; cv=none; b=gC/+WwM2LwJDP11654/cvBX2EEw52EssCQo+rw0By/Nen/HL6YbX7Aqb8XK6VC3IinMCPtjU/miUJQJV4dZfI1Eg7f/X6P2qSdDEUHAXoNJEyarLWOo6J9HAV5gON0NhXDGO5X3ytGj0k5YNiYLQsbpFJBy3UYAMYywk6pV/HwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309792; c=relaxed/simple;
	bh=3/pcGD9hr9Al3s5l1eCcOlARfF5AqrlSZT7Xemfjtwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFqxxJsEB5Jc2ltn31RYSAXn2N1cg7WM4QH/dQSBot/7LooxJVlvbOfSnvXyTkpVGQndhj1anNsVOd+ENffY3W5rW9ZQfZSx7ZFJt8qu1X7d3fvejykT856fH4V5qj16V9gDuFfVUS3iobOXO9jwNFszxNSfF1+MWPONWMb5QBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfqCopaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfqCopaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B0DC32781;
	Tue, 25 Jun 2024 10:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309791;
	bh=3/pcGD9hr9Al3s5l1eCcOlARfF5AqrlSZT7Xemfjtwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfqCopawBcsRyDd546mHVcMg65TJriX3FCjZIYErdCdBIiAFZjlYlDsMf5ZvqPMT3
	 6FNju4K0B7pEcg9fZEj20virnk28THmNBQpBIv1j3f9xUVP+A/uh3bhc7MCLdCP7sG
	 BrODPP4y7A6z21XELfCknd5C3SI9XzBTmXZTq9xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 106/131] drm/amdgpu: fix UBSAN warning in kv_dpm.c
Date: Tue, 25 Jun 2024 11:34:21 +0200
Message-ID: <20240625085529.966209665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f0d576f840153392d04b2d52cf3adab8f62e8cb6 upstream.

Adds bounds check for sumo_vid_mapping_entry.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3392
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
@@ -164,6 +164,8 @@ static void sumo_construct_vid_mapping_t
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =


