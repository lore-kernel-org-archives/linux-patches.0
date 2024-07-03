Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111816F8FA;
	Wed,  3 Jul 2024 11:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004804; cv=none; b=Z9V/lqkzbHkE41cl+zYi7le9P5O44JlB9Hsataw0+Gl7nnPBMX2tOVgdE8pDL4dhO1Eq9aiYWNicwK9poektKIRVVRyY5KcjlqwIVmGKxLzenKXiyb7ovm8leJ8LDoDI7NjS+rLeQBdZ9/sSUsiCViXYJxowB7J696WN7F2VUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004804; c=relaxed/simple;
	bh=yxsrmF/8G+DAYK+9M6zLxQ2TN/xV+lnac3PMlkgj9Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ycw7aZ0aZN+YM2xQQj9zuRkH/9wUQDHB/06E1KjiGUSCzkmnmV3QwleZMQPn33J5L+QjO9ZsO6XLelsVp9TrJlvgrGwLqFvQ+y55vlg8PIkWthEWYYqPw+UykPXE0azPGZ/yvBu6KoqlBoLsmSMmwrmIXxWAtIoX3H9Oo7rYAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Shtzm/D1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Shtzm/D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D5BC2BD10;
	Wed,  3 Jul 2024 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004804;
	bh=yxsrmF/8G+DAYK+9M6zLxQ2TN/xV+lnac3PMlkgj9Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Shtzm/D1wjKMit3IIdHMY6gT8NNvpY9zdH+Yjg4HOQ8b6tEE5YZUXuKgH1jzaiXzX
	 F76iFqrzJ2NYanr6Hbcd5f/+Cj1Roy7p2uTOPiDTfnUVOOoZeENTwAdrlxO8tuJPZI
	 HCcC0qV3rzyZYRFD+i0r13W3vAuKIyrdlFeWLAD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 165/290] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:39:06 +0200
Message-ID: <20240703102910.409333639@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


