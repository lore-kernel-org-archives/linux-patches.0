Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767BB7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F01EC433C1;
	Wed,  2 Nov 2022 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356999;
	bh=18izH+nAButBghnQwFux71qhr/dINukLrRwTHGai6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPnwjYrh/3cH2n4uIgyCY2eSTitO8MGHOg4mYCtSjF/aR2Ze115B/sU0wVowIWLS1
	 kYWi1+9biurygCcVYcTr12osg4fE4z/7HkXHP+At4EE0xJ7QgrxnmCo2dt5171mztw
	 CMuhb15rjPAwmsQ5B51cN1PfvKudnAgfRGj2Ogog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.0 059/240] drm/amdgpu: Fix for BO move issue
Date: Wed,  2 Nov 2022 03:30:34 +0100
Message-Id: <20221102022112.733681826@linuxfoundation.org>
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

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 8273b4048664fff356fd10059033f0e2f5a422a1 upstream.

A user reported a bug on CAPE VERDE system where uvd_v3_1
IP component failed to initialize as there is an issue with
BO move code from one memory to other.

In function amdgpu_mem_visible() called by amdgpu_bo_move(),
when there are no blocks to compare or if we have a single
block then break the loop.

Fixes: 312b4dc11d4f ("drm/amdgpu: Fix VRAM BO swap issue")
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -439,6 +439,9 @@ static bool amdgpu_mem_visible(struct am
 	while (cursor.remaining) {
 		amdgpu_res_next(&cursor, cursor.size);
 
+		if (!cursor.remaining)
+			break;
+
 		/* ttm_resource_ioremap only supports contiguous memory */
 		if (end != cursor.start)
 			return false;


