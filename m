Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C133F9285;
	Fri, 15 May 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862705; cv=none; b=pNvLs4TTBh4peoPmiRFa3DNvp4uj2vcchzunD7hgHAvF7ehNADz2XQdb33jvNKjBgC4XR0QFPudBSa3aA+Asy2vFsj/GfBullzHWcgWQy6suzl6c0yI1gchM/eF1sEoea7VFI3b5yOQCqUZF++bSd83H6QsKNUgOJR+Jn8XnWEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862705; c=relaxed/simple;
	bh=uZvFsKYgQoHL5hblN5h/HcRLtCi1JNqYOAR3vGUz7iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/V5M/eQVQvKgCs3Xt8d+5feI1OxqVSsdeOmyhn9eDcxsRw/ZdJZbHMysezpBUBm/Onv7/yrakHEgwoeLtSatV4Db/B/1G4/Rut5gX1RaJIRU9Rg0pbMXoNmqFuZ6J3OcAbmQeeG00P/bcF+U8jPvX0/XySPlsH8x4rPAoW/HD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7o0rjEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7o0rjEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9027CC2BCC7;
	Fri, 15 May 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862704;
	bh=uZvFsKYgQoHL5hblN5h/HcRLtCi1JNqYOAR3vGUz7iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7o0rjEj/SCutct92OXzqREfXFpAqa+kp2fde0c0tILEi4JPIxFhu1frjiWXgOGkc
	 CT2hbtEBjDNwjMGA9Jo9TkL6oAj0fZOKivWasRt0/O0b1rLwFonzJRFi1Vz83VUNRi
	 nmB20ptqlE2dWPCeOs5PinFSIhA9wRGnY0KwgC+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattheq Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.0 151/201] drm/xe: Fix dma-buf attachment leak in xe_gem_prime_import()
Date: Fri, 15 May 2026 17:49:29 +0200
Message-ID: <20260515154701.842463140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 111ab678471bf1f90d078d5513bb086b70596c3c upstream.

When xe_dma_buf_init_obj() fails, the attachment from
dma_buf_dynamic_attach() is not detached. Add dma_buf_detach() before
returning the error. Note: we cannot use goto out_err here because
xe_dma_buf_init_obj() already frees bo on failure, and out_err would
double-free it.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Mattheq Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408175255.3402838-5-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit a828eb185aac41800df8eae4b60501ccc0dbbe51)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_dma_buf.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -358,12 +358,15 @@ struct drm_gem_object *xe_gem_prime_impo
 		goto out_err;
 	}
 
-	/* Errors here will take care of freeing the bo. */
+	/*
+	 * xe_dma_buf_init_obj() takes ownership of bo on both success
+	 * and failure, so we must not touch bo after this call.
+	 */
 	obj = xe_dma_buf_init_obj(dev, bo, dma_buf);
-	if (IS_ERR(obj))
+	if (IS_ERR(obj)) {
+		dma_buf_detach(dma_buf, attach);
 		return obj;
-
-
+	}
 	get_dma_buf(dma_buf);
 	obj->import_attach = attach;
 	return obj;


