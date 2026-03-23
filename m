Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F583BA223;
	Mon, 23 Mar 2026 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279109; cv=none; b=YXulkkvldYdjlQTeyhuAq9LQbPaKioCnPaGWXITT4ipQriwqokO1+eO2HFbh/43OWjlzuoauw4ykgEnWydks/KUhcjcMIIQOkp2W4ARe8a/wNi2R6YbR+SksoT2Z+F202uzo26arJIF34rm9SWvi5UztjpSjQRXoEo6JYbvb2sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279109; c=relaxed/simple;
	bh=H4Wy/8nylbAqyt2QuBTYWKLIS9F/4mut/EBGsKpiA1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFoqtQFW+aU3H6jZkNRMAmXh/9SNKoOrN6/vDuQxH5kqWvChb9+QqmMhisNIdZQ3ndMK5mbx4772HIAd9yDVNw0xnwHJlzD2M8jdV4Zja84tV9bnuXw+kJOzyGVkA1pIwR9CVCxHdOk0A2UjNF5EZJurSPwwadkdnBH2lMVyLG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLmBMvop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLmBMvop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3438EC4CEF7;
	Mon, 23 Mar 2026 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279109;
	bh=H4Wy/8nylbAqyt2QuBTYWKLIS9F/4mut/EBGsKpiA1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLmBMvopTjIaJr22CuQRRBmQxlzdiFtvNNDq+Rg3FBQFexhpW3z4vrZzV5C6p1yo6
	 Q82HfF0iewvRj1M3LT6FgNihclLxlaQeLX3wvNFD0vstWeyXzqM47RkhYC/zo6p4nC
	 LSAVE5+f7akBgfZhQRhBQu6nGI6PpfJwgnIBIR6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 490/567] drm/amdgpu/mmhub3.0.1: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:46:50 +0100
Message-ID: <20260323134546.106058263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5d4e88bcfef29569a1db224ef15e28c603666c6d upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5f76083183363c4528a4aaa593f5d38c28fe7d7b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -117,7 +117,8 @@ mmhub_v3_0_1_print_l2_protection_fault_s
 
 	switch (adev->ip_versions[MMHUB_HWIP][0]) {
 	case IP_VERSION(3, 0, 1):
-		mmhub_cid = mmhub_client_ids_v3_0_1[cid][rw];
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v3_0_1) ?
+			mmhub_client_ids_v3_0_1[cid][rw] : NULL;
 		break;
 	default:
 		mmhub_cid = NULL;


