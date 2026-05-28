Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54BD197A7D;
	Thu, 28 May 2026 20:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000648; cv=none; b=GC3gSQ9ks2UZOSFUr4pS3FMS5iwZuqJYy7Js+aIYlz3PCMBYlJOdfXIS40WWxqoWZTs+Dmmj8JKCyJWm8+3Le9gEUPteoJ71tTYla4iNnsLEY8hGbTJi0T77zYkmY8ssTnlI4FuVknSqG8Sj2NevSTUM+pZ9gSmNUJJFxGMVpDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000648; c=relaxed/simple;
	bh=CKnHlWJ7lnubyQpUyU96jn/dHRt0Po07uCm2y1K3KFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW9GPkXuGIT2nDZvnTZObC3rp7xzwmUsBaWxGcd92Yd2BvjL4uzRiOm6UWiG7MrG0KWHS94izxFk33BcDt4Ekv9iu3pyZlSfUbKzpQq9KdW3KdncPIAT6ozv3SIyGMWOeoy253xq+6KU8GOHvl6duZWU1VdrI4675Pgx+DRP7wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0x2VqT1n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0x2VqT1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0771F000E9;
	Thu, 28 May 2026 20:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000647;
	bh=xkOJPPrLObyWvUzx7NIsekP0fV5kxwMiApeSOKirb64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0x2VqT1nTDGrWs5ircwIdtMitUD1BuQbRjUKlEzFwCPT/Mo9o1glxtqVeND8+xUfb
	 Yt+aaBUBBTYuU2b+X8epYhgqr8NAjnzVpIR+bJJdsQcq6u/J5DIr5yfBqc/4gdC1oC
	 6Z+UXxMD9gKogjB3Op5kr0HlDHpQR89gd13rZjjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 118/272] drm/amd/display: Fix integer overflow in bios_get_image()
Date: Thu, 28 May 2026 21:48:12 +0200
Message-ID: <20260528194632.684723570@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit cd86529ec61474a38c3837fb7823790a7c3f8cce upstream.

[Why&How]
The bounds check in bios_get_image() computes 'offset + size' using
unsigned 32-bit arithmetic before comparing against bios_size. If a
VBIOS image contains a near-UINT32_MAX offset the addition wraps to a
small value, the comparison passes, and the function returns a wild
pointer past the VBIOS mapping.

Additionally, the comparison uses '<' (strict), which incorrectly
rejects the valid exact-fit case where offset + size == bios_size.

Fix both issues by restructuring the check to avoid the addition
entirely: first reject if offset alone exceeds bios_size, then check
size against the remaining space (bios_size - offset). This eliminates
the overflow and correctly permits exact-fit accesses.

Assisted-by: GitHub Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d40fb392af659c4a02b560319f226842f6ec1a95)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.c
@@ -37,10 +37,13 @@ uint8_t *bios_get_image(struct dc_bios *
 	uint32_t offset,
 	uint32_t size)
 {
-	if (bp->bios && offset + size < bp->bios_size)
-		return bp->bios + offset;
-	else
+	if (!bp->bios)
 		return NULL;
+
+	if (offset > bp->bios_size || size > bp->bios_size - offset)
+		return NULL;
+
+	return bp->bios + offset;
 }
 
 #include "reg_helper.h"


