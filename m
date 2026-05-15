Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7208C3FF1DA;
	Fri, 15 May 2026 15:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860415; cv=none; b=TxcomrEMmqjK7ta2YBX6H5D74SjlRQ7vn2DWfJrc1uBA1QzX3u1UR2YD+TXe7QuSPHRkWT4hsY2hWwG8y8IejICJ86vyIPh4YvgMZfK9HVEllLf+x4wlz5Vm9O0fh6RDiziEm9xbS6P3bNF+TZ+e6UHUDaHPTLOHJqBlHnp/A7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860415; c=relaxed/simple;
	bh=IYHQX7eLVtXpIUIwSZFOXlfvJsEoBPS/eHSEAPmUmQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFHTJxI1fEGDO1psiH43phYnxhPvJKzyuVrWB2cuY02AtxmZv6cxczLG8pyahXUhub85aiR4GZy1jdkwP6vKdf0RDxq9uByIFYMKqDiBU1hROqEiSjSl7BmBEqgRkGsSG9/RYp/OIHj56zm/zNuSODPbVIOmqk98HRcDrb2nFyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idwRZkwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idwRZkwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ACCC2BCB0;
	Fri, 15 May 2026 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860415;
	bh=IYHQX7eLVtXpIUIwSZFOXlfvJsEoBPS/eHSEAPmUmQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idwRZkwyJ9JdKy3trCaQ5hIVHvZKUNhQRobzXEVtrxJGlJqA2yusOxa9AGfA48HjA
	 lEt3D+oMvtKC4jHqlhHJY1rB948nbOJImIOQ003znAenyKtzT9ZooO7H5IJdvDCq5a
	 yf9uC/T9qEn9YuwYCBYjzDfshNCw6V/fcEkmcc6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 080/144] drm/xe/bo: Fix bo leak on GGTT flag validation in xe_bo_init_locked()
Date: Fri, 15 May 2026 17:48:26 +0200
Message-ID: <20260515154655.383652165@linuxfoundation.org>
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

commit 1d0adf2fd94fb0c0037c643fadd8f2cf3cffc009 upstream.

When XE_BO_FLAG_GGTT_ALL is set without XE_BO_FLAG_GGTT, the function
returns an error without freeing a caller-provided bo, violating the
documented contract that bo is freed on failure.

Add xe_bo_free(bo) before returning the error.

Fixes: 5a3b0df25d6a ("drm/xe: Allow bo mapping on multiple ggtts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408175255.3402838-3-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 3fbd6cf43cac7b60757f3ce3d95195d3843a902c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1312,8 +1312,10 @@ struct xe_bo *___xe_bo_create_locked(str
 	}
 
 	/* XE_BO_FLAG_GGTTx requires XE_BO_FLAG_GGTT also be set */
-	if ((flags & XE_BO_FLAG_GGTT_ALL) && !(flags & XE_BO_FLAG_GGTT))
+	if ((flags & XE_BO_FLAG_GGTT_ALL) && !(flags & XE_BO_FLAG_GGTT)) {
+		xe_bo_free(bo);
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (flags & (XE_BO_FLAG_VRAM_MASK | XE_BO_FLAG_STOLEN) &&
 	    !(flags & XE_BO_FLAG_IGNORE_MIN_PAGE_SIZE) &&


