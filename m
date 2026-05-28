Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8693016E0;
	Thu, 28 May 2026 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999628; cv=none; b=LfppmkNhtJFo8TF+GPOLZrJSllu5/Ddwj0dHyuvYB6JYbpVc+J4L34cgf+YgHj0rhRvtO8YiCooqVy0KoGEmXpp92VY9vaqZkUe3gCTlEgwcOag8x35F43GCCueLGGEjol7Wo739HQwYYFA1UtByI/axd1riLzXj/1q0Jx+gfGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999628; c=relaxed/simple;
	bh=barw8aBHyiv3cjvG3zk8hkqXTA0qvrOhcQguXtEnHc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiEkuK6EVZWIbDYCOaqRHDvt5kPvS8D5Xal6UdCfTo31ypapUmPxeaa46+bm4DsWEytM8nhNtY+7jIIe+6f2V4ofZg+4J2La/4G1nZ0PTIq9mYbgeuQ90pl3MeRfdKU3P+22HfFypcE7k94Q7SNsPik7TwRMTiXAUCrh6yET/bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmbQvdG/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmbQvdG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187A91F000E9;
	Thu, 28 May 2026 20:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999627;
	bh=rCSsyDOEAJzPkbDb+rAv9ymcgZ3QFeuPmZVbkr7XtLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmbQvdG/AS9XMyiENE2IqsvVuBaWjba5H3JKd09vqF9b89iwq8Kwzw+0TOV+g1Wff
	 G/AYyVH9yPVvDDEfWGKE5eU+/NDlSgMYEMUzPFLfCHACBJkVg00HhVuo+ncgIcOZyJ
	 VrNd+cCCBgrUfJGgAE5nPuA8IJH1SwTQxhs/KVhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 134/377] drm/amd/display: Fix integer overflow in bios_get_image()
Date: Thu, 28 May 2026 21:46:12 +0200
Message-ID: <20260528194642.248309422@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


