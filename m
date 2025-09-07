Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629D31A704B;
	Sun,  7 Sep 2025 20:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277565; cv=none; b=GjVm6CQBAXQuXRHLrV9drHFNxgiJe/pBpxhoMJuD7oAx9UZImArSXsABXp9+9mzmK3fMXpkTKYovudRiz7U0h8nxKI8Frv5YPLKax8/CyHf/1/mT5+H9eFu49LtYhgK9xkML+zUHoyUlcc2/4wGYeokNbjcHQOydDxCCwIDWg/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277565; c=relaxed/simple;
	bh=axC/F45ahh3oD8oTV9FRhyFIaEnQULqNp4/oSMF5j/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbtZif0ehr32cs3Lma1Q4jR1iO4QQIkfhzhp4h8Vs2DgtSv4PKXNpQGhi3bFz05xTWx8nQoOl0URu3zJBTbdcEY1N2C/r0DlfEn8KWivGkeydRcz/K94kJQfVEZVwXqJ0F+BELIXqgB+QjzqpIFau2rLMcLQD+INTfDXttA3ReA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSX8WYoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSX8WYoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9094BC4CEF0;
	Sun,  7 Sep 2025 20:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277565;
	bh=axC/F45ahh3oD8oTV9FRhyFIaEnQULqNp4/oSMF5j/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSX8WYoOp6wmmvBAPd+2IfR4YDFne0yFJ04Cb5g5NoXSxMZieQK51kYEoRCcTTHVx
	 yn4X89Xz+bA8teceupDgdDDvhnd6KBVt5J99r/cUCdmb/b38r3DaH4Wj5wFBFAit1E
	 9P44o1W/v8kAFte2YIgF7eP2xTnbSIvCpM6gNCmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 053/183] ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog
Date: Sun,  7 Sep 2025 21:58:00 +0200
Message-ID: <20250907195617.044198623@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 8bf935cf789872350b04c1a6468b0a509f67afb2 ]

The ptp_ocp_detach() only shuts down the watchdog timer if it is
pending. However, if the timer handler is already running, the
timer_delete_sync() is not called. This leads to race conditions
where the devlink that contains the ptp_ocp is deallocated while
the timer handler is still accessing it, resulting in use-after-free
bugs. The following details one of the race scenarios.

(thread 1)                           | (thread 2)
ptp_ocp_remove()                     |
  ptp_ocp_detach()                   | ptp_ocp_watchdog()
    if (timer_pending(&bp->watchdog))|   bp = timer_container_of()
      timer_delete_sync()            |
                                     |
  devlink_free(devlink) //free       |
                                     |   bp-> //use

Resolve this by unconditionally calling timer_delete_sync() to ensure
the timer is reliably deactivated, preventing any access after free.

Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250828082949.28189-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 1e7f72e575576..5388285475952 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4557,8 +4557,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
 	ptp_ocp_attr_group_del(bp);
-	if (timer_pending(&bp->watchdog))
-		timer_delete_sync(&bp->watchdog);
+	timer_delete_sync(&bp->watchdog);
 	if (bp->ts0)
 		ptp_ocp_unregister_ext(bp->ts0);
 	if (bp->ts1)
-- 
2.50.1



