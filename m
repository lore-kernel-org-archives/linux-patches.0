Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61A7218D98;
	Tue, 12 Nov 2024 10:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408265; cv=none; b=TwwIVhXEsB7rCX5/G7mnJs3Fit2MdMgGxWBx8I3WIrAvINvNlw+obIzMWtApBMAzgIUuk7cBpvInkX5u4nFPa8xVih2bo9mCOKX3PPnvh4TNwOhAWnBLfek8X99xsfoJgLVgx0Vke8uO4crGlff9WXX8k6xIKXKgZbw+vtNUOvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408265; c=relaxed/simple;
	bh=FiBCxAr/pL7q4CRbMO8aUOKODEulqBTZ0GNAndlFvnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7jAjOSA83G4+DZ4/BHJmaIxBC8eW34bK6PYsuEpDYmlVDlrKy/djoMIJfDtHVPaPQmg13egwjH2aLFEqYMuNMstoLUMXQYJm/foR5mSR9zRGxSPTmGIcTt1tFgC4YEdv0hTyuHuCP4BGopk0v47gsXhngdGI2VYTXgDdn2vHfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwV2686I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwV2686I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4A2C4CECD;
	Tue, 12 Nov 2024 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408265;
	bh=FiBCxAr/pL7q4CRbMO8aUOKODEulqBTZ0GNAndlFvnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwV2686IV1xmnz5to/CczgxNdstwm1pcsmxzfkoTV5/Nzd+YgX4CgSPyMwpao0P7g
	 UYjis/YiZli5+mSp5/r3xZCXzKIvuJEGtb1VTJg0WPdJfVd8znqz76HrTiG1Y4p2TF
	 l9nsWIJOA9pJrKzai/44cWK3LjXuGECxbHqVbjHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 111/184] drm/amdgpu: prevent NULL pointer dereference if ATIF is not supported
Date: Tue, 12 Nov 2024 11:21:09 +0100
Message-ID: <20241112101905.124993185@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@mandelbit.com>

commit a6dd15981c03f2cdc9a351a278f09b5479d53d2e upstream.

acpi_evaluate_object() may return AE_NOT_FOUND (failure), which
would result in dereferencing buffer.pointer (obj) while being NULL.

Although this case may be unrealistic for the current code, it is
still better to protect against possible bugs.

Bail out also when status is AE_NOT_FOUND.

This fixes 1 FORWARD_NULL issue reported by Coverity
Report: CID 1600951:  Null pointer dereferences  (FORWARD_NULL)

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Fixes: c9b7c809b89f ("drm/amd: Guard against bad data for ATIF ACPI method")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241031152848.4716-1-antonio@mandelbit.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 91c9e221fe2553edf2db71627d8453f083de87a1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -172,8 +172,8 @@ static union acpi_object *amdgpu_atif_ca
 				      &buffer);
 	obj = (union acpi_object *)buffer.pointer;
 
-	/* Fail if calling the method fails and ATIF is supported */
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+	/* Fail if calling the method fails */
+	if (ACPI_FAILURE(status)) {
 		DRM_DEBUG_DRIVER("failed to evaluate ATIF got %s\n",
 				 acpi_format_exception(status));
 		kfree(obj);


