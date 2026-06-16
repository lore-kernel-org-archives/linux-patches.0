Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBE237DEBF;
	Tue, 16 Jun 2026 16:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626775; cv=none; b=suULlUf1dEVjTKg1pOSr64I0N1QfqgVjxdfpcCh0kJiaPYYegbzC84N8jKQGDz6vp5Ies86yyaIfdrm8Tjl7j7Ts2gvozSmpFzy+Wt5jrWHd1BRlgKUl5Zlhs8g4Fi2y8AWGh9h1hGptGf9d2GBrpcuH+KuprNKHDtGoUW4GbVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626775; c=relaxed/simple;
	bh=szNccRDhwiODn4yZh2rY4xfvgRQpV04U3ryPH4MgI5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA/6QznQ85JQ0KvplB4OOeeGpRHia23K/WzCEBQYSBwQwuIyCgoUYvg+lcLZjaoMlUY4wz2KpMdY+c04nhWFte5y/e6iStSTHgwrsQO9M/g02e3aDY2n/KLwX5apcNV/sirYIBECE+Fuanp7dPbPXZOPlIXlw+bKQ5l+lpoYFHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFeDzfYq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFeDzfYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A521F000E9;
	Tue, 16 Jun 2026 16:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626774;
	bh=qDDBZZaEy5g1WXiQIkdeB8AFL8WrHKPb6wXau1sbwqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFeDzfYqU5kqkoVl4j7JWg1YgyqpL8T20uGE/3z5h8oI7qtMfl2/bwbv6UtdVjTMp
	 8gPkBY/IL74q/4OR+D3f2GSXwNNi8HvW453uAJKiPlPUM3RDuPOEQkQPV7nnRFhfDL
	 95QPT7CTXE3XD53/t30vubv7FL5EB3qCdinl0jl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/261] ipmi: Fix rcu_read_unlock to srcu_read_unlock in handle_read_event_rsp
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145047.932122926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Rui Qi <qirui.001@bytedance.com>

Fix a bug where rcu_read_unlock() was used instead of srcu_read_unlock()
in handle_read_event_rsp() when ipmi_alloc_recv_msg() fails.

This mismatch leads to an SRCU read-side critical section imbalance: the
entry uses srcu_read_lock(&intf->users_srcu) but the error path
incorrectly calls rcu_read_unlock(), which is a no-op for SRCU and
leaves the SRCU lock held.

The offending code was restructured in mainline by commit 3be997d5a64a
("ipmi:msghandler: Remove srcu from the ipmi user structure"), which
replaced the SRCU locking with a mutex in this function, effectively
eliminating the mismatch. However, that commit is part of a larger
SRCU removal series that is not suitable for stable backport. This
minimal fix addresses the SRCU imbalance for 6.12 and earlier stable
branches that still carry the original locking scheme.

Fixes: e86ee2d44b44 ("ipmi: Rework locking and shutdown for hot remove")
Cc: stable@vger.kernel.org
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 188722ec0337b3..41ae4dac4eebad 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4395,7 +4395,7 @@ static int handle_read_event_rsp(struct ipmi_smi *intf,
 
 		recv_msg = ipmi_alloc_recv_msg(user);
 		if (IS_ERR(recv_msg)) {
-			rcu_read_unlock();
+			srcu_read_unlock(&intf->users_srcu, index);
 			list_for_each_entry_safe(recv_msg, recv_msg2, &msgs,
 						 link) {
 				list_del(&recv_msg->link);
-- 
2.53.0



