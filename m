Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C4427CB12;
	Wed, 23 Apr 2025 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421301; cv=none; b=WeIBpc9YvPEtP/JGgsIVsQ7mhYD34AJYQSKPgsBdLr9PDQIipetRr0eexERfbRj/uTkNt6iSE/QMUqq+f7/QNimE4qUXRreFksdFGwNr6TvYXGoa8MJtD0Q7khRqsvdOMl9sQKbHxRYXOcG8k9u1pB+AtC5+XjRhiAJz/3WsQdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421301; c=relaxed/simple;
	bh=3RIPUDv0iKGPfWWlGzN4ygKt+lL+ONGy5THcJlWU4Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLfS3XVhJHUvwpIEJwhqcge7l3eEE8AhA3dzD5KepG3ZUN9MdKP0XSHdHBa89dn7YGd7GLgLRn6R5fmXVKo0BajkdeiII3ByjoJpZjwWpUZ7YSMpmEXfYqL9u8k1XY0WJ8/qBSybf8X3Wu/nQvzE9LFtmHwGZM5ZAQsw9DkDmCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVmP/NId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVmP/NId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FCDC4CEE2;
	Wed, 23 Apr 2025 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421301;
	bh=3RIPUDv0iKGPfWWlGzN4ygKt+lL+ONGy5THcJlWU4Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVmP/NId2VJ3Rlgl7ohskcSdFhQqMmnRM/llRnDGFBHRDOAfqE3GaIdd1IHLaiIHC
	 S4tO22lLLncpMXn7kgrzSz70nAK9u1cSFPluiCvrtq/qH91Mvuma9Q9VQN77LeXfs8
	 8IeTYWDT0wPsYBeFWxJ+utpyosXjamEwRvnoExA4=
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
Subject: [PATCH 6.14 173/241] drm/ast: Fix ast_dp connection status
Date: Wed, 23 Apr 2025 16:43:57 +0200
Message-ID: <20250423142627.598204027@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/ast/ast_dp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/ast/ast_dp.c
+++ b/drivers/gpu/drm/ast/ast_dp.c
@@ -17,6 +17,12 @@ static bool ast_astdp_is_connected(struc
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
 


