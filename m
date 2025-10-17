Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4C21946C8;
	Fri, 17 Oct 2025 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715021; cv=none; b=Po1h8AB8qzyMC3/SOx3TS49KAEVYJVOlAbDUNbYNQOdPVCevphSOX3VrLMK2bV9sc4aYC1A7I6gbi/hCIl3H/kloeZ5VPkWtS3Yqd7xVpO2Dpox+NMQZajF3qVj1b4V5OfvpG6I48LrF7J110UIU9IIRRXydcD8SmpUc/xl0+Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715021; c=relaxed/simple;
	bh=jxHojnc0PKg2DXSGtq+XPhLpH1PnAiHKm4gz1Hu2wm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7m9eqg3wqDrBoiJ2e338QA2jIlQSoLKlRz1m1y4wOKrQ+7oS/howlHTUaAPrwMAY+1OXyVw1b9MzJwr1HdZ7m/qPYg4UL1sdi7KFR1F1VOQlaZXFWndFEGMc6/bpSXkP3s806cn39ljZtVB3TGaZ0IwaFqtyQbIaEQVopt+4J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg9BD3JT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg9BD3JT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FFBC4CEE7;
	Fri, 17 Oct 2025 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715021;
	bh=jxHojnc0PKg2DXSGtq+XPhLpH1PnAiHKm4gz1Hu2wm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg9BD3JTr8Da3tgSzCNBIiScDOJUSZUdg7iwQwX5erOn5hyOm0N2D7Z6qcojEZvVY
	 FPsFhVIi2MYpAsl18dPcxz7HXc2ecO1i1KQtVUgqUgASKAqMJD8jsniOwoZ20FxhJ/
	 aAtaeQKI3riputzWFj8Ea2Rje6jzwrE9S9HHX+2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Mukesh R <mrathor@linux.microsoft.com>,
	Sean Christopherson <seanjc@google.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 071/371] mshv: Handle NEED_RESCHED_LAZY before transferring to guest
Date: Fri, 17 Oct 2025 16:50:46 +0200
Message-ID: <20251017145204.510871335@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0ebac01a00be972020c002a7fe0bb6b6fca8410f ]

Check for NEED_RESCHED_LAZY, not just NEED_RESCHED, prior to transferring
control to a guest.  Failure to check for lazy resched can unnecessarily
delay rescheduling until the next tick when using a lazy preemption model.

Note, ideally both the checking and processing of TIF bits would be handled
in common code, to avoid having to keep three separate paths synchronized,
but defer such cleanups to the future to keep the fix as standalone as
possible.

Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: Mukesh R <mrathor@linux.microsoft.com>
Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_common.c    | 2 +-
 drivers/hv/mshv_root_main.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
index 6f227a8a5af71..eb3df3e296bbe 100644
--- a/drivers/hv/mshv_common.c
+++ b/drivers/hv/mshv_common.c
@@ -151,7 +151,7 @@ int mshv_do_pre_guest_mode_work(ulong th_flags)
 	if (th_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		return -EINTR;
 
-	if (th_flags & _TIF_NEED_RESCHED)
+	if (th_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY))
 		schedule();
 
 	if (th_flags & _TIF_NOTIFY_RESUME)
diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 72df774e410ab..cad09ff5f94dc 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -490,7 +490,8 @@ mshv_vp_wait_for_hv_kick(struct mshv_vp *vp)
 static int mshv_pre_guest_mode_work(struct mshv_vp *vp)
 {
 	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
-				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
+				 _TIF_NEED_RESCHED  | _TIF_NEED_RESCHED_LAZY |
+				 _TIF_NOTIFY_RESUME;
 	ulong th_flags;
 
 	th_flags = read_thread_flags();
-- 
2.51.0



