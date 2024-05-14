Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E4148CF2;
	Tue, 14 May 2024 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685913; cv=none; b=eqaZEl5B3GuOKJK1YqLUuBTbm9YJsOp1iJj2Zgwus6fowVkjAcBnLis0KyGWhyP9tmIR5s60AfgbQLBkEkZ5kHJKFz7ieCLqGTvis3SboS4yy8ZDk2l0lEV3q1lPxILj3CBqKm7sSDwUbhqOP2GpwabCBbLBr5Swlt7om7pDTd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685913; c=relaxed/simple;
	bh=a5X2pFiA9qy4MgMFi3qYtmE3kkChc+g3NEopq/uzKhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTzWjjFUW21KIuZ7HIaH/6sYo+7/pvYG9MqoqZx8j2u0C0iUKFGOVuEJnuT5VVeCt/k2a4S9bYSsaByi1iIXlCsBlxVW1dwIxlF+V0SqoJZlK2oYETOw9Hvjh+K/+PPeUL5He6ZifPV4iFX5a7Wc2RYoXgzRNlFkkGcNvSE5DN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxHMrOv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxHMrOv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175A1C2BD10;
	Tue, 14 May 2024 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685912;
	bh=a5X2pFiA9qy4MgMFi3qYtmE3kkChc+g3NEopq/uzKhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxHMrOv0w6ciDaexZuhW/Wh4OVOtL2HD6nVYZXg2+PMS8HAZvwE41ElljLNsnNBhd
	 PC+Urt3mOBdVNW9we+TFXg50kaHW+4jrUjfe1Qu/pp0RDeH5SqchRU+Bnfmgolv4F6
	 TGpiQAxmVLmJFqTs33E4J9EpV24FKv9pr5ffSI+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 275/301] drm/amd/display: Handle Y carry-over in VCP X.Y calculation
Date: Tue, 14 May 2024 12:19:06 +0200
Message-ID: <20240514101042.649986808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


