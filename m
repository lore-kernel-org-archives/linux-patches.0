Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEF03328F0;
	Fri, 17 Oct 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715372; cv=none; b=fhNR5n5KqKi2oOIfZxc9/R8UvTwwA7TdV228febRtp7mNSuv0AyLTb3dGXBDj5aCb8JuQlfm81e6kwp/Hj8BkXljN3NRbRS47eicMXCGLoxD4QKTXIeMADLXgW3JjlE/29jR3IBg/FDHSp3bobbnFveTvGGjmweZQbsBroC/vpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715372; c=relaxed/simple;
	bh=y4dOuRgiw6EspPPv30LeKmo4mexoTtVibp0wcV+MNZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1fBmKiQAVfjnQwIlWqLFUBdtTD8sk0WgcbPdD0GknwNmMZzcMGs0S9kh7xfACPZYeF4zoqvHuchStC+9oqcUl7W4Zaih+XHgi50pJ0tcGAreK0lObQCXhCQCHkZ4e0f3/dqSZ1S5A0U97UOIToDQI4511X8I3B+k+GlT43Xsos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjFEKz6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjFEKz6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D46C19423;
	Fri, 17 Oct 2025 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715372;
	bh=y4dOuRgiw6EspPPv30LeKmo4mexoTtVibp0wcV+MNZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjFEKz6wrOtVrUvqvuTeQDCKosh1iS6MnqelAtXm7hsFeFR7/5EVOIqC64mlc5/GM
	 i9gDPSir7lC7WWt0Jh9rE9Rvcv5vjIp9G7MKk4peN4iLeW/3dvYZ0C7k67vl28fLMt
	 QMnD8mE9i1GU5qIzLYlp/wL5/8HcXyWt34PcvPAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Samson Tam <samson.tam@amd.com>,
	Jesse Agate <jesse.agate@amd.com>,
	Brendan Leder <breleder@amd.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.17 192/371] drm/amd/display: Incorrect Mirror Cositing
Date: Fri, 17 Oct 2025 16:52:47 +0200
Message-ID: <20251017145208.873368228@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Agate <jesse.agate@amd.com>

commit d07e142641417e67f3bfc9d8ba3da8a69c39cfcd upstream.

[WHY]
hinit/vinit are incorrect in the case of mirroring.

[HOW]
Cositing sign must be flipped when image is mirrored in the vertical
or horizontal direction.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Samson Tam <samson.tam@amd.com>
Signed-off-by: Jesse Agate <jesse.agate@amd.com>
Signed-off-by: Brendan Leder <breleder@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c
+++ b/drivers/gpu/drm/amd/display/dc/sspl/dc_spl.c
@@ -641,16 +641,16 @@ static void spl_calculate_inits_and_view
 		/* this gives the direction of the cositing (negative will move
 		 * left, right otherwise)
 		 */
-		int sign = 1;
+		int h_sign = flip_horz_scan_dir ? -1 : 1;
+		int v_sign = flip_vert_scan_dir ? -1 : 1;
 
 		switch (spl_in->basic_in.cositing) {
-
 		case CHROMA_COSITING_TOPLEFT:
-			init_adj_h = spl_fixpt_from_fraction(sign, 4);
-			init_adj_v = spl_fixpt_from_fraction(sign, 4);
+			init_adj_h = spl_fixpt_from_fraction(h_sign, 4);
+			init_adj_v = spl_fixpt_from_fraction(v_sign, 4);
 			break;
 		case CHROMA_COSITING_LEFT:
-			init_adj_h = spl_fixpt_from_fraction(sign, 4);
+			init_adj_h = spl_fixpt_from_fraction(h_sign, 4);
 			init_adj_v = spl_fixpt_zero;
 			break;
 		case CHROMA_COSITING_NONE:


