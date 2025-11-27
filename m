Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB62432B988;
	Thu, 27 Nov 2025 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255255; cv=none; b=QyNU82q26e+0NnLestFGV/GGLA6Ph8g+l3D5JvqNf9t2AXd6oQr5z5N0tK9A9D9nLlJieuZTGryTun/uXDiwoBOERF1xAdMvN0Dq82Ig+D0JB6mr/STBfGgT8BIdWDyCyV5B5GydotFC3uT/lKiqhFm2F4UAAwxYtE7OEgxaHIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255255; c=relaxed/simple;
	bh=waWsMW/hgUynWetibOLOI7vw1OdbFKmFjBo5LUn5Vtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y31OoR2J/zW/2WaqQgOvElwk74l49t3urHXkN24QBT1xynMU9381BjbGXgn/lIRDioSYpHQDLrSVELSIe2NlbNR/yhnKcEmv2okaYPSiHCOgUEJCnM60iuZtex7KZgjFCjjnnZe7gGGQR89atqHZKz74bPrItRJetFiVz2N273c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOnpZDXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOnpZDXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF44BC4CEF8;
	Thu, 27 Nov 2025 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255255;
	bh=waWsMW/hgUynWetibOLOI7vw1OdbFKmFjBo5LUn5Vtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOnpZDXR7TBjXcoEiXTDYTXOSQVgdMrwNfB+ZelShW2Fa5a51DlTm0lkxmS7+a9KH
	 uOBcGBJygfu+UJ/oGwnpjiGzX6PMUPXqD2cxavjmrzJ+lC3kEP6srxdAKpMae34VAC
	 VH3WmHOg1cQ3YnxGkijPkVK1CN+AYmknW2aVdbFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.12 028/112] nouveau/firmware: Add missing kfree() of nvkm_falcon_fw::boot
Date: Thu, 27 Nov 2025 15:45:30 +0100
Message-ID: <20251127144033.869807192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 949f1fd2225baefbea2995afa807dba5cbdb6bd3 upstream.

nvkm_falcon_fw::boot is allocated, but no one frees it. This causes a
kmemleak warning.

Make sure this data is deallocated.

Fixes: 2541626cfb79 ("drm/nouveau/acr: use common falcon HS FW code for ACR FWs")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251117084231.2910561-1-namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
@@ -159,6 +159,8 @@ nvkm_falcon_fw_dtor(struct nvkm_falcon_f
 	nvkm_memory_unref(&fw->inst);
 	nvkm_falcon_fw_dtor_sigs(fw);
 	nvkm_firmware_dtor(&fw->fw);
+	kfree(fw->boot);
+	fw->boot = NULL;
 }
 
 static const struct nvkm_firmware_func


