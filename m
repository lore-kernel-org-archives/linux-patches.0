Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3E7568528;
	Wed,  9 Sep 2026 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963076; cv=none; b=ibllyyZ7VxWajfM3uduqm4btBlcG5NcVe7jCcgp/CmNqBi+BTg5jimpj/go9XkwkiP8J/bQH35fBL6f0NKSVy3KB9w0Suxq0GQi1RDUXWEs5a9taiJtKt5Gvfxm93/HE4yeiH3MAgF/l1DZEImFtVsQicQVp2Cb7IptRnFvpn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963076; c=relaxed/simple;
	bh=uBDDC2Kp1aHP0RHpf8xd10ZLegd7jhhBg7gHUGNrlFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIk5j/kys18cADuPdh8UVn0ltjdCHQTA/aty9diwnwGzvzspU76F8OwGAVctWrL/wh5Ffmscgl9ChYfxVz7JOLQOS98Gb93bouksI8NnXWHfx187cbI/5AIXIPn7sol0B20gVJaOs5Bm94VpK6K37WxFaFZhLhal2ok7fbRwJmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6m4jiPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6m4jiPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E429C1F00A3D;
	Wed,  9 Sep 2026 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963075;
	bh=6qZ0DWzey2mB9TSWqcAqZscpBGtpVtMph0KuCZgIksU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6m4jiPJOJRzvIk1g/uK9a7WBkjATOoXpX0xva/EYnn85jlIFOFifxmkXjGPidfPC
	 Mj/u/kMMdUjkTN7JO8iTxb7v6Xr6N56Xnmvo2iH85Pr0c1CsIFfwqVLKOh7eoym/rm
	 e6L1IgvYKtR5P3h6CQW7B7nhR5gs0/AcHuZjhGEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 510/556] drm/amdgpu: Skip accessing psp rum time db for APUs
Date: Wed,  9 Sep 2026 15:43:10 +0200
Message-ID: <20260909134248.394747187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>

commit a26301203a196a991527f7b1ab884d4dd0e7c95e upstream.

Psp runtime DB is for dGPUs only.

Signed-off-by: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dce8195027f146467c9378efb2bb1b0859cb735e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -396,6 +396,12 @@ static bool psp_get_runtime_db_entry(str
 	bool ret = false;
 	int i;
 
+	/*
+	 * Runtime DB is for dGPUs only.
+	 */
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
 	if (amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 6) ||
 	    amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 12) ||
 	    amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(13, 0, 14) ||


