Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510A62EAD1B;
	Thu,  3 Jul 2025 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554507; cv=none; b=s4M0G6/S65U7O4H6f1429JZ6SBBkzfu8ln5p0f9/HZSIXefmzuceGTcmIyoSCu9j4eJxkqRpO1yDHag/8BSzYtvasgADzyu0K2p0IMzj4yJULcQclmTkG6fslNFq1rkFwQtQLguv9To/BTOub/ISijGByRKTLR6goWAYi3HFMYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554507; c=relaxed/simple;
	bh=XiE8k8lAtwbyMT1yzasldmDtm8bRjqUBDmH6+RFLiHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwYOH4yZJO2SNREbX9bew9CbPjnBOOVIqgbV34cPM7phat3QDlx8fNSkE4oDDKT8YK4mLmyMb7FBYAKurVU2pevjG6Pa6djmwZEC9OoZxd/SxbncBWsJCMRBwndQ1Hga0+rUZlqEh1PP9iJ6cZ6LpgSrzlK1DIR6UbXu32ze6cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzkhA37Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzkhA37Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B8FC4CEE3;
	Thu,  3 Jul 2025 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554507;
	bh=XiE8k8lAtwbyMT1yzasldmDtm8bRjqUBDmH6+RFLiHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzkhA37ZAsQYxGuFPAVMmadAOHJ8Qj2lAwOTRgt79OTajfXo8KqkrizJgkN+ocPDo
	 KGtzQTUWTtg1lr0JF5Dxbe0rhSklEa4MzYaS6G/iR81wayOt5U2JP0vadFT6vYEONP
	 a5YN17haP+XUy+kOBF0pztpli/vcwROP8GZRzXUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	David Belanger <david.belanger@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/218] drm/amdkfd: remove gfx 12 trap handler page size cap
Date: Thu,  3 Jul 2025 16:42:37 +0200
Message-ID: <20250703144004.573344938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit cd82f29ec51b2e616289db7b258a936127c16efa ]

GFX 12 does not require a page size cap for the trap handler because
it does not require a CWSR work around like GFX 11 did.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: David Belanger <david.belanger@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 9186ef0bd2a32..07eadab4c1c4d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -537,7 +537,8 @@ static void kfd_cwsr_init(struct kfd_dev *kfd)
 			kfd->cwsr_isa = cwsr_trap_gfx11_hex;
 			kfd->cwsr_isa_size = sizeof(cwsr_trap_gfx11_hex);
 		} else {
-			BUILD_BUG_ON(sizeof(cwsr_trap_gfx12_hex) > PAGE_SIZE);
+			BUILD_BUG_ON(sizeof(cwsr_trap_gfx12_hex)
+					     > KFD_CWSR_TMA_OFFSET);
 			kfd->cwsr_isa = cwsr_trap_gfx12_hex;
 			kfd->cwsr_isa_size = sizeof(cwsr_trap_gfx12_hex);
 		}
-- 
2.39.5



