Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AC227FD75;
	Wed, 23 Apr 2025 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420863; cv=none; b=ZYLbxjzRp7XyIHlQUtjBC4eL32P/U5N5VuZfUwr2lqysx4Log1XUDQSjet/B4AXRgie/xleTRl1jGaG93UKnhguUe8EaybrC6y4zdfAEVVeexJFGLDpQbdIb6iUeGO2vhPZVBl97eCupor1oLz5tC/8p1fdlJGb2JtHnTFhizu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420863; c=relaxed/simple;
	bh=dKK7Hycen4Uc9fLuWUy8/8zWHBvMzc673l7NbIQ4uds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzNzpgE/EWUKIMAVDvp2NKM1dAgS4XNoy8JWYNM7qwrY6CSWdcOhaNRE+Dre+IVlB3Vxp+NZocjDcFkmwHJmvRBRSJvRL2nPyoUGRCPmHE8pLK/az3dMkeJT/zxFTN47n83ACZuDb/qHPPQnAZ6edjxIKZWT5jgpojdojaMVIek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbfUDQZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbfUDQZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC31C4CEE2;
	Wed, 23 Apr 2025 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420863;
	bh=dKK7Hycen4Uc9fLuWUy8/8zWHBvMzc673l7NbIQ4uds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbfUDQZzoFsWedwv+JUIgXPqqodCVpXzAKOK82426VJZNaLATzVFIcyXTB0E4RpIH
	 l2pTFsVxLFSTjGHUGQ9+5Fehs/ZlZoyukPzLJqRefRKwR6ZLGTgA8w+UuiKaTIsBRV
	 R+D8WVUQToPA4SHYkr0d946AWi4gkfjtj3at9qho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 169/223] drm/amdgpu/mes11: optimize MES pipe FW version fetching
Date: Wed, 23 Apr 2025 16:44:01 +0200
Message-ID: <20250423142624.048584677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit b71a2bb0ce07f40f92f59ed7f283068e41b10075 upstream.

Don't fetch it again if we already have it.  It seems the
registers don't reliably have the value at resume in some
cases.

Fixes: 028c3fb37e70 ("drm/amdgpu/mes11: initiate mes v11 support")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4083
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -859,6 +859,10 @@ static void mes_v11_0_get_fw_version(str
 {
 	int pipe;
 
+	/* return early if we have already fetched these */
+	if (adev->mes.sched_version && adev->mes.kiq_version)
+		return;
+
 	/* get MES scheduler/KIQ versions */
 	mutex_lock(&adev->srbm_mutex);
 


