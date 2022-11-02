Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDA97E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9293C433C1;
	Wed,  2 Nov 2022 02:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356975;
	bh=bJYMRcVIEi1FpU1D+tJm6qSZsCPP7yT7x1c4wKmEBTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1yBzYE7vPVbpdnAjaG5oeo6IsRlAVGSbcG2L3icKw4xShsD7mv3r0DpZis/VZhGZ
	 2hOqH2GF1sX6toLr/iv/2bXywLKTbd4yNBr6kgxzNpzVV5qvFM5HSGXLSIK4HZCLzt
	 bvtdI70O7VTKz8RmNRbNS+tmZ7LIFELeau4kCRFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 065/240] drm/amdkfd: update gfx1037 Lx cache setting
Date: Wed,  2 Nov 2022 03:30:40 +0100
Message-Id: <20221102022112.872580320@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

commit 9656db1b933caf6ffaaef10322093fe018359090 upstream.

Update the gfx1037 L1/L2 cache setting.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |   53 +++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -795,6 +795,54 @@ static struct kfd_gpu_cache_info yellow_
 	},
 };
 
+static struct kfd_gpu_cache_info gfx1037_cache_info[] = {
+	{
+		/* TCP L1 Cache per CU */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 1,
+	},
+	{
+		/* Scalar L1 Instruction Cache per SQC */
+		.cache_size = 32,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_INST_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* Scalar L1 Data Cache per SQC */
+		.cache_size = 16,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* GL1 Data Cache per SA */
+		.cache_size = 128,
+		.cache_level = 1,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+	{
+		/* L2 Data Cache per GPU (Total Tex Cache) */
+		.cache_size = 256,
+		.cache_level = 2,
+		.flags = (CRAT_CACHE_FLAGS_ENABLED |
+				CRAT_CACHE_FLAGS_DATA_CACHE |
+				CRAT_CACHE_FLAGS_SIMD_CACHE),
+		.num_cu_shared = 2,
+	},
+};
+
 static void kfd_populated_cu_info_cpu(struct kfd_topology_device *dev,
 		struct crat_subtype_computeunit *cu)
 {
@@ -1515,10 +1563,13 @@ static int kfd_fill_gpu_cache_info(struc
 			break;
 		case IP_VERSION(10, 3, 3):
 		case IP_VERSION(10, 3, 6): /* TODO: Double check these on production silicon */
-		case IP_VERSION(10, 3, 7): /* TODO: Double check these on production silicon */
 			pcache_info = yellow_carp_cache_info;
 			num_of_cache_types = ARRAY_SIZE(yellow_carp_cache_info);
 			break;
+		case IP_VERSION(10, 3, 7):
+			pcache_info = gfx1037_cache_info;
+			num_of_cache_types = ARRAY_SIZE(gfx1037_cache_info);
+			break;
 		case IP_VERSION(11, 0, 0):
 		case IP_VERSION(11, 0, 1):
 		case IP_VERSION(11, 0, 2):


