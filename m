Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A1D14A087;
	Tue, 25 Jun 2024 09:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309362; cv=none; b=uoAayTo8ojIZJzQTPNrwnWq4/bwBYXQLu2Gg+HxDPkZaBcrrQaw7cMPI7rYjcxIRe9qzq1Wu5SfRFFM9MiIf1RHEVXNq6+xOGX/R/yAwLIkVehDXKQTRZ/oPwX3Kwomohru/6Tw91dTHcI0d/q0iCfVkOznQpSCHIFRYbCQ1K20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309362; c=relaxed/simple;
	bh=d3ymsZd/WnPbo0aXl5aQxJCbi5DQdVeR2nTaCJVFFd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC6DKo0Dd+an8/0gBmwOcECK3BStieIsqeCr4X+qGByonOF7ejUJiYeBKrmicAVu5G1RW3oasQRZsok4Nd/V/thLxoJK+jbJD7ydwJy2VAWUTXBe5NtzB2AZQTNeQsaaQIJfsuWb5jzxfj+Rz7lm9B/DSWz7y9AnCPhXrepbMNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdhOt4up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdhOt4up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2990CC32781;
	Tue, 25 Jun 2024 09:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309362;
	bh=d3ymsZd/WnPbo0aXl5aQxJCbi5DQdVeR2nTaCJVFFd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdhOt4up1vkFk15F2QlPHiF47V7OH1Jk/2OU2oElvFEehUx9xM8ui48JBiAqUyCiE
	 4WB96aWsb8DjAem6zCtyOVsdfe2nYwy7lwDa1pgFy5rg9QcWjRQHjMcZDdnxvWcM6E
	 P+p4uh2v//LoDK9pFsQdOUM29IHz9JnR1gAcVgHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 153/192] drm/radeon: fix UBSAN warning in kv_dpm.c
Date: Tue, 25 Jun 2024 11:33:45 +0200
Message-ID: <20240625085543.032887477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


