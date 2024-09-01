Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55161C68C;
	Sun,  1 Sep 2024 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208320; cv=none; b=JyQP74nmpl7SGlt6joj8MApGqXTbYStBCaV/eqjZZXHN5qfU+L+AaR6IlJ1B6y9FplenjOp6PdibM6ynRmxEZ+Bb0xSg1PZSO7sa0wzNcTgMnn53wbgcWmsz78Pd1/wF1XFlHytglAZyLtZ/FnG//XmPSBujf4W94YQ/iczu90A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208320; c=relaxed/simple;
	bh=4FGqN5F6GnKL6aIt4Lu9oQrdrZ1CM/pX1+7VfPwpp4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/Hvk41RArKZokLpIto5zX67icab/4rqYMGyc9LEsNhGMvyOOQT+U8vueAcV2VO2KvOlQC5nqii5P1LakikYnBAXhwBWMPzZbgP2q0+EcF+mPsuM4RToFLZJnaqGplUPrcZ3MN4QO2+GM2MrE7bbIBwyLeqnj773GwNOfO1jAuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jqq/1St4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jqq/1St4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F715C4CEC3;
	Sun,  1 Sep 2024 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208320;
	bh=4FGqN5F6GnKL6aIt4Lu9oQrdrZ1CM/pX1+7VfPwpp4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jqq/1St4GPKopWo+MHZKIQ6Pyn8n7FmkvwaqHbsm5B7Yc10Rks09ngXywo9qqM3bU
	 IyQ79QYHEMxvFuDq+53XB49/iGioVlU3lMP1lWmBH5nGFedkcQxFreTqid8tCWFaYX
	 veSYHVEPvx2rJIXBtrbs7sUH1qZ7NaphZ1freicA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 046/149] drm/xe/vm: Simplify if condition
Date: Sun,  1 Sep 2024 18:15:57 +0200
Message-ID: <20240901160819.198974385@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit b3181f433206a1432bc7093d1896fe36026f7fff ]

The if condition !A || A && B can be simplified to !A || B.

Fixes the following Coccinelle/coccicheck warning reported by
excluded_middle.cocci:

	WARNING !A || A && B is equivalent to !A || B

Compile-tested only.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240603180005.191578-1-thorsten.blum@toblux.com
Stable-dep-of: 730b72480e29 ("drm/xe: prevent UAF around preempt fence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 4aa3943e6f292..3137cbbaabde0 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -85,8 +85,8 @@ static bool preempt_fences_waiting(struct xe_vm *vm)
 
 	list_for_each_entry(q, &vm->preempt.exec_queues, compute.link) {
 		if (!q->compute.pfence ||
-		    (q->compute.pfence && test_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
-						   &q->compute.pfence->flags))) {
+		    test_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
+			     &q->compute.pfence->flags)) {
 			return true;
 		}
 	}
-- 
2.43.0



