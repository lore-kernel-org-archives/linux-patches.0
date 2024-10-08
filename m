Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70D0189910;
	Tue,  8 Oct 2024 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392383; cv=none; b=u5mawIC+9UptY2ttREMQPTYL7qBgvDIu8EW0+vYddhiPpIvufT10OjLEzQceODgzABnyJCgais/WtcBC1uGGWyh+FulPiZFmlqjGxf1jXjzOkvNQeVI01cD3afDR5TraGOwkYRFAllPd+Y76ZbKVAiUS58+Ie31qhLwM/UN/EeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392383; c=relaxed/simple;
	bh=YsLlpCnLZ4WjKfSh24XEgYtwZHqPtz4HbRIO2dFWn8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuI2gP+TtNkFTEQdPm2Yj58E8puuLBrVcuWlnK6JiAnL4G2TWx3dNBg+UWrf0uOfb2/21VJ5JKdUyjx8g3udY/aaEcI5MZamIYGfj4uFUhrf4AGehQszgrEgP0KJrADiTw49SFYrmk6iaVdazoqlpfEu7Y2bSpHK/we1WSpMWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2Pwacgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2Pwacgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362E7C4CEC7;
	Tue,  8 Oct 2024 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392383;
	bh=YsLlpCnLZ4WjKfSh24XEgYtwZHqPtz4HbRIO2dFWn8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2Pwacgngljzmv9vvHBneViSsWOnN1flN/b1AnE2T7RZsDBgnsSju1m8Fcq5mh95t
	 lxQUzPub0MVTqPwwkdYYc+blh9uhjwpQTPmvqEF5MOwyhAMmMUWE9ImnKcan6VkU57
	 ujTjCRFKCeD5F9lKUKuit2Jlt5zFgZQkZmU+rwYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 399/558] drm/xe: Generate oob before compiling anything
Date: Tue,  8 Oct 2024 14:07:09 +0200
Message-ID: <20241008115717.980993978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit ea74bf9ccba9ae80fc0766c07c4abaef927e9e63 upstream.

Instead of keep adding more dependencies as WAs are needed in different
places of the driver, just add a rule with all the objects so the code
generation happens before anything else.

While at it, group lines related to wa_oob in the Makefile.

v2: Prefix $(obj) when declaring dependency

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240708213041.1734028-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/Makefile |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -12,34 +12,15 @@ subdir-ccflags-$(CONFIG_DRM_XE_WERROR) +
 subdir-ccflags-y += -I$(obj) -I$(src)
 
 # generated sources
-hostprogs := xe_gen_wa_oob
 
+hostprogs := xe_gen_wa_oob
 generated_oob := $(obj)/generated/xe_wa_oob.c $(obj)/generated/xe_wa_oob.h
-
 quiet_cmd_wa_oob = GEN     $(notdir $(generated_oob))
       cmd_wa_oob = mkdir -p $(@D); $^ $(generated_oob)
-
 $(obj)/generated/%_wa_oob.c $(obj)/generated/%_wa_oob.h: $(obj)/xe_gen_wa_oob \
 		 $(src)/xe_wa_oob.rules
 	$(call cmd,wa_oob)
 
-uses_generated_oob := \
-	$(obj)/xe_ggtt.o \
-	$(obj)/xe_device.o \
-	$(obj)/xe_gsc.o \
-	$(obj)/xe_gt.o \
-	$(obj)/xe_guc.o \
-	$(obj)/xe_guc_ads.o \
-	$(obj)/xe_guc_pc.o \
-	$(obj)/xe_migrate.o \
-	$(obj)/xe_pat.o \
-	$(obj)/xe_ring_ops.o \
-	$(obj)/xe_vm.o \
-	$(obj)/xe_wa.o \
-	$(obj)/xe_ttm_stolen_mgr.o
-
-$(uses_generated_oob): $(generated_oob)
-
 # Please keep these build lists sorted!
 
 # core driver code
@@ -322,3 +303,6 @@ quiet_cmd_hdrtest = HDRTEST $(patsubst %
 
 $(obj)/%.hdrtest: $(src)/%.h FORCE
 	$(call if_changed_dep,hdrtest)
+
+uses_generated_oob := $(addprefix $(obj)/, $(xe-y))
+$(uses_generated_oob): $(obj)/generated/xe_wa_oob.h


