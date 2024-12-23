Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548F1B414B;
	Mon, 23 Dec 2024 16:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970837; cv=none; b=lWbvcd+8x5+qZgjL+YrHwHbHqzwRIc0VDFPPYqC+KohBoCrGBCCb3KKXHWAlLW5DcKLHmtQjWrgFn0+4PH7z0hkMlg9cGcbr7us5Zw96N8XQLccuvUFQQewmg7MFeex3vvH1H5WLJS/12rcBJqQ0/zn4w1yVVcufUhgQ4MYNidU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970837; c=relaxed/simple;
	bh=+eb0ktDtglSjnsemqXuH4MJowr+I5LkbEretDwqoLRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VIgLeRE3S1l85CbELJzBTu3EzUULcI6pDq0zWPB/IGlPZPNT0wC0XpIcFFIMKX4KLdNnbTLc8hlQUAdeD5PJTS+jzdQ0uusroOp+9Bf3rxoFRyhFZNxySqyHFAz1m1E4VrD8n1UGWBxJMaCruLp8Q1E0vsa9AWwbzGoEmIF8zWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwTC0pVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwTC0pVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B4EC4CEDF;
	Mon, 23 Dec 2024 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970837;
	bh=+eb0ktDtglSjnsemqXuH4MJowr+I5LkbEretDwqoLRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwTC0pVCEVd3VxcYfDYUhWQSJWhSxe4+L5bcCvdvmAD3FDGAOvstbngPPX+A0/yPi
	 qP5RpVJsG8Pz2OGV6q1ZCl3RfPcXCgbYnapIYKMCjDsgu/p6SrBcREo6oyJ6U8W/h9
	 UxVUiSnqKVpAQ+5s3pn136oNPcXd+c/ryZ2wF5wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 83/83] drm/amdgpu: Handle NULL bo->tbo.resource (again) in amdgpu_vm_bo_update
Date: Mon, 23 Dec 2024 17:00:02 +0100
Message-ID: <20241223155356.859496662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

commit 85230ee36d88e7a09fb062d43203035659dd10a5 upstream.

Third time's the charm, I hope?

Fixes: d3116756a710 ("drm/ttm: rename bo->mem and make it a pointer")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3837
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 695c2c745e5dff201b75da8a1d237ce403600d04)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1060,10 +1060,9 @@ int amdgpu_vm_bo_update(struct amdgpu_de
 	 * next command submission.
 	 */
 	if (bo && bo->tbo.base.resv == vm->root.bo->tbo.base.resv) {
-		uint32_t mem_type = bo->tbo.resource->mem_type;
-
-		if (!(bo->preferred_domains &
-		      amdgpu_mem_type_to_domain(mem_type)))
+		if (bo->tbo.resource &&
+		    !(bo->preferred_domains &
+		      amdgpu_mem_type_to_domain(bo->tbo.resource->mem_type)))
 			amdgpu_vm_bo_evicted(&bo_va->base);
 		else
 			amdgpu_vm_bo_idle(&bo_va->base);


