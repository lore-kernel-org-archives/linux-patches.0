Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486FC41B34E;
	Wed,  4 Feb 2026 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218798; cv=none; b=rd2imMj3jZUK5P/RAzv4uYosPTOHCKcoeUb4MWe8be3cs1EydNh+vMgr0O+NAtvIyiao2+9/Ca29FUVOw6ejQPFmVeoBSGarxPqnhZhTZO0q6bUCCiIW+jobPUIo2cBk0WF20hoyMt/pnbs1ASadJXAmgc64ANkW8K+qW8V8aF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218798; c=relaxed/simple;
	bh=ACKFHEHl59J70hgg9WRw/R1XHL9eg8NdFzZZw9E85wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqo3idEbFX9sa1AWzD79axkjPmXvcSAp239G24Yd3ldiNr9KtTInE1l65gStdhyWRNJFbFfmylTZer0YIeDmEvNraNpWeCGO6w/Hg9GQTGxYOVa0xXEY5wCRgREJ+SMzWyj0v8TlHOcmd4jLhgaLOs79cLCJ6ASJ7LfrRLk/hiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5UXa2Qg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5UXa2Qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A8BC4CEF7;
	Wed,  4 Feb 2026 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218798;
	bh=ACKFHEHl59J70hgg9WRw/R1XHL9eg8NdFzZZw9E85wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5UXa2Qg4p2PLBchLu7kkv99tza2sgJWGXMSgBBTMngsrwWsIEPQlZclaox4JAHBI
	 40r9y2X56nGxquxDzxfGCOMhYYKht2rZ5wJAi4+jCsw/UXUeIPU3N9tnmkDZ7d63GW
	 2Qcy7T2WsChqVkYlwffqhfMxsdwmb5k35zV+fTTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Jon Doron <jond@wiz.io>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 65/87] drm/amdgpu: fix NULL pointer dereference in amdgpu_gmc_filter_faults_remove
Date: Wed,  4 Feb 2026 15:41:03 +0100
Message-ID: <20260204143849.257666274@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Jon Doron <jond@wiz.io>

commit 8b1ecc9377bc641533cd9e76dfa3aee3cd04a007 upstream.

On APUs such as Raven and Renoir (GC 9.1.0, 9.2.2, 9.3.0), the ih1 and
ih2 interrupt ring buffers are not initialized. This is by design, as
these secondary IH rings are only available on discrete GPUs. See
vega10_ih_sw_init() which explicitly skips ih1/ih2 initialization when
AMD_IS_APU is set.

However, amdgpu_gmc_filter_faults_remove() unconditionally uses ih1 to
get the timestamp of the last interrupt entry. When retry faults are
enabled on APUs (noretry=0), this function is called from the SVM page
fault recovery path, resulting in a NULL pointer dereference when
amdgpu_ih_decode_iv_ts_helper() attempts to access ih->ring[].

The crash manifests as:

  BUG: kernel NULL pointer dereference, address: 0000000000000004
  RIP: 0010:amdgpu_ih_decode_iv_ts_helper+0x22/0x40 [amdgpu]
  Call Trace:
   amdgpu_gmc_filter_faults_remove+0x60/0x130 [amdgpu]
   svm_range_restore_pages+0xae5/0x11c0 [amdgpu]
   amdgpu_vm_handle_fault+0xc8/0x340 [amdgpu]
   gmc_v9_0_process_interrupt+0x191/0x220 [amdgpu]
   amdgpu_irq_dispatch+0xed/0x2c0 [amdgpu]
   amdgpu_ih_process+0x84/0x100 [amdgpu]

This issue was exposed by commit 1446226d32a4 ("drm/amdgpu: Remove GC HW
IP 9.3.0 from noretry=1") which changed the default for Renoir APU from
noretry=1 to noretry=0, enabling retry fault handling and thus
exercising the buggy code path.

Fix this by adding a check for ih1.ring_size before attempting to use
it. Also restore the soft_ih support from commit dd299441654f ("drm/amdgpu:
Rework retry fault removal").  This is needed if the hardware doesn't
support secondary HW IH rings.

v2: additional updates (Alex)

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3814
Fixes: dd299441654f ("drm/amdgpu: Rework retry fault removal")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Jon Doron <jond@wiz.io>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6ce8d536c80aa1f059e82184f0d1994436b1d526)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -482,8 +482,13 @@ void amdgpu_gmc_filter_faults_remove(str
 
 	if (adev->irq.retry_cam_enabled)
 		return;
+	else if (adev->irq.ih1.ring_size)
+		ih = &adev->irq.ih1;
+	else if (adev->irq.ih_soft.enabled)
+		ih = &adev->irq.ih_soft;
+	else
+		return;
 
-	ih = &adev->irq.ih1;
 	/* Get the WPTR of the last entry in IH ring */
 	last_wptr = amdgpu_ih_get_wptr(adev, ih);
 	/* Order wptr with ring data. */


