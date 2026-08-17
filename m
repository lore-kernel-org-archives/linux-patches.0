Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903073F12C6;
	Mon, 17 Aug 2026 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979666; cv=none; b=qxdUt7B+yqy+zh5WpiSv77WfDS4KAGuMBT8q9AK6TDiEIXJsCK9klPl4Ep8d+nzTLwLMfugvKtWQ5j2NWYaJw3i1MLHE9GjgTqqEyXQ/TO+BpdeAJBoP7zkXCsIQQd7Om9oq40TDNe/bJevYBA3h6GIyXNx4MbGhZ1b0Zj/2cWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979666; c=relaxed/simple;
	bh=nsOtl8+bdExOZxJgH2dYa6aa0PGqUGhHfgQgOFS3m1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0pgAi6OboMMwT+Yn+536/a4d+clibCeb5Q0pUOa41+9aOvQQaN57JsUMVneq2KEsNXdiinakrmRhw0/8kfksp4nOK460EY1gSPax3OsGhB8k8xHxK8LrAMyTaKU+jaxJd8I/uODaOH4JUce8vi/NHCQiw0cS5GkuUoOPwre0R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FumqchUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FumqchUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BAE1F00A3A;
	Mon, 17 Aug 2026 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979665;
	bh=+rYMKW+AkhXIWiVenU6j5dLtoCoXd/TqGfggAmhCBWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FumqchUjt/CqISJqoIR+9Hz2kyNAn7TEK6Kt8Ul5Q477FpI2jX1OXa2PkY0+CowAW
	 zy+O7bwaDQSmBRsLwHLfCiVy9Z8NFKDVBjtfYsS57BUeeJfIfdY2LPJrUJBie4WZyU
	 +H7xyDChG+qCtKb2k0jUBuVrXtWDpLtrqrcFeA3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 278/609] drm/amd/pm: make pp_features read-only when scpm is enabled
Date: Mon, 17 Aug 2026 15:29:34 +0200
Message-ID: <20260817132553.455110027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 53c78ab388bfc1a4d72e756815d0db0a842c812e upstream.

SCPM owns power feature control when enabled.

Make pp_features read-only during sysfs setup by clearing its write bits
and store callback.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6a5786e191fdce36c5db170e5209cf609e8f0087)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2004,6 +2004,11 @@ static int default_attr_update(struct am
 	} else if (DEVICE_ATTR_IS(pp_features)) {
 		if (adev->flags & AMD_IS_APU || gc_ver < IP_VERSION(9, 0, 0))
 			*states = ATTR_STATE_UNSUPPORTED;
+
+		if (adev->scpm_enabled) {
+			dev_attr->attr.mode &= ~S_IWUGO;
+			dev_attr->store = NULL;
+		}
 	} else if (DEVICE_ATTR_IS(gpu_metrics)) {
 		if (gc_ver < IP_VERSION(9, 1, 0))
 			*states = ATTR_STATE_UNSUPPORTED;


