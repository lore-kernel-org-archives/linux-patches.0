Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214402;
	b=Pvg7Ai65XbMcKSRfUzbBo3cgwhd37A2QT+V3rpIQDvlLQqEIYKJn0CqwJKrYwEpZRYmt
	 fZhIb2fw1N8lCV/Xa51ovH63MUeEZUFyufNHDQAZDnSD5WF6PNRDOeyJGlp6TSPSYIyyD
	 2E8F7hNNxLipkHjG+qXG3DL9DaofokwtzU8Z7oUEgC4gSeqRQ1qHtCudKfTgBvrfGqVFW
	 362grbmB1ndMhhyxW8ueemCv3GG8+uD81tVwbqvbffnquiJunK+QZ5c4qodRkQMOnQYtb
	 ceGj2okjbxF4QJvqovTI/qG375BT0xDQoQhs7CY1yvcjn3Xbotb2J86PrP6dVa80VyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=58yXjIduS3SbjgT8sEcCrSdeiI+sjIjukacSKjJy52A=;
	b=Zd+IExAzmiG598TA1BLTRdB5XSCipoqNwTXk3lkdUdXp1l2vCgR7nN3crqRFjUYmN5FJ
	 HjqY/2SgerR7/jvmdnu11wegxr3CyEpphYhfEX/tlAPnkc5qUi3CzS5ddXeqAzqpPXk88
	 fDRaMSZetdP8nHeMMue1efgklAJQbTpam4fA48wLQ68GTXZ4ADuLO/JtBA1BWyrz4V4m3
	 axbSeT7wKtS+NS7/bzd0XDHgCL4uDY3j4ZUDS/mdhrkBEdKeGJ0nwqzb/G5MQ4wF2RGy3
	 9CHFytVHVmVhNGbx694KBYW53wcUsrLY5w5JuiDz/T3Wgtu2WCq1x+wHxidh/JA/D8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRSQigbV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C3B606A324;
	Wed, 28 Oct 2026 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRSQigbV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13901F01825;
	Wed, 28 Oct 2026 19:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214402;
	bh=58yXjIduS3SbjgT8sEcCrSdeiI+sjIjukacSKjJy52A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRSQigbVLanwSQg+HwTF0hed5g2JwN1Sju3dzdvUkRhXsL4B089EM8B/jKpssGQN9
	 8OpJ3gGq1J1SPtxWdLLVkd5tNHCf+7iaVROfqItr044ysIUBHN1BUa7KUSLpYpJPKF
	 C1MCCBqOJcYD1U49hFqRCX/l+fm2xeT89O0v9xjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0845/1887] ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog
Date: Wed, 28 Oct 2026 17:49:01 +0100
Message-ID: <20261028170518.656589586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f2332b954bcf0..0661e1e2dca1f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3673,8 +3673,7 @@ ptp_ocp_detach(struct ptp_ocp *bp)
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



