Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95918282F1A;
	Fri, 15 May 2026 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860420; cv=none; b=qAMbjLuCpA2faD4WW19LvblOpNHd34XdwBk8TdI5Qv5sf7IpD2u49D5brvSuMh8FT8Dbb0tTtF+KOJY0ju/87j2eD5TZ/vAEq3MpWOW8aw8jzFQ47l+dmYfMpu2egW1UOedhqrWtMi9rWQodukemOGuXK7J/P/mM93DWIVSyWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860420; c=relaxed/simple;
	bh=WoF8dBhOsxgebnM7XdzphgansWI7K0vI7QxckTnekD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA5SCqPvhD/iqiIaKlDOInp+9BdnJWPZhgVFwpbJ1gmwfcVCXFGGQzksd8IYdOwxcGKULqZiaQc0aMjq0nrE5ZAPJzA8WCv+GlSL5R8jKkWhb4LUpgHHdsEd/TNdBMwR3T2OEmKbbf1Mn1LEiPt2uxj4USF/GcWUNe3JNPpjGJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snc87FyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snc87FyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3FFC2BCB0;
	Fri, 15 May 2026 15:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860420;
	bh=WoF8dBhOsxgebnM7XdzphgansWI7K0vI7QxckTnekD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snc87FyLLsb1ZycIQYCbxdiGFKJiwy7GXCROsIHHvuszrcYMKe41Ax3CTQrJe0KWb
	 3MeX4NYTKsIPcMxuLt7e4E35NwQ+6Jp9Av7Q7lFPEK7qxuWHJy27/CGPz3FqPkkdhA
	 kHX5iFnCyKhRtm544MSg6XB7jRU6BxncZrSW5Acg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 082/144] drm/xe/bo: Fix bo leak on unaligned size validation in xe_bo_init_locked()
Date: Fri, 15 May 2026 17:48:28 +0200
Message-ID: <20260515154655.426928030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 09a8f3c1c11977a6e10c167f26dd298790b31c32 upstream.

When type is ttm_bo_type_device and aligned_size != size, the function
returns an error without freeing a caller-provided bo, violating the
documented contract that bo is freed on failure.

Add xe_bo_free(bo) before returning the error.

Fixes: 4e03b584143e ("drm/xe/uapi: Reject bo creation of unaligned size")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408175255.3402838-2-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 601c2aa087b6f21014300a3f107a08ee4dde7bdf)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1334,8 +1334,10 @@ struct xe_bo *___xe_bo_create_locked(str
 		alignment = SZ_4K >> PAGE_SHIFT;
 	}
 
-	if (type == ttm_bo_type_device && aligned_size != size)
+	if (type == ttm_bo_type_device && aligned_size != size) {
+		xe_bo_free(bo);
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (!bo) {
 		bo = xe_bo_alloc();


