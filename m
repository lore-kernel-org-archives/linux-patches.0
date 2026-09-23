Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF955304DD;
	Wed, 23 Sep 2026 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174024; cv=none; b=bruG9f/x1J/r/KKFKUm4aBM+Gp+4TCk+Cgp1YeaVhKCWCTE3hbzZukKGO7j3vFfRfZvW8xPFxLOMwXXNdgsGxO3ehPKgCRjmH6VKZ/Xjw8nbMWMYCoeDChCXEBZvExeh2Ez1BvRZF92peivaATiEhi205qP7Zxv1zTCdVM3d7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174024; c=relaxed/simple;
	bh=Ya0jDl3sLyAILU6npasHgxWJ+9dHmujD8j7V/xD0ymw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9NRhHArFx9EB6pSvb1JJjoEN2aBVZ7Xwqs3X1KWx+LE/zmnhSAemJK/8sfVSZFnkH/IpbYRkQ+VsNRrAnYUxl9HzCHZijVcUfwqytV6scynM2pOz5D6uUHZQlUZP3H2MDxcmRwQkZS65gHVJNJE5JYLEFclIasxqkB3YQTuTtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzNev3Nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzNev3Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C51F1F000FF;
	Wed, 23 Sep 2026 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174022;
	bh=1d4fl/gvRfQEAXC985EZ89tMSWT7HaAU3tvc8Woa4Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzNev3NnVy9rJgy66bqcv29e0lQkORZwXdsYPVXHkrTJIB2Qgniv4X3z9IlhFYeRp
	 yswQxqpHllOA1FGCWLDy/hQjLne/xfwqUxRfUrkKo8oelfGbBQFPPU8/aXNRueWavy
	 ASbE6N9pPGazL1NN1a/NLkL46Bmw3IFN3PNqm0iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 411/438] drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc
Date: Wed, 23 Sep 2026 16:07:12 +0200
Message-ID: <20260923140655.560503499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

commit c883d0a132d430ef7ebb23fd94323be94d0fbdb8 upstream.

The low 6 bits of cp_hqd_eop_control store the base-2 logarithm
of the EOP ring size. This was calculated as

ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1

But ffs can in theory return 1 or 0, so this could underflow
(although in practice the ring buffer size cannot be less than 4096).

Change this to

ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)

using properties of logarithms.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4f18c56630383c14bfc6b2d65f88f2f895d2121a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -204,7 +204,7 @@ static void update_mqd(struct mqd_manage
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -242,7 +242,7 @@ static void update_mqd(struct mqd_manage
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c
@@ -217,7 +217,7 @@ static void update_mqd(struct mqd_manage
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c
@@ -295,7 +295,7 @@ static void update_mqd(struct mqd_manage
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =


