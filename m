Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A216F3859FE;
	Wed,  8 Apr 2026 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672154; cv=none; b=AB40RxCTtBt5P8sAhnduvqM9jmzMxBXjdR/2pfHHwbX4eik2fkR9aewUZtZmDM+8Y9+gfGywfrgEH5grtxjgSEvIy8YECAItpFgsHI8zquzFVRMQUGpYKRyzsA/ENXxFtnBkF2nlP9X82V0giK5TJUD7dFOYwd/RGsHYmKOPu1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672154; c=relaxed/simple;
	bh=E8VZkQcf8+2+RHXM9acIXX6++BywUUXX7ha1To94IGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdPmT8iV5zw4UYIvjsnp548FRTIZ/HzmU0jDEw+qFBT/FvK9DE3fprS35hkSOHNwKqCobP3zPIpyPiBU+RaZ7KNR0gynRfGWVpOTrao7XufMib+51670FTecUmZgpGF6UFrB1Wz+GPlLifo2PiGhtFZeSSRyEdycvyuApF0q2kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xMQujKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xMQujKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39390C19421;
	Wed,  8 Apr 2026 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672154;
	bh=E8VZkQcf8+2+RHXM9acIXX6++BywUUXX7ha1To94IGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xMQujKjdzQ/onbKeFssqexCxfHVroNi9DsJI5NOJdnFg/YMWLPjKH5MwuPERQV2Q
	 DVxx6GNEbhIE8W9q2p9YNRO9VXAewRvCb/HWJi34vPkFfFUYYzUZbOT6H9bBYIQViW
	 GQOW2cmCRcxJ2YRnLw0LjqXZ3JCGvniX6Pbcl+nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.1 210/312] drm/ast: dp501: Fix initialization of SCU2C
Date: Wed,  8 Apr 2026 20:02:07 +0200
Message-ID: <20260408175941.603231218@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 2f42c1a6161646cbd29b443459fd635d29eda634 upstream.

Ast's DP501 initialization reads the register SCU2C at offset 0x1202c
and tries to set it to source data from VGA. But writes the update to
offset 0x0, with unknown results. Write the result to SCU instead.

The bug only happens in ast_init_analog(). There's similar code in
ast_init_dvo(), which works correctly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 83c6620bae3f ("drm/ast: initial DP501 support (v0.2)")
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v3.16+
Link: https://patch.msgid.link/20260327133532.79696-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ast/ast_dp501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ast/ast_dp501.c
+++ b/drivers/gpu/drm/ast/ast_dp501.c
@@ -426,7 +426,7 @@ static void ast_init_analog(struct drm_d
 	/* Finally, clear bits [17:16] of SCU2c */
 	data = ast_read32(ast, 0x1202c);
 	data &= 0xfffcffff;
-	ast_write32(ast, 0, data);
+	ast_write32(ast, 0x1202c, data);
 
 	/* Disable DVO */
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xa3, 0xcf, 0x00);


