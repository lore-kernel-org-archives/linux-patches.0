Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A767E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3712C433D6;
	Wed,  2 Nov 2022 02:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356981;
	bh=vOADN8TIzPBX+Tv/z9PD54lqd7bGS3Kx1410/BQfeFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plebi2CbZxT6SOYEFo6F9Fhajdblkx9yrXfmPmac3NMo0RholJZ9ChZ25LXaLL2iO
	 sRuQIm3TELtkxvFI2fA2QFIHoTgrAOW/9BHGNUulzsQCEwNkzUEmI/98JtaUZgSM2b
	 8u+GxAKfy8jZP7MpADkltBHXn5CLCy/pbLPBq0to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>
Subject: [PATCH 6.0 066/240] drm/amdkfd: correct the cache info for gfx1036
Date: Wed,  2 Nov 2022 03:30:41 +0100
Message-Id: <20221102022112.894566931@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jesse Zhang <jesse.zhang@amd.com>

commit 969758bbf5e9360b63bbb2328ac3fda46bbbc9f5 upstream.

correct the cache information for gfx1036

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |   53 +++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -843,6 +843,54 @@ static struct kfd_gpu_cache_info gfx1037
 	},
 };
 
+static struct kfd_gpu_cache_info gc_10_3_6_cache_info[] = {
+	{
+		/* TCP L1 Cache per CU */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+			  CRAT_CACHE_FLAGS_DATA_CACHE |
+			  CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 1,
+	},
+	{
+		/* Scalar L1 Instruction Cache per SQC */
+		.cache_size = 32,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+			  CRAT_CACHE_FLAGS_INST_CACHE |
+			  CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* Scalar L1 Data Cache per SQC */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+			  CRAT_CACHE_FLAGS_DATA_CACHE |
+			  CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* GL1 Data Cache per SA */
+		.cache_size = 128,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+			  CRAT_CACHE_FLAGS_DATA_CACHE |
+			  CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* L2 Data Cache per GPU (Total Tex Cache) */
+		.cache_size = 256,
+		.cache_level = 2,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+			  CRAT_CACHE_FLAGS_DATA_CACHE |
+			  CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+};
+
 static void kfd_populated_cu_info_cpu(struct kfd_topology_device *dev,
 		struct crat_subtype_computeunit *cu)
 {
@@ -1562,10 +1610,13 @@ static int kfd_fill_gpu_cache_info(struc
 			num_of_cache_types = ARRAY_SIZE(beige_goby_cache_info);
 			break;
 		case IP_VERSION(10, 3, 3):
-		case IP_VERSION(10, 3, 6): /* TODO: Double check these on production silicon */
 			pcache_info = yellow_carp_cache_info;
 			num_of_cache_types = ARRAY_SIZE(yellow_carp_cache_info);
 			break;
+		case IP_VERSION(10, 3, 6):
+			pcache_info = gc_10_3_6_cache_info;
+			num_of_cache_types = ARRAY_SIZE(gc_10_3_6_cache_info);
+			break;
 		case IP_VERSION(10, 3, 7):
 			pcache_info = gfx1037_cache_info;
 			num_of_cache_types = ARRAY_SIZE(gfx1037_cache_info);


