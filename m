Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040394;
	b=qsiAcn4Hu7dUBTRpR/Z+8HwYQmWbeMA0dNTMUKyMQCCYjiP6EyKK3KnII2AVdq+cbNRQ
	 GQd7rxK8oiohxF7SZZzsO/v1yfqNiuUH3idfuA4tckGZujJSkIQhRu/lrX4My1AyUkoUR
	 cYDWFD+LDYuYaOaAow1OZT0dBdCCQ+dZjEthKWXqS8fnrWcGJuvZXseXPlFPp6aWaXLlM
	 R7J7+NIVESzZQlj1sIoP51/QnMlRWE1Qc2Lrt+LI49Rn8IoPmHmpM2VseUhbnfLXl86PT
	 ObkiBQau1Jhu3uiWI3FDmXNmnQGhEqYKQmCjDUrs+NwOK+sUKwVmDpWNFSaQYAdUaaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUvRytxVQyLs0XeGXmTpJLFaF8ht1d5LK6gAk26Uszo=;
	b=251/vXgg7KAR0r3TL9dhwJUxyZecBwd0ew3fThu9BOUgbUvWa86S9S1OtisLxV5whY3n
	 +WPDMzAzyTkdC42wwQXE6TWEk+f4+6MLXjo+fPP4F+ZLDbcxUfGLaI0F8RxHyj7/dCxTJ
	 L2TC0hx8PPDLobfVXYeE29XMLonNueBlIWYDb2rI2q8OpJdE9WzVObnazFob4kiWzleT0
	 jrVlrY7RADKKcYCALtMO+pro2UpXKdGCorqDEryczpCQVWb7HcI9fDsTO9X21LJsTKgB4
	 ocHFPidL6UIq33eGHLR3iuu/gzMiV+JqUqoLE3uV2ZE9aCcuSrgqyCKm3+AvWfgMhKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AzPRFjxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D9606A32A;
	Wed, 18 Nov 2026 22:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AzPRFjxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4181F000C5;
	Wed, 18 Nov 2026 22:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040394;
	bh=MUvRytxVQyLs0XeGXmTpJLFaF8ht1d5LK6gAk26Uszo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzPRFjxZ5IP8BfFqXTaITaC3fCGOT7EE7P0xq46iwKEpt/6y+/7SV+msTaSWxc6yc
	 IpyIjCcoRBzDx0wnK8I/atWLhnM0VZ6iDZN57jaJY/FyxyO0AxlvRE2T95cAm7b6T1
	 +3xJy0VxCl4A/g023IPI0gtnYDufc/UNWCXFRCeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2440/3318] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:51:02 +0100
Message-ID: <20261118150434.650767762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit d30e9b1bc47bd9be4b2fc97b0e4074bc02c4203a ]

isert_put_unsol_pending_cmds() declares drop_cmd_list as a static
LIST_HEAD, so the list is shared across all invocations of the function.
It is called from isert_wait_conn(), the per-connection .iscsit_wait_conn
transport callback, which runs independently for each connection during
teardown.

conn->cmd_lock only protects each connection's own conn_cmd_list, not the
shared drop_cmd_list.  If two connections tear down at the same time, both
threads list_move_tail() commands into the same drop_cmd_list without any
mutual exclusion, and then both iterate and list_del/put it concurrently.
This corrupts the linked list and can double-free iscsit_cmd structures.

Make drop_cmd_list a stack-local list, matching the pattern already used
in isert_free_np().

Fixes: 3e03c4b01da3 ("iser-target: Put the reference on commands waiting for unsol data")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260921031100.2199-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 22111700caa09..f553eb1def63d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2589,7 +2589,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsit_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



