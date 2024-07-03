Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D04717A5A5;
	Wed,  3 Jul 2024 11:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005868; cv=none; b=qoXaaV89wIqnWVbOZMuQ67tXLWx4ygjZwmYMLYAPzgoeoX0I+ZV+HtUoFYoGcQ2FUwaZzT+uVjyY9fAwPGq2+b6FGUe3FJHYgKgqJYaH0YhSrMgR4foLJwmz9qFyo4hTQKNfdvhV5Uk+pNaYycCh4IcCaE6pek0U5uVAJsKJE78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005868; c=relaxed/simple;
	bh=E5e3Li6Y4k/CY9X5zPRlwQtT1LB3mW2nkBMpF9sHdC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/If8sSY2kCvTdfF0CS3fB7GzOCqK/I6gXa1a+cmqQcRh5ssdCDhk9CY7DbjuK11bv5T3/rjeIF+C+z+pGb4ueS6m8NjdWLow08u4BqMRK/AzKbXfSpqSYwQPFJMBpyaS2zhcWWHDQ+DDBnwDtrDfAepN9COLzL055Zp3t5XlD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tw6IRgpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tw6IRgpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0361AC2BD10;
	Wed,  3 Jul 2024 11:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005868;
	bh=E5e3Li6Y4k/CY9X5zPRlwQtT1LB3mW2nkBMpF9sHdC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tw6IRgpcXg66A5AUTo38HQP49xQHLYJozvNSG0Jof8vwpKR0x1OXbxl9tTMHh5X6n
	 2zGMsWOk5q8vHAJo1ZGOC3g8m81Gl6U5m+sboBpCzokhIY3LaOGY2QsqA5gV2eOA8O
	 J4E3SQkt2a28+NbyO9UFdfkOc7DUrCJDIM52ZO8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 224/356] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:39:20 +0200
Message-ID: <20240703102921.589772860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


