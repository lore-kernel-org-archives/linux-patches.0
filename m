Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03F1E7C2D;
	Wed, 17 Sep 2025 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112706; cv=none; b=V2iViAOG1aN9A8B87cbgfKRBZBcbi29ZC2T73RJDMFtpuGPgQbsaTeofGYyJm9wiUcoo2y66hr0zLGlS4ivfTfVbjih9IuSZPZHagrw+4SdUMMyO6xi/dLprsLQ6zhpepBS9yoP76iv4mT77axknFJXd7tMNIUo5SvbXMg0i5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112706; c=relaxed/simple;
	bh=MVpJZQBZlKwa3vNuaA8XU7KjGEFYfckIjE0uPmwZxvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAOweQqiFUij/pUibVnzSvGwS5ZjPdmHh0By8zUFcF/PFnaPSs+XIcYiXstMwBrmOb1l9Bh2U0wWHrK6/7VH6EiFMSGifdp7GP32YqF8Uu2rgbihbagBvreYZNykPLn91ClgJsIgzYkP8Un6tznyQMQ4GNwtD6jwQuUUIRhuxLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvVYV4CS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvVYV4CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F628C4CEF0;
	Wed, 17 Sep 2025 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112706;
	bh=MVpJZQBZlKwa3vNuaA8XU7KjGEFYfckIjE0uPmwZxvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvVYV4CSI7So23vQIzb/CskzDMxJTPLiWOQdUvJiOZECQoR9iEtAbEkVh5Wlm2PMI
	 dVT4I/Kh8fvjs8kK2xp1oLySABd1DvIdv7vKGVIa5yvGyiDt3g8sT9YXzfVtigmv2c
	 vl52BBkQ5wz+3WSRIkMg63Cl8Kc6GdmFi9E9zMAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.16 050/189] Revert "SUNRPC: Dont allow waiting for exiting tasks"
Date: Wed, 17 Sep 2025 14:32:40 +0200
Message-ID: <20250917123353.086762015@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 199cd9e8d14bc14bdbd1fa3031ce26dac9781507 upstream.

This reverts commit 14e41b16e8cb677bb440dca2edba8b041646c742.

This patch breaks the LTP acct02 test, so let's revert and look for a
better solution.

Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Link: https://lore.kernel.org/linux-nfs/7d4d57b0-39a3-49f1-8ada-60364743e3b4@sirena.org.uk/
Cc: stable@vger.kernel.org # 6.15.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sched.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -276,8 +276,6 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue
 
 static int rpc_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
-	if (unlikely(current->flags & PF_EXITING))
-		return -EINTR;
 	schedule();
 	if (signal_pending_state(mode, current))
 		return -ERESTARTSYS;


