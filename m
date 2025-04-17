Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5BB256C6B;
	Thu, 17 Apr 2025 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915864; cv=none; b=QmEmP6DtfGSq26EOR0IYxVeZUIuUupE9NbznlxqFOO5wxECRPmwd4+QcIFh38LWMmU6F8ADcLm/+iYd7hZs/UznW5GBBoDJmbGc3IGh3o6f9liX7/1NL6KgNyCHAD/7AtJqRJL+L0EzGv2hQoJdbzYNf95vSRDEnTPWOqVMBS0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915864; c=relaxed/simple;
	bh=8wJLSpUt1gpba3YERZywm17VTfK6RBolu8wnMV4ttt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXXShoiMrQrxo9uOAsrU8Vmu29g1RUCWTU8rfGT02okluITXAw9VPTRoIuqQKPbhXc05gJumjKiOmBUlA4zbtGXmgRP9JMWNb0rqq5Wm4RhhfIs+TCupTMmdeIu9qYNFnuJYcwJtUcBPJ296Alp95UBTYIXqeSNZGhzQfrSVQJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVH0BzxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVH0BzxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBC5C4CEE7;
	Thu, 17 Apr 2025 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915864;
	bh=8wJLSpUt1gpba3YERZywm17VTfK6RBolu8wnMV4ttt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVH0BzxGHWa5H74YTFiZ6AySxc8aorFKx/PkVm4Klw+SLEMyoyWWQYv223rc/JXin
	 9VkKmaTwrhxPoICV4kW+loZNq97CTWrT7nY9qInWibXgZBF8Z38UZtRdzSIxyjocM2
	 nFVGslsCmkrZti/au8z8cGK9C512ZlFHHnZYLzLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>
Subject: [PATCH 6.12 265/393] svcrdma: do not unregister device for listeners
Date: Thu, 17 Apr 2025 19:51:14 +0200
Message-ID: <20250417175118.263752144@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 750037aa0a9f28d84df3dcf319a28423d69092fd upstream.

On an rdma-capable machine, a start/stop/start and then on a stop of
a knfsd server would lead kref underflow warning because svc_rdma_free
would indiscriminately unregister the rdma device but a listening
transport never calls the rdma_rn_register() thus leading to kref
going down to 0 on the 1st stop of the server and on the 2nd stop
it leads to a problem.

Suggested-by: Chuck Lever <chuck.lever@oracle.com>
Fixes: c4de97f7c454 ("svcrdma: Handle device removal outside of the CM event handler")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index c3fbf0779d4a..aca8bdf65d72 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -621,7 +621,8 @@ static void __svc_rdma_free(struct work_struct *work)
 	/* Destroy the CM ID */
 	rdma_destroy_id(rdma->sc_cm_id);
 
-	rpcrdma_rn_unregister(device, &rdma->sc_rn);
+	if (!test_bit(XPT_LISTENER, &rdma->sc_xprt.xpt_flags))
+		rpcrdma_rn_unregister(device, &rdma->sc_rn);
 	kfree(rdma);
 }
 
-- 
2.49.0



