Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BEE2141A5;
	Tue, 12 Nov 2024 10:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407377; cv=none; b=kRBPD5jkeridT2w5ywdfsSNpAd5UnttMNzrQgaHJA2MRXHryB5j4yHzdbifX2p9YP9lrx8abQJLn55By1MhCNr6IfFUzj6sqO52+hAdkEBawIugXCY740fWcL9K6I0O0oGv7SJixLJRHkwpaKBtIZato4BlNzfTtXFMY0azqoQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407377; c=relaxed/simple;
	bh=6A9wYgpecM+UrMpBIwKIKJyx0zeYcAOCG9g9g15pVGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzUsOwAm09zC+qtZ+USjQFF7jtpCJ7KBs3xpz/MbLDIyhX8uddzACMhk4qYyLPTezFGCI//c101uNvahqwCCs6yknBdRYn7MMxjVax/T03Ip5MA6fQV7ioxHPIeNqC+vGv+2XGZYrg5564RzMFTmAnrDciOtihBmrA9rrAqapDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6RkZfeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6RkZfeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75967C4CECD;
	Tue, 12 Nov 2024 10:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407376;
	bh=6A9wYgpecM+UrMpBIwKIKJyx0zeYcAOCG9g9g15pVGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6RkZfeVCmaZnR53YiloZEqA7xGusvR0SjzdncHMdjOPsr9X3od8dBcRcamIEccyt
	 fpeMdQzhGssPCz9TXyvMz8hQHgX4ju2QFj/M30nYPCWrDPu7rGfJ6diXkMrLBEl0TB
	 E2ML7v8ROTBWoNyu9Yx1zKfEsTlv2+N5UO8mCNA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 58/98] drm/amdgpu: prevent NULL pointer dereference if ATIF is not supported
Date: Tue, 12 Nov 2024 11:21:13 +0100
Message-ID: <20241112101846.476196447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -132,8 +132,8 @@ static union acpi_object *amdgpu_atif_ca
 				      &buffer);
 	obj = (union acpi_object *)buffer.pointer;
 
-	/* Fail if calling the method fails and ATIF is supported */
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+	/* Fail if calling the method fails */
+	if (ACPI_FAILURE(status)) {
 		DRM_DEBUG_DRIVER("failed to evaluate ATIF got %s\n",
 				 acpi_format_exception(status));
 		kfree(obj);


