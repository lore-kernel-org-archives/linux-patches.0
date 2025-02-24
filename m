Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B12571CB;
	Mon, 24 Feb 2025 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409037; cv=none; b=so5dAjGjc2L/hMADX/MbJNFOBAGrSBg2eJmQhgkm+ClwJ8I2ffUWCXzB+Xp+kusgMt7QTxgEvN2E9MxTSImybBoMEhLJwv2qK3O51uSniK0G8PaRiUW6iNRCwswHLKNFqymkEQV9vbrXhFVWJ4XMvU61Ix47FCZn9KjqtElcf7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409037; c=relaxed/simple;
	bh=3/HKTNj9RGc0cFjuJXGTzQb7DLG6rvgaMR0a9IFbgcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcwpe/+e1toI3Gbq/0VJGs7ghd6UHFyYELgXwPGY6LxfkiydzG3yOd/TfeY/DLYIZqsnEosHhfYdtySqqvRzVAVDpy7V2rHKY1oIMhiHlaCDhmOmU1fF8E37gOumnzSEK15h0c5yJpxd5u9NpOGrjqZMiITRCzSaYuS5X+KEqqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psfQh4YP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psfQh4YP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D284C4CED6;
	Mon, 24 Feb 2025 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409037;
	bh=3/HKTNj9RGc0cFjuJXGTzQb7DLG6rvgaMR0a9IFbgcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psfQh4YPmaWcxFJpMJh7hANuzK5Tfv/nMLsEAmFjHYXvO4ahesyk3t7+g61AncsD0
	 Dd3IXi5gGAULqWGewfp4DqiXmknJ4Dd+Ra3Wn1UL2nFwvAcgVUQ/UtiLk9YksvPx3u
	 x8ZTfXVxAUePVbBApbxmHgXj5xBHGeYkiHDrpoPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 078/138] drm/xe: Fix error handling in xe_irq_install()
Date: Mon, 24 Feb 2025 15:35:08 +0100
Message-ID: <20250224142607.541679346@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 0c455f3a12298e9c89a78d2f3327e15e52c0adc5 ]

When devm_add_action_or_reset() fails, it already calls the function
passed as parameter and that function is already free'ing the irqs.
Drop the goto and just return.

The caller, xe_device_probe(), should also do the same thing instead of
wrongly doing `goto err` and calling the unrelated xe_display_fini()
function.

Fixes: 14d25d8d684d ("drm/xe: change old msi irq api to a new one")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213192909.996148-3-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 121b214cdf10d4129b64f2b1f31807154c74ae55)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_irq.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_irq.c b/drivers/gpu/drm/xe/xe_irq.c
index de220ce113c25..ca04327bd6dfb 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -757,19 +757,7 @@ int xe_irq_install(struct xe_device *xe)
 
 	xe_irq_postinstall(xe);
 
-	err = devm_add_action_or_reset(xe->drm.dev, irq_uninstall, xe);
-	if (err)
-		goto free_irq_handler;
-
-	return 0;
-
-free_irq_handler:
-	if (xe_device_has_msix(xe))
-		xe_irq_msix_free(xe);
-	else
-		xe_irq_msi_free(xe);
-
-	return err;
+	return devm_add_action_or_reset(xe->drm.dev, irq_uninstall, xe);
 }
 
 static void xe_irq_msi_synchronize_irq(struct xe_device *xe)
-- 
2.39.5



