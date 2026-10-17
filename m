Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60996DCE1;
	Sat, 17 Oct 2026 17:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258140; cv=none; b=fSWOkQjRvenfhRKMVYCCuO9V1hkxMd1tZjBD583T21izD6B2cxsiSr0KyZIt/YNqBNE+rMKxL0sssz2PMvUwC2HBgucVcKk+P7yiZvV+SW2hHEyN/afHbskoOAnYxGgUKyTMW5/Eg8CcYtCPYnKyix2lScRb2v+Isj/1QIggbqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258140; c=relaxed/simple;
	bh=R9BZdrdQEgJf09dkmXU8Tdl5X9gQE0mEynPmwfq0BcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Uy/Rf3q07/j27cTqgir3Fd3OEv07xRBGzWACTZl0ScG5pLKbtfLP0X+BMD+5MonBkFG5Tjrc7uVMMQhlJENeotOmWJf4EWZRK/HW49hLhlOQvVf8eVP05amajxGuNLZAv5SrsBC4CTJMijXqLu7m62B6MAPNnmkfpCPWZcw4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2EjACN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2EjACN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3639C1F000C4;
	Sat, 17 Oct 2026 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258138;
	bh=oc065bserhJ3UHmr+Btm+kIf/QOgPBr9GT0499GYYro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2EjACN7SMxcMlM2e7Rzmt6vCptPs0xnEDIi70sezSAsV2DLPA8ZUmGttNMFgFLlq
	 f48YYvDdDsgrv00WB91PSsUKWccRaZRUlcIm+BQ1jggBWRD5Qr04PtTfWMMqvHZLwn
	 JJt4onYOpWFyEg+ZsgWFeRRRlGc/OoA22oXAhYsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0784/1674] ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog
Date: Sat, 17 Oct 2026 17:50:56 +0200
Message-ID: <20261017160451.228485545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index aa233a3010123..af4f6fc94ff4f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4143,8 +4143,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
 	ptp_ocp_attr_group_del(bp);
-	if (timer_pending(&bp->watchdog))
-		del_timer_sync(&bp->watchdog);
+	del_timer_sync(&bp->watchdog);
 	if (bp->ts0)
 		ptp_ocp_unregister_ext(bp->ts0);
 	if (bp->ts1)
-- 
2.53.0



