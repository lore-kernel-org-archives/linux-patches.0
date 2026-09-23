Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7E53C3D5;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174662; cv=none; b=MAL395ID6v7Tjge+yhBa8Q9eJ18stnvmTg1HT6Pz/Yxqynf0mRq80ZqWSKbgkGhj97aaXJtA6kiXyaSPxr8DyajqQoeRrltCYbe/vLH8JMi/Hz3JUrxvJrK/WsYV1QwkeGfwZXvqrjtf9LExGTm1i2JdlnC7I5ul6jpga0aZ1IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174662; c=relaxed/simple;
	bh=+1MUSx9yMH/dnILwV/MC4uurMBHA3FrQLGcsBaHzkrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCvBjRrs2KUIyeQk/7Ulw3vyhMuFJbaQxXOkR/FmIqs9JnYaEc1epqiRUvDibg8Em7WZYT0bR3zBBSuFN/YzdI50YcQ0k922F4ZXfGSXinQhUwzVbFA/5qImpw6Qz4NnJbVDt4cQY71TIEtABoeLWkpBbUS7CZJdS3tjVRDB3Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfK6XYyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfK6XYyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378F01F000FF;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174659;
	bh=K8I1tslP5NFiJFR2BgAxR0suN6cT67i/fcp64yGnLNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yfK6XYyMjxdlvjECr3Ewj9FFH4UrJvowPNpvhFgXzC7deuQADk9p9rCMG/KbY+Bnv
	 g8d/misHAksWi1xCh0pJOcNFljQrAGvgGAg6QRo+2h7hPJ1tsqYlv4ppzNoiybjwiW
	 0b53gseJksF+KqalOXcr848Hbu9klHl9I79K0IXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/398] drm/amdgpu: check ras and obj before dereference
Date: Wed, 23 Sep 2026 16:04:20 +0200
Message-ID: <20260923140648.252419943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>

[ Upstream commit 723d4dc628d764b19cf9efca14b82cca5ff020c9 ]

nbio_v7_9_handle_ras_controller_intr_no_bifring() dereferences ras and obj
without checking either for NULL. Both amdgpu_ras_get_context() and
amdgpu_ras_find_obj() can return NULL, e.g. during the window between
adev->nbio.ras being set (early in amdgpu_ras_init(), by design, to
enable the fatal-error interrupt as soon as possible) and the PCIE_BIF
ras object actually being created in RAS late_init. Any interrupt in that
window crashes in hard-IRQ context.

This is analogous to commit d190b459b2a4 ("drm/amdgpu: the warning
dereferencing obj for nbio_v7_4"), which fixed the same issue in the
nbio_v7_4 handler.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7692e1ee2446 ("drm/amdgpu: add RAS fatal error handler for NBIO v7.9")
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c7071767a50a32ed727cf800ac84372429e3b4b3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
index 1c22bc11c1f85..a71ad237972ce 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -533,7 +533,7 @@ static void nbio_v7_9_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 						RAS_CNTLR_INTERRUPT_CLEAR, 1);
 		WREG32_SOC15(NBIO, 0, regBIF_BX0_BIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.53.0



