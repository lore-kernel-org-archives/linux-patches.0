Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EE812EBEA;
	Tue, 25 Jun 2024 09:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308671; cv=none; b=u4vjM0TtX6fPq8GzMTnfv5K8SvggY0aEaRrSmNC6GzZv6mRgX/etSgaZmLTtEYBFpoVkUGALQYfxPpIEH/UvYbY5ALuL0exs9Z8WgCG497ejZCe1jbP5c4BfureRtAOs6TQmoh13i5ZFSiu3JEbpsirXbJcqLxouPWvc5Gs/7r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308671; c=relaxed/simple;
	bh=gzuycz2WjhFvLIsG/b1xF1BXkobLTNEadHJWsFUay0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=misJs7R0Rd1pRL+NZ2yMyyLx9xVpuzoEczc0YLsCgJU7xGQomVHMAexYvMS9MINkew0QGVgIkDGWmoKRS2F4o8XVH/owSuMi4CK2nb/hdQASNrKieVAZsjHrdGwkRRFSVnfXg6IRJltk6VbniHfyYWh2cQo/jd5F7nElNNfYa3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRD3W+x3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRD3W+x3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EA9C32781;
	Tue, 25 Jun 2024 09:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308671;
	bh=gzuycz2WjhFvLIsG/b1xF1BXkobLTNEadHJWsFUay0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRD3W+x3ecrRuZx7K7TC5dSQd1RUwkcumGchFWE5N67nUMJ0BZLPiUk1ZYjMPiw9E
	 c/UM2+i3wzv4NuDIz11HN8ygTqZ13dmpBMu258JI6g3Oenrqhc5cYkRURa7Jg/iIgz
	 Uxo2z8pPUFuY4dC1rNUK0p17P3WG3V28wgYq9zm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 170/250] drm/xe/vf: Dont touch GuC irq registers if using memory irqs
Date: Tue, 25 Jun 2024 11:32:08 +0200
Message-ID: <20240625085554.578774703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit d21d44dbdde83c4a8553c95de1853e63e88d7954 ]

On platforms where VFs are using memory based interrupts, we
missed invalid access to no longer existing interrupt registers,
as we keep them marked with XE_REG_OPTION_VF. To fix that just
either setup memirq vectors in GuC or enable legacy interrupts.

Fixes: aef4eb7c7dec ("drm/xe/vf: Setup memory based interrupts in GuC")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240617154736.685-1-michal.wajdeczko@intel.com
(cherry picked from commit f0ccd2d805e55e12b430d5d6b9acd9f891af455e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 0d2a2dd13f112..a38f59b4356d4 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -643,8 +643,6 @@ int xe_guc_enable_communication(struct xe_guc *guc)
 	struct xe_device *xe = guc_to_xe(guc);
 	int err;
 
-	guc_enable_irq(guc);
-
 	if (IS_SRIOV_VF(xe) && xe_device_has_memirq(xe)) {
 		struct xe_gt *gt = guc_to_gt(guc);
 		struct xe_tile *tile = gt_to_tile(gt);
@@ -652,6 +650,8 @@ int xe_guc_enable_communication(struct xe_guc *guc)
 		err = xe_memirq_init_guc(&tile->sriov.vf.memirq, guc);
 		if (err)
 			return err;
+	} else {
+		guc_enable_irq(guc);
 	}
 
 	xe_mmio_rmw32(guc_to_gt(guc), PMINTRMSK,
-- 
2.43.0



