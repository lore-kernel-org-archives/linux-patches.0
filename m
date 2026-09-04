Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AED419FBB;
	Fri,  4 Sep 2026 05:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499509; cv=none; b=C7qCYhmkHJhkjB603Rqx7AsBpvCTvVQwyVrWlSmuycOa4aaFNNEfXmJ9MQ1pA5I+uQrDWil8Au25NICzD0hWa3CY+ACWy6LKWwvRio43I+FVtRielGchFyjH6l2ymskrd2kFM60LDH6yKixgLPskVPR9Ofy4nod6SucRtjKWhQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499509; c=relaxed/simple;
	bh=bx1eVmZO2UXmLcI4Uj4xIl9TB/Iqrgm1HzU46fdZWUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGgTtMMiLvCAhyIi3R35OfgDuvG7yw113avp9ExRrhmgF+m8qlLAmRdwhncNNeRAgjZE2DY+37SGl3M8CdHtPUOeVebW6fO3dq4nPCmUQZh1nCJRbfnexoQkRFi1aslui4ejdH7eepxQaMW+axyqW4CGxJpQqel5aL9IU8keDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0ImVia/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0ImVia/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4EA1F00A3E;
	Fri,  4 Sep 2026 05:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499507;
	bh=qJyOJE/KcbgrVIyQOh267t50mjMcFk9CdA2zGq+gRME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0ImVia/+c/aA4/tcnXPrTGus2zBk0/q9PvzwpL97t7JJm6cGHgiKpHtL9BF44ah8
	 TIIr1IxFQ4j9mmurwkO8Fu7Cflllvb0Q/5wgabYVc02+8GYPBKi979SM8l8FkzKqKv
	 5zUudHLnBdGiD6np5DZixiJxSsFYUokOkKkpTkFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 440/713] ptp: vmclock: prevent read-only mappings from becoming writable
Date: Fri,  4 Sep 2026 06:56:48 +0200
Message-ID: <20260904045813.693604801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Abdifatah Suruur <suruurism@gmail.com>

commit a5edadbae57e2298a56cf7a4e774a027905a331f upstream.

vmclock_miscdev_mmap() rejects writable mappings of the shared vmclock
ABI page with -EROFS, but leaves VM_MAYWRITE set.  Userspace can map the
page read-only and then upgrade it to writable with mprotect(), after
which the guest can corrupt the host-written timekeeping data (sequence
counter, UTC time, TSC offset) that the vmclock ABI defines as read-only.

Clear VM_MAYWRITE on the read-only path so the mapping cannot be
upgraded, as i915 does for its read-only objects and as fixed in drm/vc4
(CVE-2026-68445) and drm/panthor (CVE-2024-53071).

Cc: stable@vger.kernel.org
Fixes: 205032724226 ("ptp: Add support for the AMZNC10C 'vmclock' device")
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://patch.msgid.link/20260813174707.14809-1-suruurism@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_vmclock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -378,6 +378,12 @@ static int vmclock_miscdev_mmap(struct f
 	 */
 	vm_flags_clear(vma, VM_MAYWRITE);
 
+	/*
+	 * Restrict the read-only mapping so it cannot be upgraded to
+	 * writable later with mprotect().
+	 */
+	vm_flags_clear(vma, VM_MAYWRITE);
+
 	if (vma->vm_end - vma->vm_start != PAGE_SIZE || vma->vm_pgoff)
 		return -EINVAL;
 


