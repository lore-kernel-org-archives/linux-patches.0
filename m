Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7454D1774B;
	Thu, 18 Jan 2024 10:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575463; cv=none; b=glWuvzqDumY+mJccl9NRMFc5R58GNU+oH2ay3bcU7wdsPwTN2W4LJxBCpTzDTJhJLvPAiyMXHiPeH6YnP2DDaStaMX0Z/3SjHTAMXWRM/R7T5eIqz9+61faTBnhR84bViIhY5kA2bC1aCLKF66mvg4env1qJwitcekAGTN0KOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575463; c=relaxed/simple;
	bh=lkvr24GCnYnwcfX2lw4pV4bexaaGi4tRHwt9gzNk60A=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=uCdu5eN/Kf6StKo0Zox7XwKwcReB6jSAKCRC+tQhxXFOSiAThe9Cdhn0WmIA3CxzjPXG7qN+SOZirJ2eVe97b2KUGcy4C8nhSY3DehNA9jToUTqkRijfEOPHg4VQAljr8c5sCd923pTkOQMk1eYPvYQAN37yovwul9N8PENP+0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNyHJINv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNyHJINv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9622C43390;
	Thu, 18 Jan 2024 10:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575463;
	bh=lkvr24GCnYnwcfX2lw4pV4bexaaGi4tRHwt9gzNk60A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNyHJINv7VKoIerIm1XTOR4e6hOdw9SC8P+CqsbOp9saL4UNPgWAE1Yhm5kYCilAC
	 EAxe128e0UJeHWAM81fHQ0Pu9oinNwMn7NQPtZXUfhlNwKYFk9XPFJzXxmH3frfNkG
	 30FWEqFPIJtqh29EVps+qNQwXV6CZfjcWcBgFXxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangkeqi <wangkeqiwang@didiglobal.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/150] connector: Fix proc_event_num_listeners count not cleared
Date: Thu, 18 Jan 2024 11:49:06 +0100
Message-ID: <20240118104325.783900958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangkeqi <wangkeqiwang@didiglobal.com>

[ Upstream commit c46bfba1337d301661dbb23cfd905d4cb51f27ca ]

When we register a cn_proc listening event, the proc_event_num_listener
variable will be incremented by one, but if PROC_CN_MCAST_IGNORE is
not called, the count will not decrease.
This will cause the proc_*_connector function to take the wrong path.
It will reappear when the forkstat tool exits via ctrl + c.
We solve this problem by determining whether
there are still listeners to clear proc_event_num_listener.

Signed-off-by: wangkeqi <wangkeqiwang@didiglobal.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/connector/cn_proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 44b19e696176..3d5e6d705fc6 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -108,8 +108,9 @@ static inline void send_msg(struct cn_msg *msg)
 		filter_data[1] = 0;
 	}
 
-	cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
-			     cn_filter, (void *)filter_data);
+	if (cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
+			     cn_filter, (void *)filter_data) == -ESRCH)
+		atomic_set(&proc_event_num_listeners, 0);
 
 	local_unlock(&local_event.lock);
 }
-- 
2.43.0



