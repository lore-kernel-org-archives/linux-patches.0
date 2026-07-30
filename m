Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B5E30F94D;
	Thu, 30 Jul 2026 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422596; cv=none; b=PBo3k88G3PXsT+Pf/dqVSC+O8uHBjmA3YvMsmyrnaAKjQaaBRjCCqjQeFcBSlfQtfWhpBKm3DCW5u6kg96Oeln4Jx/JlzBiLOWVCs42Sgf+m/dypvpq6k6mxA0Z6T1cFtelazgMQPoIP0ll9SV/i0OT3E/HcKxVTHUqCkR296bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422596; c=relaxed/simple;
	bh=wkun7Ce430r0Jqkde3pSWs422/BBNczuLY4n8SwSI/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIKayAqrTv4LNUVtWNGaxuveWjzHMvmSRqIA+a3hKv8fbDQmrkt3lx7OUYAPDAyRiiL0QiOUm1KaHJxVe9GK5HIX8JoNUDTfjsTRZ+v3lldFS2W1IVd0hp/Ssxnia8Kbc7xl/qqizQ4GyXk8Wbb5hEk0O4gurYytrLdtQ7fDdLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QU7IknTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QU7IknTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D5F1F00A3A;
	Thu, 30 Jul 2026 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422591;
	bh=hCy5jMe8jwxlSzuPm3a4EcujNlN/X4phoCsvdtc22wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QU7IknTDq+pdrdGjqh1yoQUgQCdIR/NhF9Ty4FgoppWue7Th07ej0WrzDylB3mMwO
	 Ho3a6WUn3SlE2YpyGGJrLJ8B3IUBNihNrJEJYzfG4aRQJCLD7GUKXjP4X9TE+dpng4
	 Qm6rz/LjQpc14kz6YLPIQd8D5s3i/NMDQ5KrTLN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 490/744] media: mali-c55: Disable pm_runtime on probe error
Date: Thu, 30 Jul 2026 16:12:43 +0200
Message-ID: <20260730141454.708652491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit a1db83cc6f7e88a166c77d9060507ec01d617784 upstream.

When mali_c55_media_frameworks_init() fails, the goto target jumps to
err_free_context_registers, skipping pm_runtime_disable() despite
pm_runtime having already been enabled earlier in the function.

Fix this by adding an err_pm_runtime_disable label and redirecting the
frameworks init failure to it, so pm_runtime is properly unwound on
that error path. The runtime PM status is also set back to suspended
before disabling, to undo the pm_runtime_set_active() from probe.

Cc: stable@vger.kernel.org
Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/arm/mali-c55/mali-c55-core.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
@@ -828,7 +828,7 @@ static int mali_c55_probe(struct platfor
 
 	ret = mali_c55_media_frameworks_init(mali_c55);
 	if (ret)
-		goto err_free_context_registers;
+		goto err_pm_runtime_disable;
 
 	pm_runtime_idle(&pdev->dev);
 
@@ -843,8 +843,9 @@ static int mali_c55_probe(struct platfor
 
 err_deinit_media_frameworks:
 	mali_c55_media_frameworks_deinit(mali_c55);
+err_pm_runtime_disable:
+	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-err_free_context_registers:
 	kfree(mali_c55->context.registers);
 err_power_off:
 	__mali_c55_power_off(mali_c55);


