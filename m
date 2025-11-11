Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7644086A;
	Tue, 11 Nov 2025 00:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822451; cv=none; b=CLrS5PoMIovVBZf8706NOzrXMyO3wu8jHztZhQhlyhOHurqNrND6QLQZR8rbq8sUovaiOdaA6IHT6lenovG2et4ywH8yzYJ16rZAwaFjfcUG2zxDXbOl4LQjq3Ox03UWRqfmMUURQxsn2l6X7g/8H4qNruKN5G8yvvdOqgGER+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822451; c=relaxed/simple;
	bh=T8mdGEQsl/CxE2+heU2/k3zqDjt7mpgDrU0zoEMIX5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j63UFkrw044RBiJLT+mBj2/LtObigZOsKgL05PFbHoHQn8OOPIoGiGun3tmwl9qR8LY2FIaIL0rRLHw/n+KMbsBX6ZUIaODBAphtcK5e/UBzCSr6YxUYBgaVI796Pn9b2L8XGIady5Ctc+4t03tp4aBQEcO2QovVfqOBRtjHhsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfKtPQKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfKtPQKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11881C19421;
	Tue, 11 Nov 2025 00:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822451;
	bh=T8mdGEQsl/CxE2+heU2/k3zqDjt7mpgDrU0zoEMIX5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfKtPQKRv96plkh0xsnL6b00wIREEyaBNw6Lp1K7JEuJ9AEoSGSd7PXtvIFTP5v6N
	 ec4XSTdMZSBtiYPvOqAls9wqcdaBS4NmOj9hunhxlWik4IXZ05+lnH1s+1kXKRcmfT
	 h4k4fXLzZakp3ES1bF3ALM1LR56Ybg5I46uVxHv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 110/849] mptcp: leverage skb deferral free
Date: Tue, 11 Nov 2025 09:34:40 +0900
Message-ID: <20251111004539.054173046@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9aa59323f2709370cb4f01acbba599a9167f317b ]

Usage of the skb deferral API is straight-forward; with multiple
subflows actives this allow moving part of the received application
load into multiple CPUs.

Also fix a typo in the related comment.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250927-net-next-mptcp-rcv-path-imp-v1-1-5da266aa9c1a@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e04ce45a8db ("mptcp: fix MSG_PEEK stream corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1934,12 +1934,13 @@ static int __mptcp_recvmsg_mskq(struct s
 		}
 
 		if (!(flags & MSG_PEEK)) {
-			/* avoid the indirect call, we know the destructor is sock_wfree */
+			/* avoid the indirect call, we know the destructor is sock_rfree */
 			skb->destructor = NULL;
+			skb->sk = NULL;
 			atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 			sk_mem_uncharge(sk, skb->truesize);
 			__skb_unlink(skb, &sk->sk_receive_queue);
-			__kfree_skb(skb);
+			skb_attempt_defer_free(skb);
 			msk->bytes_consumed += count;
 		}
 


