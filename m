Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46496136E2A;
	Wed,  3 Jul 2024 10:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003535; cv=none; b=fbYaO9V9XQd0UXYfns9hBtItnKXiQLhUFTIAbR1R553CHTyZizI8gFOFdtsqYv+g1z0Gy4Jyc7xFWlw1uu17rqH00SsuCGCohN9M5Dgxp8YJcLgvFY4fbp92vW6XsWokmLyDAqRmaS0JBbEXRJ1bw8lfv4EIRvlHopbRMprMB1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003535; c=relaxed/simple;
	bh=/Zpc29smSb9LjcLTuKi6pLVqS9wmKvnjrRhfmc+dh5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOQghAF5tLju4HeLtHlm5pvvXBlDZszepeFv3M1tScWv+pLuoXfiDACLuWFZ7F+L4cc35kpsB3Q3HkDE2fnBC52g05tWCQHuCQJBM8V+0hKt35DzgJ3fgVcJHp4D01H/8OK5KXxbgzTNIFNEpGE51AC7ItjNPyWTge/kvfOrAGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnMdWUjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnMdWUjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C269EC2BD10;
	Wed,  3 Jul 2024 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003535;
	bh=/Zpc29smSb9LjcLTuKi6pLVqS9wmKvnjrRhfmc+dh5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnMdWUjDTV4VUxxoHCwspMRU2KOIYmbkBk4pd2Iaahv8+NVWB3z2aQoPuCYdjsM9g
	 1yLwTdSbBg+Sa4JmMt76Re/uV04JgyVNTl5egHo6NFwhL3FK0OEwUlyZXo22wuVRIl
	 hVd4vBXgOIMbJu858lX/C5vJkQozbitpVB3S3y04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 080/139] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:39:37 +0200
Message-ID: <20240703102833.462116119@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1622,6 +1622,8 @@ void sumo_construct_vid_mapping_table(st
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =


