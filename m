Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F7D1AB539;
	Wed, 20 Nov 2024 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107569; cv=none; b=oqLKPp8uWZM6JvHrwxL6fP9hqaK9+aZDRLi+7WrEghQzKl8EURAjkhuy/UQgfwWX6S6WAVdkVqzgXySwKbs1xgaLsyWgHAAb3wvh38Tck0JtBBo3/nn2AQ4uXAHnIR6UuMQAlpTY9G64zFJrUzpvjriyd7D+moeL7klFVQTf1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107569; c=relaxed/simple;
	bh=bwK9uRzmqhorJX8OkXGUyHq8Lkbk2ITv4K0U2OmReeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5m7SNMpUu9GTiI7V6nVmveH2RJKzfgTO0jdySlnpEgaCpkj/oASNuV5zxjmqbJPAoxJSn6FFkpcb3gazWLBbadShCR2fNpGb/uQyrHDrtajjCp5ZFml1ltWOALlvmNsrkKgDmf9cMS1GdOdhUVJBFkfK0tbwShCJTvD/JHVVWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+f2PHgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+f2PHgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1550CC4CECD;
	Wed, 20 Nov 2024 12:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107569;
	bh=bwK9uRzmqhorJX8OkXGUyHq8Lkbk2ITv4K0U2OmReeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+f2PHgqL6MLsvurwMMvI/lrvu0EUtuWDblFwdgJhrI3Wuhc+rPYibjxZ/Gac6JrT
	 QPrpI9/1VDBbMk+RtjebvXYKp3psgvZ8yDmlS6vzGLC2GsguiPqr40LgeB7wZlGbAe
	 VGtgHOjfAsQA17FDpa2Qwi5UaVHlZdq41ctk50TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 084/107] drm/xe: handle flat ccs during hibernation on igpu
Date: Wed, 20 Nov 2024 13:56:59 +0100
Message-ID: <20241120125631.584618546@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit be7eeaba2a11d7c16a9dc034a25f224f1343f303 upstream.

Starting from LNL, CCS has moved over to flat CCS model where there is
now dedicated memory reserved for storing compression state. On
platforms like LNL this reserved memory lives inside graphics stolen
memory, which is not treated like normal RAM and is therefore skipped by
the core kernel when creating the hibernation image. Currently if
something was compressed and we enter hibernation all the corresponding
CCS state is lost on such HW, resulting in corrupted memory. To fix this
evict user buffers from TT -> SYSTEM to ensure we take a snapshot of the
raw CCS state when entering hibernation, where upon resuming we can
restore the raw CCS state back when next validating the buffer. This has
been confirmed to fix display corruption on LNL when coming back from
hibernation.

Fixes: cbdc52c11c9b ("drm/xe/xe2: Support flat ccs")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3409
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241112162827.116523-2-matthew.auld@intel.com
(cherry picked from commit c8b3c6db941299d7cc31bd9befed3518fdebaf68)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo_evict.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo_evict.c
+++ b/drivers/gpu/drm/xe/xe_bo_evict.c
@@ -38,10 +38,21 @@ int xe_bo_evict_all(struct xe_device *xe
 		return 0;
 
 	/* User memory */
-	for (mem_type = XE_PL_VRAM0; mem_type <= XE_PL_VRAM1; ++mem_type) {
+	for (mem_type = XE_PL_TT; mem_type <= XE_PL_VRAM1; ++mem_type) {
 		struct ttm_resource_manager *man =
 			ttm_manager_type(bdev, mem_type);
 
+		/*
+		 * On igpu platforms with flat CCS we need to ensure we save and restore any CCS
+		 * state since this state lives inside graphics stolen memory which doesn't survive
+		 * hibernation.
+		 *
+		 * This can be further improved by only evicting objects that we know have actually
+		 * used a compression enabled PAT index.
+		 */
+		if (mem_type == XE_PL_TT && (IS_DGFX(xe) || !xe_device_has_flat_ccs(xe)))
+			continue;
+
 		if (man) {
 			ret = ttm_resource_manager_evict_all(bdev, man);
 			if (ret)


