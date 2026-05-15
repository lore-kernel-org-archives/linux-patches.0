Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C33FD964;
	Fri, 15 May 2026 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861133; cv=none; b=G9SKP9oUZ5zk9AceSBAREJ/grKsUIm4PZpM30sHMyCodNnbizS7SdsS44cpC4rgKSw1Z/7syWCZjKS4QW7cxhhKqNh8vk9BpAV757tfN+4vvspcXOg+8aSeESeMSMwPCEDmYqesMSkZ7sQl43Fzfj5gWWXon7txwJ2wvz/gwIBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861133; c=relaxed/simple;
	bh=xLdNZyVdFvI736VmJ4XhMgStWX/vqV6EwZVr/5mQIqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgZ8NdVdRAM1wU6jFPWKgJ0pJa4BBDMT4NYhlqcPtm3dT+7Z0bmw9iVBH8bXrGEFPgA3j8wAshOSbnCSZGDc5Y1vUH4wHQojxTMoNjJNnm3JYCoRzFyJ+3RTweiUyv3P+oE+4ZtELU+6Oycraltc8vYJrkP2Y2B56UKdqXYkbBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqLfKpKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqLfKpKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7B6C2BCB0;
	Fri, 15 May 2026 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861132;
	bh=xLdNZyVdFvI736VmJ4XhMgStWX/vqV6EwZVr/5mQIqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqLfKpKLXWfu1T7fY3v18mK0A+xN+7qO/ske36qYjZJtHyoyAxh3uo2OKO/pt8EKR
	 wyor+LGVZzK4HFuH+/cw7vrz+ZZWsn5hB22uLEfgHC57opKoC09kKs61lIgfXUEeKd
	 IeQvYJbTzZbn4YB2ypqpKlDKYMpEQ3S0ZX6c+eaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 212/474] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()
Date: Fri, 15 May 2026 17:45:21 +0200
Message-ID: <20260515154719.597712478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 2ff1a41a912de8517b4482e946dd951b7d80edbf upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 89bc500e41fc ("Bluetooth: Add state tracking to struct l2cap_chan")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1627,6 +1627,9 @@ static void l2cap_sock_state_change_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	sk->sk_state = state;
 
 	if (err)


