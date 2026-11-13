Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591313;
	b=GePp24hhTpb/RVJBXfrsTKrOP2ljQdhQRrvOwXDL4x+hjYa9UD7j0aJudlGTFe9FJ9Qs
	 0PihIJrA7NuuQjmLnoj6DHg2RcXtbpW2JzNJWbp26y0QLOHqZT2aGZDiZObcGKr0l13Rf
	 FRq6GU62UTvM8HTGeQQ189J/MZzmuPbbmdxSMjkRLvY7SV6nR7RWE+pQlO9bh9YwcGLsT
	 Fyuq8y8bmZhQlwU0Up+vNyxr8vzMSQGWQLpCSsDmmnq4/DvZU7I7dDhGNPbd2EvErVhQp
	 6fEF5pyRV5Oh5Y+9rKAVtgBM1MJDgAaNQWYrnjy9xhgtR8hMRFfyA/Rmhj0ujLCDe4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FFIe0GSto6aeWXGqQuYGZJVoNm5DaD4mpVI8o+uJBjE=;
	b=A1IXKKEWRw3+8gsvNjipiNp/TZdIwlnmNLSi1+NOuqtM1iHjr7BI5C9EtCpDCjslRhmS
	 bSCCZML7JEo66i0+vQfi8AnYpIhtCO52IlLk0+At2zKB8/AM+LvrLPtRV1tJ2tYbTfhxo
	 PgTbDXe9pJDimgh4Tx6fJaLTH+c75hJjl/lu2UYiS4ZQiNW+0hpiRfmJFSPmFPekj/BLI
	 eKo9nAA0GImfNrkC2JSvXW/pUPl5+MR1GptfapuHsjkuCEvF9cx+lKu+wbFmY/w+5w3L6
	 DtTn0TxIb991qwO2I5hLwOvmnUt+VbuDXn8swldygH/txeHad5mhTWcWoFQxeBczRDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CP+uwHSn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F627606B213;
	Fri, 13 Nov 2026 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CP+uwHSn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B44A1F000C4;
	Fri, 13 Nov 2026 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591313;
	bh=FFIe0GSto6aeWXGqQuYGZJVoNm5DaD4mpVI8o+uJBjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CP+uwHSnoQLvAdC0az7aSuRfhziEGnIIba+Kx3POc+McpKgNxrUW/pC8xlUQCMcEf
	 nIhCS1dk6ygcYsnVHiaIrItYl7vLMz8iI19s011gBQYPT9eG43O4Rt5otTyaM9XRBW
	 s5pM5SqE2dueMewL3R6tqNb9LomYmg743Rhj2u78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 386/670] nvme: wait for SRCU readers before splicing the namespace list
Date: Fri, 13 Nov 2026 10:49:10 -0500
Message-ID: <20261113153824.846434224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 8a0449832b50cd4f99f2d2952cfc1476e5f26d0f ]

Readers walk ctrl->namespaces under ctrl->srcu, and some of them sleep
there, e.g. nvme_wait_freeze() waiting for I/O to drain.

nvme_remove_namespaces() moves the list onto its on-stack ns_list with
list_splice_init_rcu(), which only waits for RCU readers before
relinking the entries. A reader still on the last namespace then follows
its next pointer to ns_list instead of ctrl->namespaces and treats the
stack as a namespace. Deleting a controller while a Format NVM
passthrough waits for a delayed read on the last namespace gives:

  BUG: KASAN: stack-out-of-bounds in nvme_wait_freeze+0x102/0x120
  Read of size 8 at addr ff110001d2f3fc38 by task nvme/4413
  Call Trace:
   nvme_wait_freeze
   nvme_passthru_start
   nvme_submit_user_cmd
   nvme_user_cmd
   nvme_dev_ioctl
  BUG: unable to handle page fault for address: ffffffff8af04850

Use list_splice_init_srcu() instead, which waits for the SRCU readers.
This also takes the RCU grace period out of every controller deletion.
Deleting 64 tcp controllers with one namespace each, median of 3 runs on
each of two boots per kernel:

                                      before        after
  nvme disconnect-all (ms)            3491 / 3509   2996 / 3165
  nvme_remove_namespaces() avg (ms)   39.0 / 40.5   31.9 / 34.7

Fixes: be647e2c76b2 ("nvme: use srcu for iterating namespace list")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index cf79a6c45ccd3..37dc942af0d20 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4375,9 +4375,8 @@ void nvme_remove_namespaces(struct nvme_ctrl *ctrl)
 	nvme_change_ctrl_state(ctrl, NVME_CTRL_DELETING_NOIO);
 
 	mutex_lock(&ctrl->namespaces_lock);
-	list_splice_init_rcu(&ctrl->namespaces, &ns_list, synchronize_rcu);
+	list_splice_init_srcu(&ctrl->namespaces, &ns_list, &ctrl->srcu);
 	mutex_unlock(&ctrl->namespaces_lock);
-	synchronize_srcu(&ctrl->srcu);
 
 	list_for_each_entry_safe(ns, next, &ns_list, list)
 		nvme_ns_remove(ns);
-- 
2.53.0



