Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC728449B22;
	Thu, 30 Jul 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427418; cv=none; b=dVvkJ5f56frwrhLcmZAUyPLmcKH49hoGvF4VDagvWDmn6tW1MAD7o526Yp/gqr/64AWf36ryt9ql3rZcBgoDxvNs/wFxynB/Dnis47YjeaiChYjMCV5NgFrReyh6A+oM+4ypeGGNmcXYcYfwOQJuLj7c6E4Kx2LZI4l2O+U33cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427418; c=relaxed/simple;
	bh=CbNcEzpXzE56F8IHtupQwVWZD/hy+hD/pkfQb2cM1zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7svX3HSD57Nm6TnD1XMux5bmdTFZG70vCQPouy3xWOipiq/fuv2VRPmyVTrqtFqE0dEXCqnvUyrWOJZLh/9lXglvRKiq1phUf+iciYDV9JSCWVv53UWVlm1QFfofKbmuW/KDnOrHnNIVyQZYXlQX2b0LbX+m8PMmlb8mlrXdeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVZHvrWw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVZHvrWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480DE1F000E9;
	Thu, 30 Jul 2026 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427416;
	bh=KOFqstFnC2zUrB1Ewn4SnupyhswEdqHX/LCbU4BMcwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVZHvrWwU7CPJOvOhsWT5QTgEIRvXrkSM5kXrodj374LQGtzs2jvDg0mVmkpIkBQi
	 S5SPuedn4D9vzJTMVgog4DUeWVbx4fhcRaDFOi9cARo33pCN2ELizRE9W8CzwI0Mj9
	 Dwt+Rh9Cz+iFYI/JRpK3ghpl0vRViWfYAsI0VFHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/484] pds_core: yield the CPU while waiting for the adminq to drain
Date: Thu, 30 Jul 2026 16:10:59 +0200
Message-ID: <20260730141426.986455703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit a11f0b8a204296fe7db9eaec53441012222cb004 ]

pdsc_adminq_wait_and_dec_once_unused() busy-waits for adminq_refcnt to
drop to one:

	while (!refcount_dec_if_one(&pdsc->adminq_refcnt))
		cpu_relax();

The refcount is held by pdsc_adminq_post() for the duration of an
in-flight command, which can wait up to devcmd_timeout seconds
(PDS_CORE_DEVCMD_TIMEOUT is 5) for the hardware to complete. cpu_relax()
is not a reschedule point, so on a non-preemptible kernel this loop can
spin on the CPU for several seconds, starving other tasks on that core.

Add cond_resched() to the loop so the waiter yields to other runnable
tasks while it polls, keeping cpu_relax() as the busy-wait hint between
checks.

Fixes: 7e82a8745b95 ("pds_core: Prevent race issues involving the adminq")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260629200358.2626129-1-nikhil.rao%40amd.com?part=2
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260714201456.1776153-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index c2ef55cff6b3ec..cd0c698983debe 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -526,6 +526,7 @@ static void pdsc_adminq_wait_and_dec_once_unused(struct pdsc *pdsc)
 		dev_dbg_ratelimited(pdsc->dev, "%s: adminq in use\n",
 				    __func__);
 		cpu_relax();
+		cond_resched();
 	}
 }
 
-- 
2.53.0



