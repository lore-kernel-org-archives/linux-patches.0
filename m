Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8227F755;
	Wed, 23 Apr 2025 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420652; cv=none; b=SQSoUTyESNAtUZUOpbAUy3Z28NHEa9yZQJqWZPcqdC5UW3QJUxeopGi3LsgoF6xYLIa30EiKfP6/mVArXrnOFpJFoqf/ISlWmyGL3azZPw41GoZyqCNgZzIu1Oz+6bDOBzAA2lU967js81uuxfgS1tTe2RedpojeVH56+8SLyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420652; c=relaxed/simple;
	bh=sKitR6gJOaJO9GdmcJigpdI4xJqqgrf+Z96bcERjt3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTiuf9MCcTH4Pvby29pGg1wjw13A+G3ug08yE+G1WFt7xhtRIxvnOC1klw2Gpt/B7dSjqbCaIT9KJw26xeyS/soEhnpketrmM1mrDiA2elrmUB8b0ajGWFELmzJFSC/ohwZIzoMhWMzrf4/Fvo9SJj/HXarj1BuAfAeavUu5lps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okGMgR0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okGMgR0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3D9C4CEE2;
	Wed, 23 Apr 2025 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420650;
	bh=sKitR6gJOaJO9GdmcJigpdI4xJqqgrf+Z96bcERjt3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okGMgR0smDU/TzlMbHvhHeHlAQim0ll0mwhxDdwLFo6GPPCVFU6cjY8G46ero0KAZ
	 Z1R4COrkvzbsTY8InA++Udm0yMV7yesEumhAaM6iHLQOP3GL2pTa8QWmJtIhQbYjSA
	 uKQga08Enpy2puFsl4qJ/rBbGJSD9M+2OIIQuzlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Jerry Hoemann <jerry.hoemann@hpe.com>,
	Jose Lopez <jose.lopez@hpe.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.12 149/223] drm/ast: Fix ast_dp connection status
Date: Wed, 23 Apr 2025 16:43:41 +0200
Message-ID: <20250423142623.245905709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Jocelyn Falempe <jfalempe@redhat.com>

commit c28f72c6ca98e039c2aa5aac6752c416bc31dbab upstream.

ast_dp_is_connected() used to also check for link training success
to report the DP connector as connected. Without this check, the
physical_status is always connected. So if no monitor is present, it
will fail to read the EDID and set the default resolution to 640x480
instead of 1024x768.

Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: 2281475168d2 ("drm/ast: astdp: Perform link training during atomic_enable")
Reported-by: Jerry Hoemann <jerry.hoemann@hpe.com>
Tested-by: Jose Lopez <jose.lopez@hpe.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250124141142.2434138-1-jfalempe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_dp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/ast/ast_dp.c b/drivers/gpu/drm/ast/ast_dp.c
index 0e282b7b167c..30aad5c0112a 100644
--- a/drivers/gpu/drm/ast/ast_dp.c
+++ b/drivers/gpu/drm/ast/ast_dp.c
@@ -17,6 +17,12 @@ static bool ast_astdp_is_connected(struct ast_device *ast)
 {
 	if (!ast_get_index_reg_mask(ast, AST_IO_VGACRI, 0xDF, AST_IO_VGACRDF_HPD))
 		return false;
+	/*
+	 * HPD might be set even if no monitor is connected, so also check that
+	 * the link training was successful.
+	 */
+	if (!ast_get_index_reg_mask(ast, AST_IO_VGACRI, 0xDC, AST_IO_VGACRDC_LINK_SUCCESS))
+		return false;
 	return true;
 }
 
-- 
2.49.0



