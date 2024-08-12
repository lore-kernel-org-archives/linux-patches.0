Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1DB134AC;
	Mon, 12 Aug 2024 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480081; cv=none; b=KIbpoMFDrfX16hjETIfy+e/Bg9K3LbyHcJHctErbo4jty08qwYakCEYkhKxqbqKItsycVYWv2Vwk8IWOPZ0idVOEnmo+qTaihYwUJ5PyWVXYrJAJZjViw7Ift3bfMFCqFz4YyO92vtdSenFV7Pbjv7aLt0NjGltxK/nraFNCWpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480081; c=relaxed/simple;
	bh=Om8TESHo7vcrNNsINsBx9khqLRxHJ32zsY4RVvsS/4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sR4VpINPcK6esZOXL588uYHaCZ3INnrUS59+MMF2ZkQjRv6YODaA2WaQdyzpzL7V2mabUdPSnpjbmVpYlV7NThzP1I2f61n6HFM6K0S4CTy6dR4rxvHLnP9WG+h828FhEjY1b25u272JUe2339l9eS+0ooyHVLAPnM1FuIvCmXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntEu2Shk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntEu2Shk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07D7C32782;
	Mon, 12 Aug 2024 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480081;
	bh=Om8TESHo7vcrNNsINsBx9khqLRxHJ32zsY4RVvsS/4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntEu2Shkml597Ipm1f+qjGY+UMImCIsLj1Lc3+TKOcPj4h2X6XN0BlkxVWoafveAN
	 kpTA1bAlh4whV+brWpNHMGTuco1H0WXVaiBgvnbQcmKrPm97XXSUV2ZLHDODEHSW/c
	 fPi6bajrN7GDqU/n1J+N4qf/0wj/BEWDDYzwAn14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Errabolu <Ramesh.Errabolu@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 091/263] drm/amd/amdkfd: Fix a resource leak in svm_range_validate_and_map()
Date: Mon, 12 Aug 2024 18:01:32 +0200
Message-ID: <20240812160150.028368187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramesh Errabolu <Ramesh.Errabolu@amd.com>

[ Upstream commit d2d3a44008fea01ec7d5a9d9ca527286be2e0257 ]

Analysis of code by Coverity, a static code analyser, has identified
a resource leak in the symbol hmm_range. This leak occurs when one of
the prior steps before it is released encounters an error.

Signed-off-by: Ramesh Errabolu <Ramesh.Errabolu@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 31e500859ab01..92485251247a0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1658,7 +1658,7 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 	start = map_start << PAGE_SHIFT;
 	end = (map_last + 1) << PAGE_SHIFT;
 	for (addr = start; !r && addr < end; ) {
-		struct hmm_range *hmm_range;
+		struct hmm_range *hmm_range = NULL;
 		unsigned long map_start_vma;
 		unsigned long map_last_vma;
 		struct vm_area_struct *vma;
@@ -1696,7 +1696,12 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 		}
 
 		svm_range_lock(prange);
-		if (!r && amdgpu_hmm_range_get_pages_done(hmm_range)) {
+
+		/* Free backing memory of hmm_range if it was initialized
+		 * Overrride return value to TRY AGAIN only if prior returns
+		 * were successful
+		 */
+		if (hmm_range && amdgpu_hmm_range_get_pages_done(hmm_range) && !r) {
 			pr_debug("hmm update the range, need validate again\n");
 			r = -EAGAIN;
 		}
-- 
2.43.0



