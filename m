Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76685678FD;
	Wed,  9 Sep 2026 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963013; cv=none; b=Weiaf59NordCofzQmMgd1H/c/bprHG6O5RQoLoqOEEawSc6yW0Nv+s+v0fYuYkL+SF6KKmw//j+qptJFAUwdiLEnGZbZcvY/8YLENqTQC6/hN9sStCuzSMDqbcFCNHNebZiEefArV8WSeoAtDN/JqI9x/etcvkVg1eC19s2QAkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963013; c=relaxed/simple;
	bh=vWQTApPGi4kRILHDgdAqzQVikjcQj9YwlmF78mygaqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MW95gODxjzz1wIJqf4JFfANDOSleqlH8CDOPmyIUzIjuoAQ6a9wzEFP1S5MBE7Ud9a4WJGu4gGleC10AZDvTZUd2pTEgZlVtvCmePY5vUnzpoUITyijGxvEgVe2qUB2gINGCUnkCWc3d/BjrR/CR1jdYF4BMsA2c4MgEomrAwzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+7WnPY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+7WnPY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5187D1F00A3D;
	Wed,  9 Sep 2026 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963011;
	bh=8n4pkxiYF5pjT9HUmhqVtYqqqLtO2/L0yXoHeja9YdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+7WnPY7/T9cIih88zM4dR1/1OGFNk+qoSGpO+3YzP+roxgw4hiSececBYFIT8h6W
	 XtB+olcOZ7DzNaOdIcTtyVYdxTRLqqezQFqs1SUn8jAMIhHJ0saxAZh+dzUwGpdX0n
	 eBr8NohUWB+a0z4acpoJ8iqArfcnHRwgl+KX079Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Roman Li <roman.li@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 490/556] drm/amd/display: Fix HPD consideration for VGA/LVDS connectors on DCE
Date: Wed,  9 Sep 2026 15:42:50 +0200
Message-ID: <20260909134247.728680344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

commit 52536ce677a3470c0e5323b940791efb33975450 upstream.

After a refactor that landed in Linux 7.0,
DC now crashes when it is initialized on GPUs
that have a VGA or LVDS connector. This is because
these connectors have no HPD so the hpd_gpio is NULL
and therefore DC takes the code path meant for
DCN 4.2+ which sets irq_source_hpd = 255 that
causes the subsequent code to try to register
the HPD interrupt, which fails, and causes
a crash.

This commit should be backported to Linux 7.0 and newer.

Cc: stable@vger.kernel.org
Cc: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Cc: Roman Li <roman.li@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5490
Fixes: def3488eb0fd ("drm/amd/display: refactor HPD to increase flexibility")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260821215059.312868-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -632,7 +632,7 @@ static bool construct_phy(struct dc_link
 
 		DC_LOG_DC("BIOS object table - hpd_gpio id: %d", enc_init_data.hpd_gpio->id);
 		DC_LOG_DC("BIOS object table - hpd_gpio en: %d", enc_init_data.hpd_gpio->en);
-	} else {
+	} else if (link->ctx->dce_version > DCN_VERSION_4_01) {
 		struct graphics_object_hpd_info hpd_info;
 
 		if (link->ctx->dc_bios->funcs->get_hpd_info(link->ctx->dc_bios, link->link_id, &hpd_info) == BP_RESULT_OK) {


