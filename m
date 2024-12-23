Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDADB3D6D;
	Mon, 23 Dec 2024 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970046; cv=none; b=B63Vu4CRBYQiiiYaJQ/QKqEKZaZfCH9XnwTbO4XTnRqcNtfum3MSp+gaciPUJuYoK9koHOpN7Rcs3dHYQo0pdLP6CslChMIFTDdi9Uc71XyQsGxqX2xcUvV/g7VO0Ve225Cx07xt3XCBYzj9lbSgXI5yrIMcH1Qug2s/McxyV/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970046; c=relaxed/simple;
	bh=DEno4ts14ThKMRhVzmmdbYHOHu7TfcXZCn30hXI+oLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8e8BOZJDPuKKZJxWRjVoFSCX2e6FJ3cb2mIKoyyfJN6dDotbdNo50MPfXDpAdFipNnphJ4GgJDpoosUQGYQP4DkpvfRD5l0qYUC55ITTnOyq3aVbwg5D5hRiJMNevWth3TQvTB9iqMhhL78R3w7ct1Rk9Vh3nk/xOSmvK2nqVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSZgRzE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSZgRzE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CFBC4CED3;
	Mon, 23 Dec 2024 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970046;
	bh=DEno4ts14ThKMRhVzmmdbYHOHu7TfcXZCn30hXI+oLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSZgRzE3pObxrmutsTS1I1B6ewJ0LBxFvJ0Hc239iDXwDSm1FNT91joqvyBxFMzbW
	 kD8Qxs0v05u1p8JI+McfYT1kwgNqv9x6nTwXMkLqb50ghSEDrcgPwh0TkMkrFiG21p
	 9TG23V/9OaSxB+Pf+vDLjrSdfl/hx2UUD2NiDjFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 129/160] accel/ivpu: Fix WARN in ivpu_ipc_send_receive_internal()
Date: Mon, 23 Dec 2024 16:59:00 +0100
Message-ID: <20241223155413.773654198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 0f6482caa6acdfdfc744db7430771fe7e6c4e787 upstream.

Move pm_runtime_set_active() to ivpu_pm_init() so when
ivpu_ipc_send_receive_internal() is executed before ivpu_pm_enable()
it already has correct runtime state, even if last resume was
not successful.

Fixes: 8ed520ff4682 ("accel/ivpu: Move set autosuspend delay to HW specific code")
Cc: stable@vger.kernel.org # v6.7+
Reviewed-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210130939.1575610-4-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -364,6 +364,7 @@ void ivpu_pm_init(struct ivpu_device *vd
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, delay);
+	pm_runtime_set_active(dev);
 
 	ivpu_dbg(vdev, PM, "Autosuspend delay = %d\n", delay);
 }
@@ -378,7 +379,6 @@ void ivpu_pm_enable(struct ivpu_device *
 {
 	struct device *dev = vdev->drm.dev;
 
-	pm_runtime_set_active(dev);
 	pm_runtime_allow(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);


