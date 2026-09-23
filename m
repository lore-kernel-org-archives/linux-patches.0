Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFB749DB99;
	Wed, 23 Sep 2026 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173237; cv=none; b=Y9+RwxlKyDz/tMOPNBcEFdxbL+pbLKR1SxvmRMjizt5LY8oBiEyW5/+8GCgfA9XgTug9C53KPSWBbNOvmplpXHcnMu9IUgYSNdV6iDNqNCKNV98kUXk4aYlg3b6K/CgrTtY/9Hww6dPFoXjI6zZbRtKTPwcwT1lV45C4hwnxeYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173237; c=relaxed/simple;
	bh=Dhp2HumRnTXc5UwazAZvoT/9pZzbPfaa2tXBe3YwPP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jNL9sMzf+suX6MHviBGk3Ufvm3VbXOls/V+5eb2XBSfhGz186Phh4dzNrfwiAO5sCFQZlmWjO3oyE//65RzyrBOAcvS6pfgrWOjl9PySSPqn/V3YMKYJdWG6KtDm4MpsZLPDVObP2QRQh89s0c7VhwiiAiIOCGoEjTXRd6i+wFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOpXQzbz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOpXQzbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FBD1F000FF;
	Wed, 23 Sep 2026 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173236;
	bh=FOm347BktZwO+YYbtGj4Vwso2RsgO3PiKpF/HWjP3jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOpXQzbzH3bwnLeYgdoVPJtHAVl9KJJ7TwBYU5cXVlndVKRePwrGbVPMn+6Fg9sNg
	 wVCkqBXRyhEY1Zu5ot/239btHB5Cnq5w4/tFi44Zj/V7HbRaYBjhAnd/N9kZPZCmaF
	 s7m1mfPiJVteAssXD/FodkoNV9GK4iqD9edtaJPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 149/438] drm/vc4: Use managed KMS polling to fix UAF on unbind
Date: Wed, 23 Sep 2026 16:02:50 +0200
Message-ID: <20260923140648.633629835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b17e73bce3841..82a7f2ac4c7e2 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -1188,7 +1188,7 @@ int vc4_kms_load(struct drm_device *dev)
 
 	drm_mode_config_reset(dev);
 
-	drm_kms_helper_poll_init(dev);
+	drmm_kms_helper_poll_init(dev);
 
 	return 0;
 }
-- 
2.53.0



