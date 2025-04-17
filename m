Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2451A5BBB;
	Thu, 17 Apr 2025 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915927; cv=none; b=TvXrxu/qTXrRaEFpsMqOo8SZxagNUNfqcmKJUHoFYDGFLMg7c8RUbCHFklg8NnlTxxuD2dRg0s3ZogUylTg9tkpvdfdfbAuldpFGDpQfPqY0i4FDoyySNBPsvPD8f8j44ZDxqfnLN44eNhM5j/UY5A7RsT7nubPbNKRPqX34FWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915927; c=relaxed/simple;
	bh=0kolm+dXXMALAfAy/T10fGkBID1mPissYgO9fhDDBgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd+z8xAQDu+zXoQ9+ZPEbVbN/ZkfsfZGBkH+kEY3Jpgv+CI0aOVbfQyNtQlOyn7wgU8J9vKwcZogJPl22Ej5XRXPQqPZ8wN7fEbFeWRlU9EOmLw7UduIA0nkTBQguur9mB5ELUZQA4logp7LMMwLMsjtel6wwADZvuS5ejunBHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sl5UHCMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sl5UHCMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5CAC4CEE4;
	Thu, 17 Apr 2025 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915927;
	bh=0kolm+dXXMALAfAy/T10fGkBID1mPissYgO9fhDDBgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sl5UHCMlAJpfNHGP5NCxwDYtJK7EzWCdOF2ARracRPyP+toLPfiOks/Y4ss3+FxMB
	 hO/guKNIPscO6yrsDjG1Qw6Fm2Rfy3lnGMBLKKEfyagjQvhBx4+b2cNygWTgguvwVB
	 rzRRec/vp2D+0Ia9GUfAtSuVyumWqX1QC3hlUUk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 257/393] accel/ivpu: Fix warning in ivpu_ipc_send_receive_internal()
Date: Thu, 17 Apr 2025 19:51:06 +0200
Message-ID: <20250417175117.930395210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 6b4568b675b14cf890c0c21779773c3e08e80ce5 upstream.

Warn if device is suspended only when runtime PM is enabled.
Runtime PM is disabled during reset/recovery and it is not an error
to use ivpu_ipc_send_receive_internal() in such cases.

Fixes: 5eaa49741119 ("accel/ivpu: Prevent recovery invocation during probe and resume")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250325114219.3739951-1-maciej.falkowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_ipc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -299,7 +299,8 @@ ivpu_ipc_send_receive_internal(struct iv
 	struct ivpu_ipc_consumer cons;
 	int ret;
 
-	drm_WARN_ON(&vdev->drm, pm_runtime_status_suspended(vdev->drm.dev));
+	drm_WARN_ON(&vdev->drm, pm_runtime_status_suspended(vdev->drm.dev) &&
+		    pm_runtime_enabled(vdev->drm.dev));
 
 	ivpu_ipc_consumer_add(vdev, &cons, channel, NULL);
 


