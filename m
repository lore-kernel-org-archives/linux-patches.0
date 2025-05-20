Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D7F24DFE4;
	Tue, 20 May 2025 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750755; cv=none; b=FcPNqk9TJjpbeOuIQjSEb0FGt6aY4VO9cYBjCMEiPefM245Q72vhY0yDdbqG1jVwnKz75si/XJ/fHG9S7Pz/SwDP1ZwdUHcDgESofZ4jAo6mP+zc/b+T/Moa0W6zna+fvKSQKdNNy7VsRam60gcR+6eGKb4aU0vZ5gIGwVzvDUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750755; c=relaxed/simple;
	bh=J8GbOJ2WiWC2NuValYvTAp1eMAwYNPcpUGhXzjngXkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1xAnU/Vu7WCSBl0g0R2ZYCfpAcQfWIyYTPFq/aw38rWmO2h51/M63peiTEN3/yMtDdKSlqvRd4fbXSLyMh/ZDELTzzo+t7ywmjTH3yhaQcnNAVDwrFpkWS5PRFNrhqbNs/MvAnY+xOVlFn80a4234X2JxQjeE456JntKkMcqv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKoiFUvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKoiFUvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BB0C4CEE9;
	Tue, 20 May 2025 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750755;
	bh=J8GbOJ2WiWC2NuValYvTAp1eMAwYNPcpUGhXzjngXkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKoiFUvH/I0SAE8tLd9+oppahSkDtz0t3s09reclcvmn6unCwco8OfDpdzVmNJula
	 pOeyopt22Ppnn8zIW5Oc3oqjc2cn1JcxBgahNL7wZrH+dscL6Gs7fHsbYIKH9D4sVE
	 3dw6rwv1geX+q13350n5QqQQiJIyrPYohREIWXHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>
Subject: [PATCH 6.14 080/145] drm/amdgpu: read back register after written for VCN v4.0.5
Date: Tue, 20 May 2025 15:50:50 +0200
Message-ID: <20250520125813.714702573@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

commit ee7360fc27d6045510f8fe459b5649b2af27811a upstream.

On VCN v4.0.5 there is a race condition where the WPTR is not
updated after starting from idle when doorbell is used. Adding
register read-back after written at function end is to ensure
all register writes are done before they can be used.

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12528
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 07c9db090b86e5211188e1b351303fbc673378cf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -983,6 +983,10 @@ static int vcn_v4_0_5_start_dpg_mode(str
 			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
 			VCN_RB1_DB_CTRL__EN_MASK);
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, inst_idx, regVCN_RB1_DB_CTRL);
+
 	return 0;
 }
 
@@ -1169,6 +1173,10 @@ static int vcn_v4_0_5_start(struct amdgp
 		fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
 	}
 
+	/* Keeping one read-back to ensure all register writes are done, otherwise
+	 * it may introduce race conditions */
+	RREG32_SOC15(VCN, i, regVCN_RB_ENABLE);
+
 	return 0;
 }
 


