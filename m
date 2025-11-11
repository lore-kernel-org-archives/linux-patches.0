Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A872DFA5B;
	Tue, 11 Nov 2025 01:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824191; cv=none; b=cwGOw4oWDLoEI8AawZiHiYKCZfFyGOmucXGpbXiTZ0j1vtrsdtV0lDjggj0AV2S/vgQsIBk4ZhBhQ7Djv8xhpEqw/foNMIdgWsfsRekEV30dUSq5wWRk3Dqa4LMNuQ392GCl6qezqVyBJS6o74U1akTim8w+fiv8lmc40y7c+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824191; c=relaxed/simple;
	bh=wdLjeDiCRy08WmLbexUu/BwbbYOPA9Dc0w3QX2bZ6z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5gieKMFigU7/KyV908mtXxrhI6IA3R8rvP71o44/WkS9wC9dZ9W5QFLZC+Gb26WpEGYl9QttyIbYE5TXsGJNhj+5k23XH4npUXjuq5Ar9kpzZTTAJ+w2JTdW7pnNiKJNqMPO2hpFpqzvtZXtx4Kpt66NkXKEmFuY4FA6UXJ9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdBoJxWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdBoJxWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031A0C4CEFB;
	Tue, 11 Nov 2025 01:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824191;
	bh=wdLjeDiCRy08WmLbexUu/BwbbYOPA9Dc0w3QX2bZ6z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdBoJxWI17iVqa8gnf22PGIeQtK3d+NuAc5hgv6jk5cnEbQWJy+jd2yqLo6k0uXJU
	 PHP/0fxHkboTEjpwCcKs3G7Adqt8pC6G7B0RKhe7F6UMqMwWskFZfkQShjH86Yxd1N
	 Zb578hLe8I5V+oiwi+4GKRmTqYQT74Nx2Kxf+y9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 459/849] drm/amd/pm: refine amdgpu pm sysfs node error code
Date: Tue, 11 Nov 2025 09:40:29 +0900
Message-ID: <20251111004547.525220241@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit cf32515a70618c0fb2319bd4a855f4d9447940a8 ]

v1:
Returns different error codes based on the scenario to help the user app understand
the AMDGPU device status when an exception occurs.

v2:
change -NODEV to -EBUSY.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 5fbfe7333b54d..1fca183827c7c 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -110,9 +110,10 @@ static int amdgpu_pm_dev_state_check(struct amdgpu_device *adev, bool runpm)
 	bool runpm_check = runpm ? adev->in_runpm : false;
 
 	if (amdgpu_in_reset(adev))
-		return -EPERM;
+		return -EBUSY;
+
 	if (adev->in_suspend && !runpm_check)
-		return -EPERM;
+		return -EBUSY;
 
 	return 0;
 }
-- 
2.51.0



