Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37BB34676D;
	Tue, 11 Nov 2025 01:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824169; cv=none; b=KtFNLW9qvE7hrQ4+c1lgfuvG8cwgqv89iaHdvbvI+oJOnIlWWfULZQFz2iGcjdrSXHIKbZgzWaQlI93iRhpxtrM2q5cjEF4G1STrAgWPgxfikDTkLTAi/Zz/hG5LudRmtBZFU7n+kDJQT0Ye6krtKVeW+Ci3lencJClN/MG9qBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824169; c=relaxed/simple;
	bh=U5HNWWi5mIIyUqCtiaimQKo99BLl+miY0KeKWCw7hw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2i20J+XZshCu+DQrPwEE1Q/2HdD0JA3TlB93c+AZXZow22AuI/aewRWvbSUcCsmOwlf4tD/rWSomB3ZXaM4sSsSBWsBA+EzC/Gi/IorwaYhoxmq0foSKhPYsb7c7+iArtXGv+EfhCrAVyR6iP6MyvC8eDaZ3kvRRoha3nfT4HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2plKmpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2plKmpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E255EC4CEF5;
	Tue, 11 Nov 2025 01:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824169;
	bh=U5HNWWi5mIIyUqCtiaimQKo99BLl+miY0KeKWCw7hw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2plKmpu45l1DrkqBw/kWo3hmXhJ6v0L+eMurMI31EW0jFv+Zil7+OCD//oebP7nF
	 pRlvAAPCC+8I4mUgSMWLzssBu8/PrKfy8totP64YBp7sYoWL8GFaGNaMfW3CmwlW8F
	 rBNMePe9KTlOVSp6X8ip6xEgK5SdciwkukvV4nSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AceLan Kao <acelan.kao@canonical.com>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Denis Benato <benato.denis96@gmail.com>,
	=?UTF-8?q?Merthan=20Karaka=C5=9F?= <m3rthn.k@gmail.com>,
	Eric Naim <dnaim@cachyos.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/565] drm/amd: Avoid evicting resources at S5
Date: Tue, 11 Nov 2025 09:43:39 +0900
Message-ID: <20251111004535.033781019@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 531df041f2a5296174abd8292d298eb62fe1ea97 ]

Normally resources are evicted on dGPUs at suspend or hibernate and
on APUs at hibernate.  These steps are unnecessary when using the S4
callbacks to put the system into S5.

Cc: AceLan Kao <acelan.kao@canonical.com>
Cc: Kai-Heng Feng <kaihengf@nvidia.com>
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>
Cc: Denis Benato <benato.denis96@gmail.com>
Cc: Merthan Karakaş <m3rthn.k@gmail.com>
Tested-by: Eric Naim <dnaim@cachyos.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 7ff81bd1ec200..7a8a53fbe918c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4731,6 +4731,10 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 	if ((adev->in_s3 || adev->in_s0ix) && (adev->flags & AMD_IS_APU))
 		return 0;
 
+	/* No need to evict when going to S5 through S4 callbacks */
+	if (system_state == SYSTEM_POWER_OFF)
+		return 0;
+
 	ret = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
 	if (ret)
 		DRM_WARN("evicting device resources failed\n");
-- 
2.51.0



