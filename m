Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C08155C0A;
	Tue, 14 May 2024 10:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683988; cv=none; b=T6zj7F9R0XLOiUFjaBFRHaGWUfTYaT9+hKP8Q8DsfAbByPsj7g2gmt5jRnHunjzsX9b1m9QrSdEg07YNIOdmRdZFMqNA8Q10fw+Et97x5vRPwNeE9IrWntyUR8/SlcbpZI+G9J6KhzB9INn3rigEnwWvt05CjrFte/mMx5QcYd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683988; c=relaxed/simple;
	bh=/h1uSR9tuF+sBzE8pczOcq7cIDq7uz3dk6LwvJZGDFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buuNgzO0uo5LsjAD9TO6RfDvMVL4Mb9rs/mXGL0Z/h+Qy/q53IOsTT87K+CnLPTMld7Ggc8cGH/K3Qqw34jC2iSEIvmYiKYT84uqk652dOmmW1MpsbN8Sl5Uf+akG5YCZWassnBY9qxwEyitKOpEaHIJfSCJWdSqzOptg9CbGEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnuMAcMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnuMAcMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5BBC2BD10;
	Tue, 14 May 2024 10:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683988;
	bh=/h1uSR9tuF+sBzE8pczOcq7cIDq7uz3dk6LwvJZGDFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnuMAcMeQpKbaVLiQu0WajR5YEKe2xMkgIS9zeMgti3boEraIdvTnE3Wql8mAt5CR
	 sbcMcfNNlzWPwsA9x33OECPyvOKt7/R9ISYa6c2xGgCNbGhc8h8IYfEakKYPJ1NstJ
	 LJ2gxvFKUiQQ/5mYZNfS4drWUsEi27KSTEHWzuEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 305/336] drm/amd/display: Handle Y carry-over in VCP X.Y calculation
Date: Tue, 14 May 2024 12:18:29 +0200
Message-ID: <20240514101050.134991138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -395,6 +395,12 @@ void dcn31_hpo_dp_link_enc_set_throttled
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


