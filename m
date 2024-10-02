Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDD929CE7;
	Wed,  2 Oct 2024 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876869; cv=none; b=n8b2hHd0yJjN9VfHCt0QLpU4YngvP3024nACnuQdnEKE0PgzDTDHs5TriyX0rNGqMjaTPIrMtwkv6sLIwOj44vj7u7H35kQWqY7U5EXd60fnyH07h9lWMaMNBaZHQY+6Sxye0sDUT70RoBWH/66sQzk33QmdG/g2/8lxaDMkGyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876869; c=relaxed/simple;
	bh=KOwORQO0Iw1cWE4usm/Zsk67254Z2rPIzE9TjvAwvxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX5PnrtV4TVZykyeZArapwtjHtSjM7xId4Asach7IaV7fBLIRLRgzy08iLuvx6BZ0fclmX4RjNBonfSWD344Khu8nIgpUKygTf4/9UXTuq/fZHBnSDt43Qah5anmJkPy1rYNLvYGKckLfGxWYOMOLsRrojUTtpI931/F2IBZ7t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muSqCnsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muSqCnsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAB9C4CEC2;
	Wed,  2 Oct 2024 13:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876869;
	bh=KOwORQO0Iw1cWE4usm/Zsk67254Z2rPIzE9TjvAwvxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muSqCnsljJSK8+r8W4BjNUCwNiNIvtfC4s3fXS0fIK2fkZYUIIwYnyiA0nE2PFLLZ
	 kl3dm10jVFotSBJkZy9bNRO7a1ZmU+fL682qrqkNVkCLBYqhBWl739jD6eO6brMCuZ
	 1p7JwItBFzuiAVZjaWta4OTAKJMQJWEvHvvtYieQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 560/695] drm/amd/display: Fix underflow when setting underscan on DCN401
Date: Wed,  2 Oct 2024 14:59:18 +0200
Message-ID: <20241002125844.855277145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit f510dd5c210bf8cc22e4be48cbbda3cb754219f5 upstream.

[WHY & HOW]
When underscan is set through xrandr, it causes the stream destination
rect to change in a way it becomes complicated to handle the calculations
for subvp. Since this is a corner case, disable subvp when underscan is
set.

Fix the existing check that is supposed to catch this corner case by
adding a check based on the parameters in the stream

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
@@ -859,7 +859,9 @@ static void populate_dml21_plane_config_
 
 	plane->immediate_flip = plane_state->flip_immediate;
 
-	plane->composition.rect_out_height_spans_vactive = plane_state->dst_rect.height >= stream->timing.v_addressable;
+	plane->composition.rect_out_height_spans_vactive =
+		plane_state->dst_rect.height >= stream->timing.v_addressable &&
+		stream->dst.height >= stream->timing.v_addressable;
 }
 
 //TODO : Could be possibly moved to a common helper layer.


