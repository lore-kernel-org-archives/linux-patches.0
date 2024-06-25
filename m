Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC9413C90B;
	Tue, 25 Jun 2024 10:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309789; cv=none; b=Y4dVia/XzFIUzMeAuBi+utmZmYlv4klSZ63DtjSIJlgB/HTrYQVY61yLOYQ0QQ6i91//7ae1//9TJ7LOlCmtRXuiLv5fG9Jg3p91KvjS9RUvs1p0sHjOR4N63taw31GcxKUFS0H21NrMm9sjrU075fIq4kfd3U5QMGrpx5hVcpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309789; c=relaxed/simple;
	bh=N/fwG9o8eVfxdTk0r1uwGs7AKj4w/YUxD1XI05a0zJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQdvvJIF42BShvXhURFxbNCmTkGgtZxSXsG2bVdY2h0yZYbietUkYJmYQlE9P5wXWHFryecq0A+hOX/Kzi8/cF0MlcFXjPfoOYwN4VCWprFb5MNVuT8Ic/gc2JD+jvr9BYsOYbcvsrRr6gT793enJvqiO5ew39vcvmx7K+NGBIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbNacKkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbNacKkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7E8C32781;
	Tue, 25 Jun 2024 10:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309789;
	bh=N/fwG9o8eVfxdTk0r1uwGs7AKj4w/YUxD1XI05a0zJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbNacKkf2dG0jCgcwED6OJxDV+1b9sDS2jJ+QgC8+RXq0cFMi6TqXXggrTjwZIscq
	 z0X789xai/84/+0aBcm+ShQO5/H2Aws/CdD2bznEAU1XmaZHBpOe/bi+dybNAVODPs
	 Yx/RjHU+5TrZg0h9XCvz3V6WJTE9RFZ8TTWpe/BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 105/131] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Tue, 25 Jun 2024 11:34:20 +0200
Message-ID: <20240625085529.929498570@linuxfoundation.org>
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


