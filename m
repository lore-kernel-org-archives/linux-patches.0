Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E6E12EBEA;
	Tue, 25 Jun 2024 09:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308683; cv=none; b=gjpfNlyBAjOIktxl1hHS6+WFHpakopVuhmKva0ISFTSWD33l/MGR/i3tPsEZYNnQf/NhBvDWdSaOTWWvOYVYwLY/+JzVbwuQbXDioPwxyLotpo4u1tWX4rZ4E/OaYhPdJXJ5Pc+1eRdhIHPYStTCIybwuXmjI/8HJDbaJOUR0Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308683; c=relaxed/simple;
	bh=GRoDgkIauAnXkdEQk13Tegb6UGx7zM0jASV6Kj0BCkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peL0s1BLaVGAA9hlgAk0jrG2zdKadLYX7JTwQeK0fuSENPO+RqAUbOCyM7s47d7BF0S/0ABvaD9+nmsmhbxd0h0gqisCG6CZw2d9jKTVp3htT91hI5C2ix5s9KVSF+qwe7uon/dHNamqnl19tj6psNHB2MqnSVLH4qw448DyP5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2TNySwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2TNySwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C52C32781;
	Tue, 25 Jun 2024 09:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308683;
	bh=GRoDgkIauAnXkdEQk13Tegb6UGx7zM0jASV6Kj0BCkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2TNySwcmQcJf1HgwS+MheLAuFuQGw5xTcvHq/V6q6c9EgbyqIl4pi1Pe1f4ql0ae
	 VFa2tSxG5fCMQzEi3Iztjy8m2lEzREYlgmrezpzS2IwwZt8Vi1y4eJ1ZIvsbV0ABWd
	 Xvb3AyyjZ/qAoGCwz2/VDqOBCsTLFbsJS9szaEyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 205/250] drm/amdgpu: fix UBSAN warning in kv_dpm.c
Date: Tue, 25 Jun 2024 11:32:43 +0200
Message-ID: <20240625085555.923090169@linuxfoundation.org>
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


