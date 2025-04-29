Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351FA242D9A;
	Tue, 29 Apr 2025 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946701; cv=none; b=PkS4N9UAnfGuIzcn5XimaFX93aWgKO92SL6ch7yln3lOqEa2iBl3zaipMOCiMW0Zq4Po+qtmR5JAboxPDrZAAepzKwHvmw0OdGzW+H3L3pfAJoZW9irKXzBgbZ4zadOtsyg5Rmw91cdtibOngAz99orA5eW0EsLTXVbVjXySCGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946701; c=relaxed/simple;
	bh=zqxZOAFb3tbjVFsJDmDFmgHBzxChgBVkSh2YIsKuQeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYE73m2FahiYJGwR3+lOlWCa4xFlPnUQ5OlDdfEDKUyM2IR0SG50I+VQtTsnq3HGTy3xG39e5Ze9C63/hxsClfYfH9i2U69+Lv7ameNMm7Rb7mA6Csj3QA7sK6oHbbeCRBro3X2p1STEFU/cIsBybbE53dPLO4FLRK5DIC9bajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKW+QFG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKW+QFG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F6CC4CEE3;
	Tue, 29 Apr 2025 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946701;
	bh=zqxZOAFb3tbjVFsJDmDFmgHBzxChgBVkSh2YIsKuQeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKW+QFG2TrA99v+1VMI9kzmaOzcm3QRPrHmrhmlg6Fhru6ciUAi15vu6sXsDU1w15
	 Vk1j0wxSEtzRFJ0aHSFkTN9CyOLmIyEwMUts8hPwJsB95UrnMavUP7Pbg8pjM6TBXx
	 G+h70wEbd4lzWPykJcKmsK2D5lYWKQ48guzNDEP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/286] drm/amdkfd: Fix pqm_destroy_queue race with GPU reset
Date: Tue, 29 Apr 2025 18:39:05 +0200
Message-ID: <20250429161109.552346515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 7919b4cad5545ed93778f11881ceee72e4dbed66 ]

If GPU in reset, destroy_queue return -EIO, pqm_destroy_queue should
delete the queue from process_queue_list and free the resource.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 43c07ac2c6fce..cabe0012ab5b1 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -384,7 +384,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 			pr_err("Pasid 0x%x destroy queue %d failed, ret %d\n",
 				pqm->process->pasid,
 				pqn->q->properties.queue_id, retval);
-			if (retval != -ETIME)
+			if (retval != -ETIME && retval != -EIO)
 				goto err_destroy_queue;
 		}
 
-- 
2.39.5



