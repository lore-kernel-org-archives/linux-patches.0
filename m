Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787512F39C;
	Tue, 14 May 2024 11:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686743; cv=none; b=jYPz0nl9XA7Hemh7lD1wvq99uhcUL6xVFxHptMog8YXJ9PquV/tTo+Q3g0MVouNQkaXPtDdTVuQeo25v/YG4TuH7GqmRkYKtmZ3XBF9oRYdXDP0KCLZ8MxRWZ0SuKE11WSk7a0lIemPiaNE8yExLTfSLz5n1AR2ksJDZ5ES388o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686743; c=relaxed/simple;
	bh=XSyC8XY6CIy3w5MEmbaE5IQrfS2kRxRE7B47iIpnSoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqoPb1t2m5HBYs8MBaMlhAU8C8EkgxKNRRuD11Nv8MBIAnlzMoFoMkM99/93gf/F9ELwV/McDYkISH5adb7gEJxwFIGQzvOYUB9oijvEhw/do68psk6FQValsJ1qWa1SeU4WGxfatrU9xQ4m2vqVLRFrpB2bTzYUISPssKQnYB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Spgz8WMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Spgz8WMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E86C32782;
	Tue, 14 May 2024 11:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686743;
	bh=XSyC8XY6CIy3w5MEmbaE5IQrfS2kRxRE7B47iIpnSoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Spgz8WMyUTPPN8rUZXlCphb6Zey/VZYXSd/tdZbwkL29Y96sSH3ldfKv1wBtlq7oU
	 hZZeHcFs2KUT3Jy9h1LBZTXE9/ytsv4S4Kmi4sZLY+YSeNOHP02BZRaJZbGpi2Ic/i
	 vLWhoudRT0JKlBwEyec95kdcuvVikd7YlkZfKXow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 223/236] drm/amd/display: Handle Y carry-over in VCP X.Y calculation
Date: Tue, 14 May 2024 12:19:45 +0200
Message-ID: <20240514101028.822793738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

commit 719564737a9ac3d0b49c314450b56cf6f7d71358 upstream.

Theoretically rare corner case where ceil(Y) results in rounding up to
an integer. If this happens, the 1 should be carried over to the X
value.

CC: stable@vger.kernel.org
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_link_encoder.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_link_encoder.c
@@ -393,6 +393,12 @@ void dcn31_hpo_dp_link_enc_set_throttled
 				x),
 			25));
 
+	// If y rounds up to integer, carry it over to x.
+	if (y >> 25) {
+		x += 1;
+		y = 0;
+	}
+
 	switch (stream_encoder_inst) {
 	case 0:
 		REG_SET_2(DP_DPHY_SYM32_VC_RATE_CNTL0, 0,


