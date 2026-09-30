Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89A64D6C3F;
	Wed, 30 Sep 2026 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785533; cv=none; b=GZ91IutLdDOuN4xrXZ2pkhbmRde36M2YHLtL/r+lvxnAE1vco/hWPb5CdJfzbG6QYnBYUUXU1uk1HmNYJccwM+742TOMHTubb0TvirOEBHO0b+r+AoFEY68wZz6deTNy03TDGN4M6dvjRVaBFMZ7JuoQLleVlwWraE5DsAOyjks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785533; c=relaxed/simple;
	bh=rB+2ke2CPvl2d2GpB6q7sagbWeQI4UWATiz33YDOMDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrCMefg3Eh2K3aB5nMGHwCGer3Vl9rc3m6Lod92shz/xBWA3sSstOtgFTCVQ3V+DbMx6A9G2EsJxHJvwivPzJScTKb7j6z1PlLrbYuaEBXJn+CeAp/wslf2KQ5Scq+HDQKfVgVBdZ9HjbYq2eVCcFkvsKq8qlXFT/LQ+9ndmUWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tor0PYKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tor0PYKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85D11F00899;
	Wed, 30 Sep 2026 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785523;
	bh=NLPyBPLuQXMoqh3kd51Mdz+N4ECzQvjaBhN8EsQgarI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tor0PYKe0eWXj2rxb3cVG1IWFQsBCwLBuIDFkZUEoXhFbON8b4vKiM8dPGmrHazbX
	 riNZjbwtWuQ0vmo7opvSfX3KCAk94FhqrVRDU9ssxDBoJ94+cvVQZDzrnrGG/QeZuD
	 HZsIu+pZOXYB3G0J4os3M7uyDqUG7D8101xVkhs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 537/982] media: v4l2-ctrls: validate HEVC tile counts
Date: Wed, 30 Sep 2026 17:21:13 +0200
Message-ID: <20260930152428.305447767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit dc694a9929f7cb9c88ef91e45eb982b7bbe5a477 upstream.

The stateless HEVC decoders read num_tile_columns_minus1 + 1 entries from
column_width_minus1[] and num_tile_rows_minus1 + 1 from row_height_minus1[]
and use them as tile-loop bounds, but std_validate_compound() does not
bound these u8 counts. Reject a V4L2_CTRL_TYPE_HEVC_PPS with tiling
enabled whose tile counts exceed the uAPI array capacity, mirroring the
existing compound-control range checks.

Fixes: 256fa3920874 ("media: v4l: Add definitions for HEVC stateless decoding")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -837,6 +837,18 @@ static int std_validate_compound(const s
 
 			p_hevc_pps->flags &=
 				~V4L2_HEVC_PPS_FLAG_LOOP_FILTER_ACROSS_TILES_ENABLED;
+		} else {
+			/*
+			 * These count the entries the stateless HEVC drivers
+			 * read from column_width_minus1[] / row_height_minus1[]
+			 * and use as tile-loop bounds.
+			 */
+			if (p_hevc_pps->num_tile_columns_minus1 >=
+			    ARRAY_SIZE(p_hevc_pps->column_width_minus1))
+				return -EINVAL;
+			if (p_hevc_pps->num_tile_rows_minus1 >=
+			    ARRAY_SIZE(p_hevc_pps->row_height_minus1))
+				return -EINVAL;
 		}
 
 		if (p_hevc_pps->flags &


