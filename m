Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9182C35958;
	Mon, 23 Mar 2026 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282839; cv=none; b=rOjEh8Zs61o3YJGMzMrdOrLmanz8i/nWkM/eiHo+EN9E+04NisoaZCzV/iepH8Hb84SPsY4M83q0jQzFjdcIHONIP6GoOrepiTjK5CB2iPPvooU5Yayzo3aoyizz0FagcUh2c+kyRH0HfYam/ORshdb6H2lmcBF2/HoxdMyh+p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282839; c=relaxed/simple;
	bh=aq8qw3HHZhPtJwYqPc4bE/K903yfHcAOxZhGNfxBsxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO5vUJd8BDYvYX/kz69kj/Fr5jfYNd6xZ/yrExxlwSmi5MZygo8VSs8YWInCa5+HFOuD+0CYpYMUh/Y75eZjYZqRZ1hfBE/5jW5+uuNiXVs2Ens5oocAL/ZUv0RjOYuLyuhASReYFaTXYV6LTsJHG10wMaRPiikX3K097ioW5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8CMugCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8CMugCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B43AC4CEF7;
	Mon, 23 Mar 2026 16:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282839;
	bh=aq8qw3HHZhPtJwYqPc4bE/K903yfHcAOxZhGNfxBsxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8CMugCl2OVD6rKPQVAru6O87rVtaNvALV7SQ0IbB3s2VaeHINOeCo3OOGRtgCmMQ
	 cdbNil0IJGTeINGJACkDilFbT9IlqDeIZcsgbhd5G6jnAQUkiptVSLKoESF5OKx6fY
	 qctGuzqbHwQylCre2ZkyJgXm7JPClP/1bWdURdmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 305/481] drm/amdgpu/mmhub3.0.1: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:44:47 +0100
Message-ID: <20260323134532.543519840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


