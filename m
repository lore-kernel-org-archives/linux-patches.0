Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3413A0B05;
	Wed, 21 Jan 2026 18:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020416; cv=none; b=dhoKTPBfFs3VgEB92Yoxf2gR+IglpOAGL1Kt40p8QfltSMgmJmfN6GJfmQ3dtD2aMNWkwbPuS/HCmZ4dNrZbOoNqxMO4CEYaCFrml+NbHnGqUQk5PYnbmk1CK69p17WWUS9nOesuvTk7F/4v1FkjM+TKVkzQ/kHlrNdH+E3YT+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020416; c=relaxed/simple;
	bh=BqXdIbM9Q0Uu01rAarQsUBUYB1JDCH8e2R6zsMe+Qrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVNpLRzGxO8Z6tVmPCoiSR6BrtUoZTLSOs4woBzV4bwQv0Gsle69bLGmI0ApyN42rId/NRJc4ZlbM/qlMJJ2xW30wVbRk/Mc9gIyIOcpAIjFnHw8/Pc3z0J7bwtsW2tlLzH6NceAepwa9+uSGL7kvIQUKOJ18O54GK7N8rgN1TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6iUOhWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6iUOhWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1820CC16AAE;
	Wed, 21 Jan 2026 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020416;
	bh=BqXdIbM9Q0Uu01rAarQsUBUYB1JDCH8e2R6zsMe+Qrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6iUOhWICjx+BmpxdvvkpwoDJpmoCGsnDud8fB6X4E4n0EkspHM8iGOde32G2k+2U
	 SYQnEwHlSyFWrT6/DSEmrXJyza5Xfrwb9Ru2BylXplWkRqyBog/QKbu+Jq/trtIKFS
	 iuMbpCjTG70K6IK4oyvGEhLe6JaBnPQIPyxODogo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 152/198] drm/amdgpu: Fix gfx9 update PTE mtype flag
Date: Wed, 21 Jan 2026 19:16:20 +0100
Message-ID: <20260121181424.025295146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit 292e5757b2229c0c6f1d059123a85f8a28f4464d upstream.

Fix copy&paste error, that should have been an assignment instead of an or,
otherwise MTYPE_UC 0x3 can not be updated to MTYPE_RW 0x1.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fc1366016abe4103c0f0fac882811aea961ef213)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1233,16 +1233,16 @@ static void gmc_v9_0_get_vm_pte(struct a
 		*flags = AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_NC);
 		break;
 	case AMDGPU_VM_MTYPE_WC:
-		*flags |= AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_WC);
+		*flags = AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_WC);
 		break;
 	case AMDGPU_VM_MTYPE_RW:
-		*flags |= AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_RW);
+		*flags = AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_RW);
 		break;
 	case AMDGPU_VM_MTYPE_CC:
-		*flags |= AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_CC);
+		*flags = AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_CC);
 		break;
 	case AMDGPU_VM_MTYPE_UC:
-		*flags |= AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_UC);
+		*flags = AMDGPU_PTE_MTYPE_VG10(*flags, MTYPE_UC);
 		break;
 	}
 


