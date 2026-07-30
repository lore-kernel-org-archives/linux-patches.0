Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F90137BE9C;
	Thu, 30 Jul 2026 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426073; cv=none; b=fg7D/1Bl+ryVbmXwgZlyjU2B8wEpy8zg1ZSi/vSLyo1Ps++ESEvD0yISXMEgJz/9iJIC0Cu4I9241LXObveCMQpXhl8a6oLGR7UiF9JdnfQmatAAWSt42k9fXzE1DukwPoD+SoTuk0Tp/XcJKEd2HpXl+WGjXnrjEL/MNbFM/7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426073; c=relaxed/simple;
	bh=BNvSh9CarpdDNxIb5Tlt8Mkrw0zGhLrSPaLydZSCH6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mM1VkY81t065lJ2AR40Gz/4V2LgBDBHhlbj8QU8St/JkqJ2GzhhPr+ca88pC+eJoT6iRylZPDthcIaQn2M6RUwkVxz/1WD0mWCVkIsTuLwojmh+QXUfFDhpX6m63GUn8ByKqHA3Kj13Gxys8rCsSQbiGWAQeR+Shvm6xMVlwfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWAIGfs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWAIGfs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB65A1F000E9;
	Thu, 30 Jul 2026 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426072;
	bh=f/697DZ1+1ud2Ho1rLBBJ0JA6wvB0Avb7RuzKzFgApw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWAIGfs7f4ErS94mn5PQNHBUTADLF9cUQJMBiSpMOCYwqqxHr1KmQWa6pWhaiCeCD
	 sGEvMYYEZCXLgqtDu8NiTSYIGkEWA5/VHTTp966bwjeoXcmemy/9Nap8UlduJ4ydzb
	 gwKC02d/MYKAk53FN97f8b83V9kZIEpyMrBffmdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 292/602] drm/amd/pm/ci: Dont disable MCLK DPM on Bonaire 0x6658 (R7 260X)
Date: Thu, 30 Jul 2026 16:11:24 +0200
Message-ID: <20260730141442.106523990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 85371c5ef502d10add72eab38711e191dccea981 upstream.

The old radeon driver has a documented workaround in ci_dpm.c
which claims that Bonaire 0x6658 with old memory controller
firmware is unstable with MCLK DPM, so as a precaution I
disabled MCLK DPM on this ASIC in amdgpu.

Note that the old MC firmware is not actually used with
amdgpu, but in theory it's possible that the VBIOS sets
up the ASIC with an old MC firmware that is already running
when amdgpu initializes (in which case amdgpu doesn't
load its own firmware).

What I expected to happen is that the GPU would simply use
its maximum memory clock, and indeed this is what seemed
to happen according to amdgpu_pm_info which reads the
current MCLK value from the SMU.
However, some users reported a huge perf regression
and upon a closer look it seems that the GPU seems to
not actually use the highest MCLK value, despite the SMU
reporting that it does.

Let's not disable MCLK DPM on Bonaire 0x6658 (R7 260X).

Keep MCLK DPM disabled on R9 M380 in the 2015 iMac
because that still hangs if we enable it.

Fixes: 9851f29cb06c ("drm/amd/pm/ci: Disable MCLK DPM on problematic CI ASICs")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d34acad064ee7d82bd18f5d87592c422d4d323ac)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
@@ -106,11 +106,8 @@ int hwmgr_early_init(struct pp_hwmgr *hw
 		hwmgr->od_enabled = false;
 		switch (hwmgr->chip_id) {
 		case CHIP_BONAIRE:
-			/* R9 M380 in iMac 2015: SMU hangs when enabling MCLK DPM
-			 * R7 260X cards with old MC ucode: MCLK DPM is unstable
-			 */
-			if (adev->pdev->subsystem_vendor == 0x106B ||
-			    adev->pdev->device == 0x6658) {
+			/* R9 M380 in iMac 2015: SMU hangs when enabling MCLK DPM */
+			if (adev->pdev->subsystem_vendor == 0x106B) {
 				dev_info(adev->dev, "disabling MCLK DPM on quirky ASIC");
 				adev->pm.pp_feature &= ~PP_MCLK_DPM_MASK;
 				hwmgr->feature_mask &= ~PP_MCLK_DPM_MASK;


