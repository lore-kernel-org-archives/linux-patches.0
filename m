Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D583497B79;
	Wed, 23 Sep 2026 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173080; cv=none; b=qJSuhLo6e88t5RLp6Gh2/w27eiZwetbE0qwsAT8EIrbbwLfe9wJcGX6Se0izas8xqcNs1irc5WA9k5YhdBjtLehg3b1egXT62qvsSt+3qKvAMjs9TqqBF5Ptbqx+FnnzYe9PTzzBJDYU3wj68iWXQRpqTqcXDCbGQEInMNMGxoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173080; c=relaxed/simple;
	bh=2z78EJISyYF7LeuQ3Jz8sN7wFavEDQC5pKBj59E7fgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owN5S/Vy9t7CnUJwbATPD9Hgygrrh5KzDTzg+gPuesG8OkTB2O/qYk2Ryz2hmiLoRMxhbTDdAFYK8xp88QlsAg1EhlJdytH9+JDaJzIaOSDDFODtdjHl9AQa87ggx5D/rpNwn25isMIcEHfgoq2BhMoYPij9rMVSPDCsZdhqiws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4Ij0bqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4Ij0bqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE68A1F00898;
	Wed, 23 Sep 2026 14:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173079;
	bh=xLWjHE+52A1B2fV/oaKWDYJqHEDQhrtjd46wON+ScA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4Ij0bqU/0Tq/u7DilU6NESx79oj/+9WPSR0z6uVQj7iczEMa5c7+4LmTY+OvigvO
	 GzSx0QDmOzoWEaUC9Ff5rXkotxkW/T5lDwK6J3QgskAPu5SI9ysDENC6tlulyyDW9G
	 m/DxnoCXgzcYM+De58Cmhg0+UG1UrlQwdMIa/z8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Ilia Levi <ilia.levi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 144/438] drm/xe/mmio_gem: forbid VMA split
Date: Wed, 23 Sep 2026 16:02:45 +0200
Message-ID: <20260923140648.504565856@linuxfoundation.org>
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

From: Ilia Levi <ilia.levi@intel.com>

[ Upstream commit 247a82da6f563dcfd9074a68f99a0c0997d0679c ]

The fault handler assumes it always operates on a VMA spanning the entire
GEM object. This does not hold when the VMA has been split, e.g. by a
partial munmap or mprotect. In that case the handler may map wrong
physical pages or cause SIGBUS.

Handle this by forbidding VMA split, as partial unmaps are not deemed
useful for MMIO GEMs.

Suggested-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Ilia Levi <ilia.levi@intel.com>
Fixes: 1ffcf8b8ae8a ("drm/xe: Support for mmap-ing mmio regions")
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260908165046.1393557-11-matthew.auld@intel.com
(cherry picked from commit f3391a0b12d7bf826a0b21600d2f294f3dce4c14)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio_gem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_mmio_gem.c b/drivers/gpu/drm/xe/xe_mmio_gem.c
index 8c803ef233cc4..f15a6a84af159 100644
--- a/drivers/gpu/drm/xe/xe_mmio_gem.c
+++ b/drivers/gpu/drm/xe/xe_mmio_gem.c
@@ -39,10 +39,20 @@ struct xe_mmio_gem {
 	phys_addr_t phys_addr;
 };
 
+static int xe_mmio_gem_vm_may_split(struct vm_area_struct *area, unsigned long addr)
+{
+	/*
+	 * Forbid splitting. Together with VM_DONTEXPAND, this keeps the VMA
+	 * matching the GEM object exactly.
+	 */
+	return -EINVAL;
+}
+
 static const struct vm_operations_struct vm_ops = {
 	.open = drm_gem_vm_open,
 	.close = drm_gem_vm_close,
 	.fault = xe_mmio_gem_vm_fault,
+	.may_split = xe_mmio_gem_vm_may_split,
 };
 
 static const struct drm_gem_object_funcs xe_mmio_gem_funcs = {
-- 
2.53.0



