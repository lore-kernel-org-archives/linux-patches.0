Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA07817B40F;
	Wed,  3 Jul 2024 10:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003818; cv=none; b=DX9wx9/RWrTuklmCXRLcK1jpaNexkaCmNNYff1R7hFipRH5T7dYt1KpEjA3Ow95V5yjtmx5DfhVcK2feevJABWpxOU6CF2hv31wMPQ6iIuQppEK4ZLUWD7rL41NLCisiPhpHFNuJjdaDSo8+jn7WZlBQY4359lLeKYqTq1Kpps4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003818; c=relaxed/simple;
	bh=5NnMyu5rGT7Nq5mQuKN2waB9Kg6Ki5svWqtcOBmVGtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY2FKIFLlG7Wu73lSufVEByx8oRkaVppOucsdNRJZpwSvTH5jEH8L3xVuhf/XhQJyKSgg1+VWEajuUvWt2LdtFhdC3bf+WoloHvWuaQ0vU4Cze4PhB7RxScJx77RyoXct92QeS6Me6vICil2g/wnsYGfOjxqeLMsP+lrJ7b90wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLULGiv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLULGiv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B03C2BD10;
	Wed,  3 Jul 2024 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003818;
	bh=5NnMyu5rGT7Nq5mQuKN2waB9Kg6Ki5svWqtcOBmVGtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLULGiv6y+FAEw976P84X4ldqt908d2NFvlYtmk44OOuwO4XENR8hxm0gdYflK/sp
	 d9OP6jEJdNrA+RDvO5vF1DR9MJ+lzMRdWRDSZXVu29FmXK5EGnJQlNnR4Cfrmh/vo/
	 nLkEhFekSUt2DNExx9W6I7h2R1lIpVeO++uf5q0E=
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
Subject: [PATCH 5.4 031/189] drm/amd/display: Handle Y carry-over in VCP X.Y calculation
Date: Wed,  3 Jul 2024 12:38:12 +0200
Message-ID: <20240703102842.681998198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6718777c826dc..5d2013f1c0729 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -635,6 +635,12 @@ void enc1_stream_encoder_set_mst_bandwidth(
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



