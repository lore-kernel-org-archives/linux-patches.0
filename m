Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF37366820;
	Fri, 15 May 2026 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862121; cv=none; b=tHa0Hm4KF4pbZnyZ+BgTkVMB3HlDKE22AFiW//XxSsIq4GLtI+UGK9UPNUtbGUpWz8NvxgurpSY7weBy7pHbpeN2Go/EOvYmNmDQ265mWzSyfkquithQ+aLQgRsfy/FF4Q5sedHftRpeV7qfpkiB8b8e8/jWxhXHDyiPwYRdh8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862121; c=relaxed/simple;
	bh=UUbc3Znecbc+CU03YleCPhh+vHI/MKp3WNzjqpeW3W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYWQmtDJRrLV8czE0WjcetcC2LCUzwWsoK8+JyeNcWchV8Jp4+U5DFA9eGpHEE9vStetTFQdQQrKM3Qf785+/Ji3S1AnrrK1GVQ3XhpfyEyfrIJcEzb/kVXANrTO7mfU5MKU2n9kmDZtiWnqwNVkyhu+vim0sMpuAQ73wdks3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=touXQ/A+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="touXQ/A+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C58C2BCB0;
	Fri, 15 May 2026 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862121;
	bh=UUbc3Znecbc+CU03YleCPhh+vHI/MKp3WNzjqpeW3W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=touXQ/A+kL8PE23NtZcb9XIrj7Evpyggql6xudqltfaH6mNy03kEZzxDsLGg61DNM
	 B/yga84RSAFyZSsFLqUPEp7sKnO6VsWV9JmWsJf9849iDWditVLNXpm2xr4fZb5mrr
	 p5elfk90uAxNsKNWoLtLsSQUbKU8h10GZ5bHbavE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 117/188] drm/xe/bo: Fix bo leak on GGTT flag validation in xe_bo_init_locked()
Date: Fri, 15 May 2026 17:48:54 +0200
Message-ID: <20260515154659.868355674@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -2112,8 +2112,10 @@ struct xe_bo *xe_bo_init_locked(struct x
 	}
 
 	/* XE_BO_FLAG_GGTTx requires XE_BO_FLAG_GGTT also be set */
-	if ((flags & XE_BO_FLAG_GGTT_ALL) && !(flags & XE_BO_FLAG_GGTT))
+	if ((flags & XE_BO_FLAG_GGTT_ALL) && !(flags & XE_BO_FLAG_GGTT)) {
+		xe_bo_free(bo);
 		return ERR_PTR(-EINVAL);
+	}
 
 	if (flags & (XE_BO_FLAG_VRAM_MASK | XE_BO_FLAG_STOLEN) &&
 	    !(flags & XE_BO_FLAG_IGNORE_MIN_PAGE_SIZE) &&


