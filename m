Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF56275861;
	Tue, 21 Oct 2025 20:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077504; cv=none; b=tCKvMAPcZ/ZT9XRQMfwc8lwrzmsBT9vdRkeKDGtSwXF2b/DvMmFzEeYwtU46bTUASCgZqK+U6R2HwI6+9B3vFDDyQLcQ5HFMUBQk1v/4yzQGdlVca81YWPQObinqkg7/g0aKD4Juy+TfStdbh78zdZRUFqMkgzkMU2PQDRVgybE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077504; c=relaxed/simple;
	bh=ehTC5FnRHcDRgRyr9kEhpLB9MhTbEmExB2CH9zQdMTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYk4DH7XqlDsBQIJEXnJknnsGT5ZLhBqvzzR3PoJNx8CE3g7EA6LDG/OyIC6liejL4fPwUPtlr92YGXB9xQ3UsHPllqNgM+I4rEim1zDjvOx2AEI705hMeN2q/5hH3Y5O/V8UOxiH9wDZy2vbnUQUWrMKe883zLafx2E4hWamJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UE4Iqy6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UE4Iqy6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E59AC4CEF1;
	Tue, 21 Oct 2025 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077503;
	bh=ehTC5FnRHcDRgRyr9kEhpLB9MhTbEmExB2CH9zQdMTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UE4Iqy6R+31LfFGr2YvQBqj7hfA1IBX/RDRdOcVCe8s9y3E0BGvfSpUFArN7jacIm
	 a1vznefnYo2tD9O7PeZxPM537lZbLeXo1czpmPVkjdO+HvGTOYW5YwA+bdxY9+kxSm
	 ABFg0fhpCZXeAHSFsSayKuzhZ1SxyExsuiaBQKd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/159] cxl/trace: Subtract to find an hpa_alias0 in cxl_poison events
Date: Tue, 21 Oct 2025 21:51:42 +0200
Message-ID: <20251021195046.160350492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit a4bbb493a3247ef32f6191fd8b2a0657139f8e08 ]

Traces of cxl_poison events include an hpa_alias0 field if the poison
address is in a region configured with an ELC, Extended Linear Cache.

Since the ELC always comes first in the region, the calculation needs
to subtract the ELC size from the calculated HPA address.

Fixes: 8c520c5f1e76 ("cxl: Add extended linear cache address alias emission for cxl events")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index a53ec4798b12f..a972e4ef19368 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -1068,7 +1068,7 @@ TRACE_EVENT(cxl_poison,
 			__entry->hpa = cxl_dpa_to_hpa(cxlr, cxlmd,
 						      __entry->dpa);
 			if (__entry->hpa != ULLONG_MAX && cxlr->params.cache_size)
-				__entry->hpa_alias0 = __entry->hpa +
+				__entry->hpa_alias0 = __entry->hpa -
 						      cxlr->params.cache_size;
 			else
 				__entry->hpa_alias0 = ULLONG_MAX;
-- 
2.51.0



