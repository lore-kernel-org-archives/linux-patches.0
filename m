Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768B13FE356;
	Tue, 21 Jul 2026 19:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661421; cv=none; b=CsyLv/q9k5r0ZnKu5O+PzDn2NZZan5bmtwV96NifwaRXdexL3c2I4YEZsRHQqwbNviGmpsegRJIijqc0HOePo3M4bTWxg8dgFNBjGWcuM9zshBt55Rts0RX9bCQbyKtF+XyTyTBk6ivSGxDSvwcTajTE2XY+eZJQZykCeNpowBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661421; c=relaxed/simple;
	bh=X5tiSLHloATc/xiw40rapfe+JQ1cSeua/OGtWUr3GxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgkbqna9PyyNO0DLT9NU/QnuNKZ2xR78J2mO3F/y9uHNaML2R0yRkJyVeHEu4Q/KLD9x4QBo7hbrR/GBy42VYfsh1nPpL3dwBJL12hbZ8MBb4XZmTxPecOSEEkiAXMnSKE1EiHGyzXnCrCzoriFPc69CHavMxuYO8XZ8yHJ5Mo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+YGgnAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+YGgnAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20AA1F000E9;
	Tue, 21 Jul 2026 19:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661420;
	bh=OibURoF58wsOeDJToUksO/XzBDm8DMLeHrdjJPFfr5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+YGgnAnOKMUX5EZq1W6wPr2u/R4mIX6r4T1VlHBfdcNUrdFigHheLHd53fedacbP
	 Fw9HsRBXtMCmYKdsKvoQ7JB1uq/MFM1E12e29TlORQcb1kPQ4wJUOJcxZPp/vkyf7K
	 qRq0J17mTnfppUANwhyEu55U/ZrWcb7xrI3OpIr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0061/1276] drm/gpuvm: Do not prepare NULL objects
Date: Tue, 21 Jul 2026 17:08:24 +0200
Message-ID: <20260721152447.450062103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

[ Upstream commit 88f059f6f6f589bd78e2ceb05a1339a8c10b8626 ]

Statis analysis issue:

drm_gpuvm_prepare_range issues an exec_object_prepare call to all
drm_gem_objects mapped between addr and addr + range.  However, it is
possible (albeit very unlikely) that the objects found through
drm_gpuvm_for_each_va_range (as connected to va->gem) are NULL, as seen
in other functions such as drm_gpuva_link and drm_gpuva_unlink_defer.

Do not prepare NULL objects.

Fixes: 50c1a36f594b ("drm/gpuvm: track/lock/validate external/evicted objects")
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Link: https://patch.msgid.link/20260130191953.61718-2-jonathan.cavitt@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpuvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_gpuvm.c b/drivers/gpu/drm/drm_gpuvm.c
index f9eb56f24bef29..0321820e9bab77 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -1219,6 +1219,9 @@ drm_gpuvm_prepare_range(struct drm_gpuvm *gpuvm, struct drm_exec *exec,
 	drm_gpuvm_for_each_va_range(va, gpuvm, addr, end) {
 		struct drm_gem_object *obj = va->gem.obj;
 
+		if (unlikely(!obj))
+			continue;
+
 		ret = exec_prepare_obj(exec, obj, num_fences);
 		if (ret)
 			return ret;
-- 
2.53.0



