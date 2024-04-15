Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2018289B;
	Mon, 15 Apr 2024 14:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191673; cv=none; b=OqaMYEcS2fzuJgKLAjxVADKhELi1MFjpfxT+tTX0UwEbZltHFQUqXql9CWdvO8xlfbjktJvkAE8qIe3HiACuPXJSXujr2Prin9JProQmM3Rqqf6RuYHrST7h4PH7nXyTWw8i/oYgBm0hdIv906TbSsopqRfXBBqfZweNYEz9hbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191673; c=relaxed/simple;
	bh=rmT3vhrAPhyrFT+YZt4IVBmHy+nQ+IsNVAPfcX1UanE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYrtKZ/xz1kMoTCHr8nlkPqmVWOzrK0TFTgz8fQSYi0GwoaotZh3D2vLRCwTMA2kBZQv7+8AJWw83KMXsWpz+Oi4raX5svDJI/1ZOevT/nygyYsEtbSn/525CH2lOCh4ysvYo3nceLxvARkExtwCANxdsW4l0G4JigBAop1SEuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yRk5Rui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yRk5Rui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6293C113CC;
	Mon, 15 Apr 2024 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191673;
	bh=rmT3vhrAPhyrFT+YZt4IVBmHy+nQ+IsNVAPfcX1UanE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yRk5RuisMAMIIm3vsXBWmaygMs+xMx1D2lwt+Jm7pjKa2pUXR5ljPgi8NSDiLDDt
	 pIFnFYXiAfi6N14rn+6v09b951EwyYyV1/kcc5PU0aJuSzQDkdUM90mT8KNHa/zInM
	 fau2Rz5B/o4gh7AosuBufrW9uTJ8Cy04bhXR4Mjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <superm1@gmail.com>
Subject: [PATCH 6.6 010/122] drm/amd/pm: fixes a random hang in S4 for SMU v13.0.4/11
Date: Mon, 15 Apr 2024 16:19:35 +0200
Message-ID: <20240415141953.685951632@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

commit 31729e8c21ecfd671458e02b6511eb68c2225113 upstream.

While doing multiple S4 stress tests, GC/RLC/PMFW get into
an invalid state resulting into hard hangs.

Adding a GFX reset as workaround just before sending the
MP1_UNLOAD message avoids this failure.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <superm1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -226,8 +226,18 @@ static int smu_v13_0_4_system_features_c
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
-	if (!en && !adev->in_s0ix)
+	if (!en && !adev->in_s0ix) {
+		/* Adds a GFX reset as workaround just before sending the
+		 * MP1_UNLOAD message to prevent GC/RLC/PMFW from entering
+		 * an invalid state.
+		 */
+		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GfxDeviceDriverReset,
+						      SMU_RESET_MODE_2, NULL);
+		if (ret)
+			return ret;
+
 		ret = smu_cmn_send_smc_msg(smu, SMU_MSG_PrepareMp1ForUnload, NULL);
+	}
 
 	return ret;
 }


