Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5EC509F05;
	Wed, 30 Sep 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787606; cv=none; b=lT9lPd7oZhxyI8HlKWRZoHvX5z4nUrnOZcN5FEzXvpcrcpCdTRJG/HZaZvNk5MKaPKXGu8xQyLmVnJTYSzEKjoChDwUxXQ1Y4PTmlsOMltiTpsBgsfJvguTgyxslDJBhzqLdU7z1ASPdNIQdyf833wDjp1i26F+qtYIY6GaK3xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787606; c=relaxed/simple;
	bh=BZY855hYihsgGp0FzN4Ks1ij9c+BpnoBKuFRN5PCph4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfEh4Dz4Gg9ckcVWJwxxQuE9Ip93QDi5RYDiRyJT2hlHrxk8H6t4xXXIgyTNJJEFcvPS8j27ilAaHes0q4GGry41PxKkxIwXqB6XJ7JjYKkl4dJZrHSM443xIfo4rXbckkZ19LWkpEMesOLfKQmzEqh1BAbNG3M6CFa+tfeoLeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qn4XT39a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qn4XT39a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFACC1F000FF;
	Wed, 30 Sep 2026 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787605;
	bh=0/yxVRoh/HPakPgjM20oDq34tgIsCi1qkDXHrvwwu+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qn4XT39aDflZ+G5o2h7R8TMZKJHx9sDtg5IeliJl9Wjv27+Jwg8dx5RCwX/BJQ2rL
	 aUXVGfe0X8hoxiGP+SBqv3SaC1U3A5vjjy8uy1+iOmfVpEyoqyjVekqWtkXzWBvhu/
	 oIHrklGcS+tMuG3sqPhn7145x0uTSw8mBoTIJfh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 288/457] drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()
Date: Wed, 30 Sep 2026 17:26:33 +0200
Message-ID: <20260930152352.250216491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit a997baa61179b450bd55c4810c7ccfed3b753a54 upstream.

amdgpu_acpi_enumerate_xcc() looks up each XCC ACPI device with
acpi_dev_get_first_match_dev(), which takes a reference to the device.
The reference is dropped with acpi_dev_put() after the XCC info is
initialized, but if the kzalloc_obj() allocation of the XCC info fails
the function returns -ENOMEM without releasing the reference, leaking
the last reference to the ACPI device.

Drop the ACPI device reference on the allocation failure path before
returning.

Fixes: 4d5275ab0b18 ("drm/amdgpu: Add parsing of acpi xcc objects")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9211ef48b31ec66999cf55e04d0cbc60cd855fd5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1167,8 +1167,10 @@ int amdgpu_acpi_enumerate_xcc(void)
 		}
 
 		xcc_info = kzalloc_obj(struct amdgpu_acpi_xcc_info);
-		if (!xcc_info)
+		if (!xcc_info) {
+			acpi_dev_put(acpi_dev);
 			return -ENOMEM;
+		}
 
 		INIT_LIST_HEAD(&xcc_info->list);
 		xcc_info->handle = acpi_device_handle(acpi_dev);


