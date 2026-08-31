Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE46A4A5EAF;
	Mon, 31 Aug 2026 13:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183868; cv=none; b=qWl7/2a+M/FR8c0vBu1wNoXqJi40UU9e1aFFZ/w9F6MsLT5keeCRmOIU+1w+u3xE9C1FptDEANc7v3PDMXaz/FiTnjd3xLS6oNa4CrwTozMF2iR0jSbuA3/HgKeOr7cYcQ++NM74fFENJa/j2dmDY66llvjRkYIfpfG2bZaaLhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183868; c=relaxed/simple;
	bh=nDyr1IIkIaI7tgB+sOoSdw4UO/ITkOsZvdO/r7fO8oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/9LUZfoA2q+3vPc6olHr0z2hljySKvPqqOsPYYy2iwLu2STW0itYqxONyCR4jCrbBYTpFcdVdFLTGRrplyafBU0OzXlR6CNIE6VNE1EyL5aDjpPwkY4B2HFcLL4X3GbEJly6xuNj0Nrk8ZR0KoDvKP/Np+7H9bc+NSaACkMAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q88JGtzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q88JGtzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B12E1F000E9;
	Mon, 31 Aug 2026 13:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183866;
	bh=Hy0vrqv8cjxsaEY46z5GX7wptc1BaccpsliuEU797qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q88JGtzraGj1+CAv1f4DZivp2SGpK2dNO8s3VGgPyk05boSV6Slx5Y2D7W/YYCjlc
	 5OhTXOfB/qYBUWipoQO250oTOgG5LECX23JKVSUsSjBD+BkuNRNVhtU7oVOvyg6oor
	 Vah7++mHLmqAAC6JJJSnRmoxmoJyr3LZS6m0TdZ2qse8IoNfXJBPRK24xOwwz5HKq5
	 PK79WFM7TwsCBj1bibt0B3Ko+xlrUotu0LGrWYcqJuDnhGDCjfXeSCJm2CCeP5Eo/6
	 hPfACAhRorEs1e0TbQXs/4LvC7f0DUKGJjhkoeOI7SGOJehoV7UeQgI96fAM0sT0k2
	 SgGqWsDQKRWQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raf Dickson <rafdog35@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	bryan-bt.tan@broadcom.com,
	vishnu.dasa@broadcom.com,
	linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] vsock: use sk_acceptq_is_full() helper in all transports
Date: Mon, 31 Aug 2026 09:26:18 -0400
Message-ID: <20260831133314.4125787-350-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raf Dickson <rafdog35@gmail.com>

[ Upstream commit 4ff2e84ff1b33d79fa0e3ae355ce4a334908ef9a ]

Replace the open-coded backlog check with sk_acceptq_is_full().
The helper uses > instead of >=, which is the correct comparison
per commit 64a146513f8f ("[NET]: Revert incorrect accept queue
backlog changes."), and adds READ_ONCE() for proper memory ordering.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Raf Dickson <rafdog35@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20260612045842.122207-1-rafdog35@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and match what the earlier analysis
already showed:

- **Commit hash search** (`git log --grep="use sk_acceptq_is_full"`): no
  matches. That patch is not in this v6.18.44 tree yet; the buggy `>=`
  checks are still in `hyperv_transport.c` and `vmci_transport.c`.
- **Author search** (Raf Dickson): only one vsock commit here —
  `ba9ad6015937a` (`vsock/vmci: fix sk_ack_backlog leak on failed
  handshake`). Nothing for the `sk_acceptq_is_full()` change.

That supports the **YES** backport verdict: the bug is present locally,
the fix is not, and it should apply cleanly as a 2-line change.

 net/vmw_vsock/hyperv_transport.c | 2 +-
 net/vmw_vsock/vmci_transport.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 4da752b47b116..54c7f51f9145d 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -323,7 +323,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		goto out;
 
 	if (conn_from_host) {
-		if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog)
+		if (sk_acceptq_is_full(sk))
 			goto out;
 
 		new = vsock_create_connected(sk);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 75bf643ff6faf..4f02a6f269cdb 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1002,7 +1002,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	 * reset.  Otherwise we create and initialize a child socket and reply
 	 * with a connection negotiation.
 	 */
-	if (sk->sk_ack_backlog >= sk->sk_max_ack_backlog) {
+	if (sk_acceptq_is_full(sk)) {
 		vmci_transport_reply_reset(pkt);
 		return -ECONNREFUSED;
 	}
-- 
2.53.0

