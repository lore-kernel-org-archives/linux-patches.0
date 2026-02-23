Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EF366810;
	Mon, 23 Feb 2026 12:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850278; cv=none; b=sRCELPk6U3fr5io4cGzpFB/q0/jP1DXjw/VKAXe1/x++MZFEP8/e3CO9WF8dlUlb6QqfZjNGMOxmn+y6Gm2+slX1fQ4xRDIxWSeBU0JWJ1gaWokHPo8paO1q8hmDHRNCuFcic9XLtpzb65XzEZezrRXsJ1myaKe3EJt5nzfECW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850278; c=relaxed/simple;
	bh=M7F2rSTTqr90Kn3s4L70s4qOpWDL49vgW3qJw5dHmnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GS/dzWMG6DIw/txy7Ffca0nZTky3p2KoKLUdio/23DrSqg868lroFsgzJJeu/QB4EQ5VAJXPLvxRIAFwnnzMCTkuS4XByJcW/Y+tj7oQ+Wm5audErbca5AIkkQXTkGGV7dRlz0dID+1ecyY8tRagxi51fRRFNyUSMNRbnxu+bX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMfm+V6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMfm+V6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD524C2BC9E;
	Mon, 23 Feb 2026 12:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850278;
	bh=M7F2rSTTqr90Kn3s4L70s4qOpWDL49vgW3qJw5dHmnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMfm+V6eIgrVBP6y3qGfX7YcCECFquhAtBS7xZY1ahms9qRL3DUksH0VXq9TG5+in
	 BttTE2cB/5mZQ7H4F5NQbWX+b9bDid3dN4vuCZ2/UnSMVNThYnZAgrHF1HVEMV4a+w
	 3bO9tnNZs+T2ygod/EswOhPIH3lI0KWpsWwf9/8G80OUA585n5s8pmbT6VsYdlP3Uu
	 8PLLZytVdicWS3R0GjEQIolxao8aQ676xcD+MojbqD/YVxzuENvLmhcGJAaFHS7ne7
	 cg2G6QdSn7GWVGxy3JByTkd7xELCYIvn6/ar1MgJVGgs8YN6VsITy+SnSekS0mwcQV
	 jquZCYtetHIew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: decce6 <decce6@proton.me>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] drm/radeon: Add HAINAN clock adjustment
Date: Mon, 23 Feb 2026 07:37:18 -0500
Message-ID: <20260223123738.1532940-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: decce6 <decce6@proton.me>

[ Upstream commit 908d318f23d6b5d625bea093c5fc056238cdb7ff ]

This patch limits the clock speeds of the AMD Radeon R5 M420 GPU from
850/1000MHz (core/memory) to 800/950 MHz, making it work stably. This
patch is for radeon.

Signed-off-by: decce6 <decce6@proton.me>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me check the existing code to understand the pattern of these
quirks and what the commit adds.

## Analysis

### What the commit does
This commit adds a device-specific clock speed limitation (quirk) for
the AMD Radeon R5 M420 GPU, identified by PCI device ID `0x666f` and
revision `0x00`. It caps the core clock (sclk) to 800 MHz (80000 *
10kHz) and memory clock (mclk) to 950 MHz (95000 * 10kHz), down from the
default 850/1000 MHz, to achieve stable operation.

### Classification: Hardware Quirk
This is a **hardware quirk/workaround** — it follows an existing, well-
established pattern in `si_apply_state_adjust_rules()` where specific
HAINAN and OLAND device IDs/revisions have their clock speeds capped to
prevent instability. The existing code already has multiple similar
entries for other HAINAN variants (0x6664, 0x6665, 0x6667) and OLAND
variants.

### Stable Kernel Criteria Assessment

**Meets criteria:**
- **Fixes a real bug**: Without this quirk, the R5 M420 GPU runs
  unstably at its default clock speeds. This is a stability fix for real
  hardware.
- **Small and contained**: +5 lines, purely additive, in a single file,
  within an existing pattern.
- **Obviously correct**: Follows the exact same pattern as adjacent
  quirk entries.
- **No new features**: This is a workaround for broken hardware, not a
  feature.
- **Low risk**: Only affects the specific device ID 0x666f rev 0x00 —
  cannot impact any other hardware.
- **Accepted by AMD maintainer**: Signed off by Alex Deucher (AMD GPU
  subsystem maintainer).

**Concerns:**
- The commit message says "making it work stably" but doesn't detail
  specific symptoms (crashes, GPU hangs, artifacts, etc.).
- The author (`decce6@proton.me`) appears to be a relatively new
  contributor, and there's no `Tested-by:` or `Reported-by:` tag from
  others.
- However, this exact pattern has been used for years for other HAINAN
  variants, and similar patches have been accepted and even modified
  over time (see commits `c7e5587964201` and `a628392cf03e0`).

### Risk Assessment
**Very low risk**. The change is gated by specific device ID AND
revision checks (`device == 0x666f && revision == 0x00`), so it cannot
affect any other GPU. The pattern is identical to existing, proven quirk
entries. The worst case if the quirk values are wrong is slightly lower
performance on that one specific GPU model — the current state without
the quirk is instability/crashes.

### Verification
- Verified the existing code pattern in `si_apply_state_adjust_rules()`
  at `si_dpm.c:2915-2941` — the new code follows the exact same
  structure.
- Verified commit `c7e5587964201` shows history of HAINAN clock quirk
  adjustments (removing rev 0x83 because it worked stably without
  overrides), confirming this is an established practice.
- Verified commit `a628392cf03e0` dropped an mclk quirk for HAINAN when
  firmware improved, showing these quirks are hardware-specific and
  necessary.
- Verified device 0x666f is not referenced elsewhere in the radeon
  driver (grep found no other matches), confirming no conflicts.
- Could not access full mailing list discussion on lore.kernel.org
  (search only returned index pages).
- The patch was signed off by Alex Deucher, the AMD GPU maintainer,
  confirming maintainer approval.

This is a textbook hardware quirk addition — small, targeted, following
an established pattern, fixing a real stability issue on specific
hardware. These are explicitly called out as appropriate for stable
backporting.

**YES**

 drivers/gpu/drm/radeon/si_dpm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 9deb91970d4df..f12227145ef08 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2925,6 +2925,11 @@ static void si_apply_state_adjust_rules(struct radeon_device *rdev,
 			max_sclk = 60000;
 			max_mclk = 80000;
 		}
+		if ((rdev->pdev->device == 0x666f) &&
+		    (rdev->pdev->revision == 0x00)) {
+			max_sclk = 80000;
+			max_mclk = 95000;
+		}
 	} else if (rdev->family == CHIP_OLAND) {
 		if ((rdev->pdev->revision == 0xC7) ||
 		    (rdev->pdev->revision == 0x80) ||
-- 
2.51.0

