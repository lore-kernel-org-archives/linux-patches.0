Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104128D8E8;
	Thu, 27 Nov 2025 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255575; cv=none; b=A5eAdIJ3JwmFKP8lMk/7JW9JX4wjMS37+zFCiiOztaMmV9JVPlGBJ9DkUPkw7W2c/VGFUjzXX41N/7mbcWrdkLOjd06VyjQL+j+O6vQUq/S0FvI3IOyI4CyU5Voo+C20Tm0bCoyQxluxxOf6TWxVghkB2AqJhkxe5b9O07hxqG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255575; c=relaxed/simple;
	bh=+FPA9cSc4t4skzSWfLVPOaa8InOgC1+Kb7PDIGhCJAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNMldmEHx33pHJ56KAhde4NaaAO0CIESajBBNF2uNyJiKgB4QStEQ6rirbohIkVrzpklqY+pXY5R6C7uXNr7fub4XD3aU7uveXtwDJKsy/S/LuutkT0WMed6j1KQLHglKQlEZQjDTety8uQj2O0d+OfQsM8blJFvz1wTJbLeRdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLH+G3FY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLH+G3FY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028DAC4CEF8;
	Thu, 27 Nov 2025 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255575;
	bh=+FPA9cSc4t4skzSWfLVPOaa8InOgC1+Kb7PDIGhCJAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLH+G3FYXfkW7ceU7hzZSAv/vWjhGUMBQLOpk+ZbajAMnF7rizhtl5iaIFOhi/c0/
	 IcvMRC0ynfOT7rrxMEwNcfUwBrxoIl9OYJgnK2tdB8Bv58XLID6dL4UviSUq/2y8jO
	 xjaWNUDsBxay8Ou+Y9TZB0i9GgdlZqphALpwcFm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.17 041/175] nouveau/firmware: Add missing kfree() of nvkm_falcon_fw::boot
Date: Thu, 27 Nov 2025 15:44:54 +0100
Message-ID: <20251127144044.463866328@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


