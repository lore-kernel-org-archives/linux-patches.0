Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E157679DD5;
	Mon, 15 Apr 2024 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191381; cv=none; b=G+qDtBtYjEEOZIrOnKraqM06pWZOCxTgpIOoIHK9l7iaBWfGt9Arp8fSAPz5trVoe9Id93qGFe9rzvPCQ1U9WAXCdB0KyV2JsPM8QbhimBVfBoyIw1rRZthKsBTujKfxR8s2RZe7jhR0XdEsRjzXeybbPWpjyDl5tSQrdKzd1/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191381; c=relaxed/simple;
	bh=ZKVWlqEiBcBJlyufCpl4GXCSuneVs7Jq91Zoc3bTzm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCu3bms2ZJEYcGz1Bcy9F3gZP7to2hr/DAVpT0r6irNBix0h529LCZE6OQY44JM+byBVsPhojpx+dVtcs0Ofos80rFB3+TyEAyqkdYku8UlMB+3SkPb4+jJhfuINOrVp4avSgbyn/49jw1NsnPEVwMiBs4zKB5pN6tsxXajCiJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYcBBtcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYcBBtcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64859C113CC;
	Mon, 15 Apr 2024 14:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191380;
	bh=ZKVWlqEiBcBJlyufCpl4GXCSuneVs7Jq91Zoc3bTzm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYcBBtcQxUQFoMUR2+Yd+PzVkHUrUj7vikdbcHN40sJ8FiEJO05rrw6+LWIYrByn3
	 +z9SylzUE9592orFxtiismk37DoCEFoKcWbapq4QyUkGlF2NNUXbNXYoeO503PJCG8
	 kuetZq4kGSmAqSNCAEFwD8TiZgNmnBO+HbpEAYFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.8 122/172] accel/ivpu: Fix deadlock in context_xa
Date: Mon, 15 Apr 2024 16:20:21 +0200
Message-ID: <20240415142004.096455540@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit fd7726e75968b27fe98534ccbf47ccd6fef686f3 upstream.

ivpu_device->context_xa is locked both in kernel thread and IRQ context.
It requires XA_FLAGS_LOCK_IRQ flag to be passed during initialization
otherwise the lock could be acquired from a thread and interrupted by
an IRQ that locks it for the second time causing the deadlock.

This deadlock was reported by lockdep and observed in internal tests.

Fixes: 35b137630f08 ("accel/ivpu: Introduce a new DRM driver for Intel VPU")
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-9-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -514,7 +514,7 @@ static int ivpu_dev_init(struct ivpu_dev
 	vdev->context_xa_limit.min = IVPU_USER_CONTEXT_MIN_SSID;
 	vdev->context_xa_limit.max = IVPU_USER_CONTEXT_MAX_SSID;
 	atomic64_set(&vdev->unique_id_counter, 0);
-	xa_init_flags(&vdev->context_xa, XA_FLAGS_ALLOC);
+	xa_init_flags(&vdev->context_xa, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	xa_init_flags(&vdev->submitted_jobs_xa, XA_FLAGS_ALLOC1);
 	lockdep_set_class(&vdev->submitted_jobs_xa.xa_lock, &submitted_jobs_xa_lock_class_key);
 	INIT_LIST_HEAD(&vdev->bo_list);


