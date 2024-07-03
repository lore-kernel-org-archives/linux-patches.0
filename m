Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB4717BB03;
	Wed,  3 Jul 2024 10:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003345; cv=none; b=PB+9MjZH4sRvBsZFN8WB2OtaEdiNmacaj6g3LzI6TAxe65gvxtYjmkzZWp1eSKRNWn/KHQ9Hwjz6VGyCz2uOcNMhgyJ6ZLWQxOT1IiJsanxXV4RKf33YsGoYl/tdALCszIEKiM2aYG8VFeks+W6I0yncP2M1jmudwwUhobKZuXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003345; c=relaxed/simple;
	bh=qif630qFhRR6oW4reg6zKKg2SVHFZa2qbPGXRkXLigE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azr5IQrehqNOnAEtx+eXw+SEivQNyMH1TchoGBRSMMNoLWwg0bFDcEcMNQWp8J2e98TS/00w5ghhPKkoDA0XVpR0cPm3O+OvXJPFuud7Ccpq9kj/+ruXNnn38asPjLSwkcP2/KErdnM9Dum3VbQMowNYa85fyBNiSlobwlesAXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBWhLqn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBWhLqn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4301CC32781;
	Wed,  3 Jul 2024 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003343;
	bh=qif630qFhRR6oW4reg6zKKg2SVHFZa2qbPGXRkXLigE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBWhLqn7CiG10++8xe88HWPGUD6VPRUiqS26iGSR6amIfddPXFxk+mpqexXogm/ZC
	 /1mmR4rcQL+7t81j6282KrE+yykvVOQLEAMegYutkiHkIjY2ccfvulVtKwQIU+1k9N
	 qTENEe5DSi3jBQ9fzRF6/D1x8KNrSq8jOJiNLKF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Anson Jacob <Anson.Jacob@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/139] drm/amd/display: Handle Y carry-over in VCP X.Y calculation
Date: Wed,  3 Jul 2024 12:38:35 +0200
Message-ID: <20240703102831.128144050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

[ Upstream commit 3626a6aebe62ce7067cdc460c0c644e9445386bb ]

[Why/How]
Theoretically rare corner case where ceil(Y) results in rounding
up to an integer. If this happens, the 1 should be carried over to
the X value.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
index 6f9078f3c4d39..17bcf7ce4099c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -620,6 +620,12 @@ void enc1_stream_encoder_set_mst_bandwidth(
 				x),
 			26));
 
+	// If y rounds up to integer, carry it over to x.
+	if (y >> 26) {
+		x += 1;
+		y = 0;
+	}
+
 	REG_SET_2(DP_MSE_RATE_CNTL, 0,
 		DP_MSE_RATE_X, x,
 		DP_MSE_RATE_Y, y);
-- 
2.43.0



