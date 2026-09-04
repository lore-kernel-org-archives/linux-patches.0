Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DCE18D636;
	Fri,  4 Sep 2026 05:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501181; cv=none; b=aEdVaj/GvaRWoy/UVH5burhMwqkX3f+V15Mzs5ctUvIhAoo5kIEl6UtD9cBRFopGvDoCMapb+D7nk+II+HF6cyU/PG5ulPovHD6lFoSYBLYr9KeUTTn4RvjvRr4rofWSXs5lhng3NP4Sp3e53Ncf5bUM3+qkOUGY/gHR79pdT9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501181; c=relaxed/simple;
	bh=+XHdmi9q2H+0FQYtl1mxK78FirYFfbheBCkPt3ZlZ6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1Nr036ai0FegPmGyrI2p5PjF99FpONLXPSiYgcONUuTsWhLkk1MAEyo/opt9yPxoqt3DBgbHwWMTSOz01iBk2YvVTsp1FzOfzlGjOdslk7gQFc6blZEsIYFJEpto6eyIKYlkCoZB22ckyDwova3N6wgug0ywoz1Ed36JU1gF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jm4ZY8HC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jm4ZY8HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D942C1F00A3D;
	Fri,  4 Sep 2026 05:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501178;
	bh=MVRmUtBxB8o4wMC01OApSdOSFLDV+oAH/qHKkQrLLi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jm4ZY8HCc1kQgnTcyyWRp0RCwmnnar08aWw+gv/+BJYOP8yehzX7GzYPNDPlQi1oy
	 GI4if+e5GVTYe4AJwpSJLqDOpHW2aEzbw3kBVwcI/6DTtAUteaUagkHxYkgOk6SxeR
	 hj6hyd0uhsu5VyAIhSfStCftIfBTdv54P0ijLUOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 319/552] ptp: vmclock: prevent read-only mappings from becoming writable
Date: Fri,  4 Sep 2026 06:57:56 +0200
Message-ID: <20260904045757.506574184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,6 +371,12 @@ static int vmclock_miscdev_mmap(struct f
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
 


