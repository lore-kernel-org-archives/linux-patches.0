Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30BA1E1C22;
	Tue, 17 Jun 2025 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178981; cv=none; b=U9/zhlAf6Iw3uYVQBY7KZVchsPT1t6nc9s1qLIyG9myb4OBJJXmd1YsLC7XgT8OJr5iJGT6c4d1jwjYmm0pa9Uc3CZmnNgUhz8+qipxG/YteOQVqXAoZnxpOVHvqFrfwyO/rDbsHmIkb7TW9b0d6h+sSiT2xJkkfWXuznAG/lx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178981; c=relaxed/simple;
	bh=Sx+M5vtC/p01iD3zOEq62VL4Cey6+BgoyPjZ2rIsW0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX0yNY7YBV8EMI2i5Q2NR194FPGF5uLZAaSsHGi+OjeEFlK/WNf3FOI0K8Yk2WzsawP/BVsmv5yYZfAf/FpqB6VxrrGE0R3Wu5+RdRn2nLQCfyAmj6JbsBJlG+3ZK69Ql3yJRWsI0pVwIQ3eYxND9ObbvISMwseAA/akAsy/Mjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/4mXb6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/4mXb6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEDBC4CEE3;
	Tue, 17 Jun 2025 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178981;
	bh=Sx+M5vtC/p01iD3zOEq62VL4Cey6+BgoyPjZ2rIsW0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/4mXb6wmLCDjpfOINqkhSXmYA8eGr/kL6Bkr6aWxewQ1vHOTUuSQwsq+OzkQrbSI
	 hTdar8ggH1tR6PMTqxCb4XleX3BLNLUMv9neG51uZuvZOBtqM4hIoG0R+yb7goMJ41
	 8/Jp2OHeoVOHiy3iRKdXGhPcaaCuMtquJsk+28E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesus Narvaez <jesus.narvaez@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Mousumi Jana <mousumi.jana@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 582/780] drm/i915/guc: Check if expecting reply before decrementing outstanding_submission_g2h
Date: Tue, 17 Jun 2025 17:24:50 +0200
Message-ID: <20250617152515.186794111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesus Narvaez <jesus.narvaez@intel.com>

[ Upstream commit c557fd1050f6691dde36818dfc1a4c415c42901b ]

When sending a H2G message where a reply is expected in
guc_submission_send_busy_loop(), outstanding_submission_g2h is
incremented before the send. However, if there is an error sending the
message, outstanding_submission_g2h is decremented without checking if a
reply is expected.

Therefore, check if reply is expected when there is a failure before
decrementing outstanding_submission_g2h.

Fixes: 2f2cc53b5fe7 ("drm/i915/guc: Close deregister-context race against CT-loss")
Signed-off-by: Jesus Narvaez <jesus.narvaez@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Mousumi Jana <mousumi.jana@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250514225224.4142684-1-jesus.narvaez@intel.com
(cherry picked from commit a6a26786f22a4ab0227bcf610510c4c9c2df0808)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index f8cb7c630d5b8..108331a699958 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -633,7 +633,7 @@ static int guc_submission_send_busy_loop(struct intel_guc *guc,
 		atomic_inc(&guc->outstanding_submission_g2h);
 
 	ret = intel_guc_send_busy_loop(guc, action, len, g2h_len_dw, loop);
-	if (ret)
+	if (ret && g2h_len_dw)
 		atomic_dec(&guc->outstanding_submission_g2h);
 
 	return ret;
-- 
2.39.5



