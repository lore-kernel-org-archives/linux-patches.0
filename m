Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D0B23B612;
	Mon, 23 Mar 2026 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277191; cv=none; b=cBrbeNlmTHP3Mbq7tMMo88MqISZu8MfqYkam6Pmm69jPmyc0nZR+8IUbeE3/BivljWEA6U1WwDPoru9gYDdzuZNEeHMsL2vB7hSd+5v0uxl/m3sWz8OC5lK2xDqu1DYdhyUGDt6JPJJw310my6/1vpTAa09QmGLp3P6eRU6hocs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277191; c=relaxed/simple;
	bh=JRqVlB3oJ8Ij8mhaIh6JA9BrQEada/LSxrPLNYT/UiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV5lq/W6pZ8uBsPwVB4nYDi2WCVTrAbwEppvmEbSNT0dZ8oUfk0lSL4t2epIaNczag9iYK7pnGtVH/ukmsHI3MeVLooKrwWPygx3Zo+bHEl9IcTxYsK2BrtI3TQBSUMlQoz5GQCtFZUq2Sjh3FniL0ZA0DNDzfptabth+7QqQ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s17mvpk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s17mvpk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F7BC4CEF7;
	Mon, 23 Mar 2026 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277190;
	bh=JRqVlB3oJ8Ij8mhaIh6JA9BrQEada/LSxrPLNYT/UiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s17mvpk3YCf+It/6lLmIT1k1HWkuSMlXXbceB8w/rkem/ivyFaHgybLerbvGIv409
	 Sjx9WoWRo6nwXDhn0XH/EbTU2VIrTxg2ARlFx9wvSrpNUvgB4vWBACVVmgHpRf4xzC
	 L1rsurWxM+ZbhZ4xjehgdqg9vGwkw6ACjbcWI5ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 351/460] drm/amdgpu/gmc9.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:45:47 +0100
Message-ID: <20260323134535.177955066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit f39e1270277f4b06db0b2c6ec9405b6dd766fb13 upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Cc: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e14d468304832bcc4a082d95849bc0a41b18ddea)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -688,28 +688,35 @@ static int gmc_v9_0_process_interrupt(st
 	} else {
 		switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 		case IP_VERSION(9, 0, 0):
-			mmhub_cid = mmhub_client_ids_vega10[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vega10) ?
+				mmhub_client_ids_vega10[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 3, 0):
-			mmhub_cid = mmhub_client_ids_vega12[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vega12) ?
+				mmhub_client_ids_vega12[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 4, 0):
-			mmhub_cid = mmhub_client_ids_vega20[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vega20) ?
+				mmhub_client_ids_vega20[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 4, 1):
-			mmhub_cid = mmhub_client_ids_arcturus[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_arcturus) ?
+				mmhub_client_ids_arcturus[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 1, 0):
 		case IP_VERSION(9, 2, 0):
-			mmhub_cid = mmhub_client_ids_raven[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_raven) ?
+				mmhub_client_ids_raven[cid][rw] : NULL;
 			break;
 		case IP_VERSION(1, 5, 0):
 		case IP_VERSION(2, 4, 0):
-			mmhub_cid = mmhub_client_ids_renoir[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_renoir) ?
+				mmhub_client_ids_renoir[cid][rw] : NULL;
 			break;
 		case IP_VERSION(1, 8, 0):
 		case IP_VERSION(9, 4, 2):
-			mmhub_cid = mmhub_client_ids_aldebaran[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_aldebaran) ?
+				mmhub_client_ids_aldebaran[cid][rw] : NULL;
 			break;
 		default:
 			mmhub_cid = NULL;


