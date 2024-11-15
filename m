Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367EC3BBEB;
	Fri, 15 Nov 2024 06:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652801; cv=none; b=cZxN8Spj2XYAkqJJk35yyN4q3czbvkYQbu/Ue51tvly4mCVfMvQbvr03Evo32Ouewdfx7mu1FPf7m0Rd2N6t7SHgEKsG3sE84GHSEWJpl90XyjQIgmpjwy0af23fOEnc9uOdR9LEHH/8Eb29Odz4N/8HyJ/K0vT59fiVuK3hbzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652801; c=relaxed/simple;
	bh=8lv4d5cPIHoUnINwlCF6fyBiXmoXdIcguX4q8UoLDNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZNQ0PORX5HEzvMk+6SpTvoaQb4DDwa4DNM4mJP/zuizl5QCTz+MsUewv6EFL19Bj/bUccayZcuEkejQ7zTWUz9ny1Q7R9UI3dgsv7FoHY9o8epyOIgcaC/xZprZ3a8PTnjdXuPk7AdkeNFnb4EXvocZkodFzuGBmeqoELd1roM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omt/THVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omt/THVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BBEC4CECF;
	Fri, 15 Nov 2024 06:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652800;
	bh=8lv4d5cPIHoUnINwlCF6fyBiXmoXdIcguX4q8UoLDNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omt/THVdPi7370FefFt2J86tzxsNKjQ4rSDI0faBIcw69LCEq/YWnfWraqQOpvC5s
	 6nhfWmrFyzKPtJ+sTyvO5cT2c51Zoz5OiadkAK1u4cjwc6oc/f/23JJH8jo447Q7K7
	 QK7ZjucdJQpCrjEEo4I9yq75HKM/iaDQWSauRBF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 19/52] drm/amdgpu: prevent NULL pointer dereference if ATIF is not supported
Date: Fri, 15 Nov 2024 07:37:32 +0100
Message-ID: <20241115063723.550265302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,8 +115,8 @@ static union acpi_object *amdgpu_atif_ca
 				      &buffer);
 	obj = (union acpi_object *)buffer.pointer;
 
-	/* Fail if calling the method fails and ATIF is supported */
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+	/* Fail if calling the method fails */
+	if (ACPI_FAILURE(status)) {
 		DRM_DEBUG_DRIVER("failed to evaluate ATIF got %s\n",
 				 acpi_format_exception(status));
 		kfree(obj);


