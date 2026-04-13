Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025F31D5AD4;
	Mon, 13 Apr 2026 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098249; cv=none; b=ecTWz3CSqjDiIi1C0gKwUk5frx4QZV9zq0ejU9Sv6IKndfKROVwsdPvsqxhSvwixtILRxa5h1g5+4l96mJTkTharqKRdLOgHEO2HOptxvUNx7mKMJ+n722UW1aJfn3QSWG6N4u4Gd1NLx+0aHqzZ6H24Phwsyw86+0XQn8NEziU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098249; c=relaxed/simple;
	bh=iVDI3EYf2tOI4N0ZjVkLYYo81npbg3DVjyUP3fvcrc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1WXOxO3QMRS6ZjEEH23h9dl5wEr42TNKFy4EGI5gwqJNn3uU8AAoTI7vfXtai1wCyK4HH4/365vJv2itEtkdKXnEe5GgQ9oIiY2IuvbfeLi5+hqzpP6uCnK3Vsaw8qEOBwyuibmqNdB3B64qMI2090C0XnBPutylqGXK07NFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUFbQcEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUFbQcEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDD1C2BCAF;
	Mon, 13 Apr 2026 16:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098248;
	bh=iVDI3EYf2tOI4N0ZjVkLYYo81npbg3DVjyUP3fvcrc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUFbQcErt9ACMa78K/4AB4RKt4MRLj1Oyv8sN/oqQsPBV8o8V4rpmMrpbvyNwaTd5
	 4amVDUD9F5OixIJW4H02/2Z38GSw/PjK5VgiXs61iRkTLTMG9ev/bJQJykIPnR8chA
	 c+v6LTXHPj8nmYpXYUK6Qs1uhd8P+7mt2TEMZk/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 5.15 452/570] drm/ast: dp501: Fix initialization of SCU2C
Date: Mon, 13 Apr 2026 17:59:43 +0200
Message-ID: <20260413155847.400246943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -484,7 +484,7 @@ static void ast_init_analog(struct drm_d
 	/* Finally, clear bits [17:16] of SCU2c */
 	data = ast_read32(ast, 0x1202c);
 	data &= 0xfffcffff;
-	ast_write32(ast, 0, data);
+	ast_write32(ast, 0x1202c, data);
 
 	/* Disable DVO */
 	ast_set_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xa3, 0xcf, 0x00);


