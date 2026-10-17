Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497A6391E51;
	Sat, 17 Oct 2026 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257024; cv=none; b=TzQhxmnGrgWLn1yhDkAVzC8rc6AXwEZlMs2cyQCJ+bVxLxhjSM7kg7/gH2+yafPVeIG3O9v3BHvYdpjgrzHYF2cEyVjzzHhLhtSOv+lmgR2rNcqH9Qzf6hsYMFolsTlo86a8fVnJxJde+LL6y4BdPfS4FpmmO5+hkHn56VxTtLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257024; c=relaxed/simple;
	bh=lVAFFTjDU6J7SHWa/eQybdd78xyddXitqOZ1awfL7F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qx8fx3rEu3c6AY4bGfODN82TEBPpvB62QPiAXbawCSs3/1OQfnLaTldP9ahYwvhYmVtckLCjKQeZIlBRhGh9grqNIGPbLJbA6SeXiEWf4VET2UIrpw5NvmvqcuVZHXqhZZLOio0Iz1UoLHXGZuH0re+MIlPEkbDmUcaPR50aZT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vERj2Olw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vERj2Olw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D971F000C4;
	Sat, 17 Oct 2026 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257023;
	bh=TpVqtKU/cTVw8X1Sw4Ke290R8a43jfeROJfI/C2Fsp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vERj2OlwE07aXCI/6XF0K96LmdaCrd7JXjJMImWd1F7tPuzppqw/+4+P9YhrBtHOd
	 nSg7PJg0x3ITzIa8pDxBO4TgWHpp39mWfp2wE2ntfVPiTbrIrOt/XT/oEuqGHxjD6z
	 h2M9sXxufgQCUy0XOclvLkI60EvGqJERsBvSQjOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Francisco=20Beltr=C3=A1n=20Millal=C3=A9n?= <fbeltranmillalen@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0390/1674] drm/amdgpu: reset VI ASIC on MacBookPro14,3
Date: Sat, 17 Oct 2026 17:44:22 +0200
Message-ID: <20261017160441.118981265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>

[ Upstream commit a22e5e4f2ebbdbb962cc3233094d189c4dfaa051 ]

On a MacBookPro14,3 with a Radeon Pro 555 (Polaris11), the framebuffer
is at MC address 0 when amdgpu loads after a cold boot, as the firmware
leaves it (MC_VM_FB_LOCATION = 0x007f0000), while the VBIOS ASIC_Init
table places it at 0xF4_0000_0000 (0xf47ff400).  amdgpu reads the
location once, at init, so after a re-POST (S3 resume or GPU reset)
the framebuffer has moved and the driver keeps programming the old
one: the SMU is handed a table that was never written and the GPU
does not come back, which leaves the internal panel black.

Resetting the ASIC on load makes ASIC_Init run before the driver reads
the location, so the driver uses the VBIOS placement from the start and
every later re-POST puts the framebuffer back where it already is.

Add the Radeon Pro 555 used in this machine to the existing VI reset
quirk table.

Tested on a MacBookPro14,3 on 6.18.49 with the quirk table backported
(the kernel also carries unrelated local PCI and ACPI patches for this
machine).  The framebuffer is at 0x000000F400000000 after both cold and
warm boot, and the GPU survived 9 S3 cycles (lid close and rtcwake, one
of them with the lid closed for about 7.5 minutes and a USB-C disk
attached), each followed by a few minutes of 3D load; no ring timeouts
or VM faults were reported.  The reset adds about 0.23 s to amdgpu init.

Suggested-by: Christian König <christian.koenig@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/all/20260924132952.25054-1-fbeltranmillalen@gmail.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b6b1d97218518003107d4446fac278fa3e0a19a0)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vi.c b/drivers/gpu/drm/amd/amdgpu/vi.c
index 162077d3bf765..86be88171bbaf 100644
--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1419,6 +1419,7 @@ struct vi_reset_quirk {
 static const struct vi_reset_quirk vi_reset_quirks[] = {
 	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x0190, 0xe3 }, /* Radeon Pro 555X */
 	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x018f, 0xc2 }, /* Radeon Pro 560X */
+	{ 0x67ef, PCI_VENDOR_ID_APPLE, 0x017a, 0xc7 }, /* Radeon Pro 555 */
 };
 
 static bool vi_need_reset_on_init(struct amdgpu_device *adev)
-- 
2.53.0



