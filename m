Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361F917BED0;
	Sat, 17 Oct 2026 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253445; cv=none; b=KsMtUdJ92fVIvHszcPXALDTV+3IdswoCDwdeLDGMkimB1yxPgNF6rJYnZ3p8H11vdW7ICBDFxZHlVchOdpEs9WcUDxJ/6ozyf1oLafydp6jMHHJYgtrgxtfepp7rj57B2jNk7wI0e3e07PyLVKglATig357veKBEuMT7qWqxRLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253445; c=relaxed/simple;
	bh=6+r9DmRGqh9s7KqPzvcUQ1o8SwzJImRs3F3cLC+GZSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTzh+fDDHTWbD7GqLB/PMa3dOjF9pDUAKukGAkQsHxEfV3k/uMqPo+OwkXal/QwiBTa+RS0Is9PdcTzAPjfz2RgfvSq7MGMsw8zF4QBUzQ8LV/jJgNb+b8ydzUC14IUa6hWcL+5ULLLyeyCEVdhqL9II2Z68B0vw/tcCaHFW5SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/rp9q7V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/rp9q7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D2D1F000C4;
	Sat, 17 Oct 2026 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253444;
	bh=kU8K3hsz0JXzBzb09ZOOnXd2sAwj71c3jCEVaigGh0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/rp9q7V0M5gqvNRoNvoTqzOljPuhNsgYZHSqDnulO7HaDmCYqtX9U3GQvdBwO04A
	 4IEcdDOIKLnqThCQhmL5QWMe/f/2el0dKhECcLJuO/naMJsz0zxaYbJ+/ate8xwq6n
	 N7Er9Wrxrm0NVSsyJtEklhpWDp8+czkynryNLcvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/869] ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog
Date: Sat, 17 Oct 2026 17:49:22 +0200
Message-ID: <20261017160040.143625403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 42263c68d5e0d..e4187eb6fd775 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4558,8 +4558,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 	ptp_ocp_debugfs_remove_device(bp);
 	ptp_ocp_detach_sysfs(bp);
 	ptp_ocp_attr_group_del(bp);
-	if (timer_pending(&bp->watchdog))
-		del_timer_sync(&bp->watchdog);
+	timer_delete_sync(&bp->watchdog);
 	if (bp->ts0)
 		ptp_ocp_unregister_ext(bp->ts0);
 	if (bp->ts1)
-- 
2.53.0



