Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5017E3B27D1;
	Wed, 23 Sep 2026 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174466; cv=none; b=EZ7quFCDzRvDuZy2T4Ho2V4suRAaJ8tpS8Y5YI/LU7HtJM/ooxoH5SkRa3NzGVqV0nZMdq9EFdhccfb1aGjsJ97m/2ELp5ScOS4w8lXouKn0Apvl4cfTHKBqr4KLBr52cIDIYlxeEM9jwPXQ6HHNAXMphoYjpRX/fxcn2hsQdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174466; c=relaxed/simple;
	bh=TDYPFAfiTqMC1M/1cKvDOq0e+AdBQxWN7lV61njkqww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPN+zV1tJ0SnhbwAsu77HHBhSTZGh+bWPrlYp/0axzclwWT65SisRKe2sRlOmt6FD124G4RNNnviOuPtdX2th7bG2rIHbarDoENciUazNXIYEroIrloHaEPfc2hRj7hZhVUgcmwv4Pt54a9PLgbP3E+f2sRtFJA8RARhYPOV/9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWR+BSIx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWR+BSIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EBB1F000FF;
	Wed, 23 Sep 2026 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174465;
	bh=AvG9NAh9OJB7P96CmPpaodsMANq92ba5YY9zvRKKBcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWR+BSIxumbyT+hxfXbbcDdz1aSDfG6ZxCavYnjfoizBek02lwC9tuVNq/kcs/N9h
	 gFDY36m1o8kbqdE58eOPHbLWml3wkkX80QqnsKGzDwP1OqHHq9L9qqO3nWmdWFOM5W
	 WSY3YJGrMDxFeiG88bRZ7Hsfi9wicIjvdUm16Xv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/398] drm/vc4: Use managed KMS polling to fix UAF on unbind
Date: Wed, 23 Sep 2026 16:03:17 +0200
Message-ID: <20260923140646.630060434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 073a30d75f309812ed61af134f24ffef4107b13a ]

vc4_kms_load() calls drm_kms_helper_poll_init() but the driver provides
no matching drm_kms_helper_poll_fini(). The output poll work stays
scheduled after unbind and runs on the freed drm_device:

  # modprobe vc4; rmmod vc4; sleep 10
  BUG: KASAN: slab-use-after-free in delayed_work_timer_fn
  BUG: KASAN: slab-use-after-free in drm_client_dev_hotplug [drm]
  Workqueue: events output_poll_execute [drm_kms_helper]
  Allocated by task 171: __devm_drm_dev_alloc
  Freed by task 262 (rmmod): drm_dev_put / component_del

Use drmm_kms_helper_poll_init() so polling is finalized with the device,
as other drivers do.

Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260822143110.68594-1-kmehltretter@gmail.com
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index 8f983edb81ff0..20dad6245ac10 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -1162,7 +1162,7 @@ int vc4_kms_load(struct drm_device *dev)
 
 	drm_mode_config_reset(dev);
 
-	drm_kms_helper_poll_init(dev);
+	drmm_kms_helper_poll_init(dev);
 
 	return 0;
 }
-- 
2.53.0



