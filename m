Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C42EF2BE;
	Tue, 17 Jun 2025 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177571; cv=none; b=O+iKF6pfv8Zuc7MtclRnycEmvjXJOT8meThXPkrdHmMou02qB8bGKngMFETj12kc6iSCyMyfe/qF7xGEeStFQ8QXtGv9Z0NeL7jfU/j87KN90iACJyPDpvw5+WWfaecbJxRZTNX2RiCdaHKrWRLwxd5yg1klu08pcgkGUkVAAZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177571; c=relaxed/simple;
	bh=2gGg3MFk71+WH9xnbmP68/QT9SPGJ5MxbzHDucvLIsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKKcK1v5pM2UVVWpXKmcSqpzFyDinoWi+kaOXCZIsgHRWX/OEJ0dW9BQAVcsor/9DFirE7EVsRf4Qvug+p06r0ONw6zMFhh7URjtrMnUogencqM2/l0sozskEGivgvb2ii7wq0ho6MVpHXhm54twNlcVzlmlMSsvn3tpksl3JyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNoyUQe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNoyUQe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AA1C4CEF0;
	Tue, 17 Jun 2025 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177571;
	bh=2gGg3MFk71+WH9xnbmP68/QT9SPGJ5MxbzHDucvLIsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNoyUQe0hB0M2LIvjtRkRKorrtwYWSk7B/MizNoq7TqFApzFOItWQH8kt4vUjJAlj
	 pKO92J82WzquaAbnRMDJQOo4iDxac1kD8avRJfasIa1Ce+TyhJj0oSIuXf327cMVSU
	 +Ro30TnbZ6mNw/O+lOZS1b/sBybf1ukfhMixuGbk=
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
Subject: [PATCH 6.12 365/512] drm/i915/guc: Check if expecting reply before decrementing outstanding_submission_g2h
Date: Tue, 17 Jun 2025 17:25:31 +0200
Message-ID: <20250617152434.365009797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8aaadbb702df6..00e2cf92d99c7 100644
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



