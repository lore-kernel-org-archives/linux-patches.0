Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945DC14A0B9;
	Tue, 25 Jun 2024 09:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309365; cv=none; b=lO2MEfkuPAWS07Jz8nF1funFT8KXi9r7QEeQzq07OuqJJy40lvsp99C0eHX/ZJZqu04i2Lk+BjS1kkD3/1T9Ff0bLQ+Cq2dgaTih8K1CPDfsgH1oSqCTVVHqT9zo9273H/MFk9oeArUmvr88lENzsOVms8yxeUbvHGdtEm4xpeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309365; c=relaxed/simple;
	bh=5bp2P5dAoYZPsBhXLZKIiOTSKNjP6IsCSBWiHZO6HUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVEAn53x1gggWePjBjebUnAHkMssGTBlxCTS80TrQYip2H1AvLLEV600YDt7Vg/s9/uslLd+sHt70YWjo4hC6SFuvMU1FY74kmVzFlOA5WqQTpRIrjaRqTGMO3QV9bYAU07EPAUfPmNjsv3MRVFNfxcHE35hn2zRulivd3JdPZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5AJwsvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5AJwsvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADFDC32781;
	Tue, 25 Jun 2024 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309365;
	bh=5bp2P5dAoYZPsBhXLZKIiOTSKNjP6IsCSBWiHZO6HUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5AJwsvx5mok3+IPJlK56ExOitdTzLz145QwnjrVfRF5odIa4KxAc6waXmLn8YvLk
	 Vq0pskJiLNh6ImkKBZVj5Mr+LmMxxPD75jdx2cGFqQ2vintvoFJWrjQ8FncJUl6VAL
	 rr+k4ouiql/1a9Wj6NViqJqxSPYanKLcFwq+eXpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 154/192] drm/amdgpu: fix UBSAN warning in kv_dpm.c
Date: Tue, 25 Jun 2024 11:33:46 +0200
Message-ID: <20240625085543.071286738@linuxfoundation.org>
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


