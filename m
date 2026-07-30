Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B12388E49;
	Thu, 30 Jul 2026 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427368; cv=none; b=kPDXFTJc79bk1lRNUcqEXgB4yQerX43IifwKo3Q8sFrGtZPvdBz3OKHo5BKF7ELuNswfXnXL0nKXx72YjyInRa75kaQ9p+8GJMZy2ZmIRormeF4ImEDq02xOD28U8x3ekVwitphT5uOldjeTVgL4k3vA2T5A5DVfUAgW2HyWV2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427368; c=relaxed/simple;
	bh=DC3PuJ9o+A76ZWhdmDr+0vKGkCYShN6/ofFYtru8bwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV9zK8RUC1ZdVmKqXL6J50fQ87puXBrZzJ0KovzllVRKWzg1KYOZmvrw5J2CziivZa2HgN5v1QWubfX6yVnSOzjjEz0Up6qnlewuaXnTXJKcW7z72wukDHzCPu89+rwew17P2QDiNC/8O+In3ylBjVZKJAtaPuM3Fn+Z7RMaEFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkxnxOVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkxnxOVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728F01F000E9;
	Thu, 30 Jul 2026 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427366;
	bh=M75MvmMTW0ZArD9FkCtHyu0FqD1Z9s1muYiLjVtj1Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xkxnxOVxB+/hESNpASxb2Rl6WeCIKc6krvxXCBFLaMET1XeqPqJogEr7vUOxjyrDX
	 ZaFvhXn6R6bwPkvJAScx1Bw7Icy12jlip3UELRxaexowpO+w1mKdxHKgor6u5JjdIs
	 8jx2VdpyutF5BM3Wd5CuZHAKJlKUwttc47WWO3dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/484] net/packet: avoid fanout hook re-registration after unregister
Date: Thu, 30 Jul 2026 16:10:43 +0200
Message-ID: <20260730141426.634389083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 50aff80475abd3533eef4320477037e6fcc6b56e ]

packet_set_ring() temporarily detaches a socket from packet delivery while
reconfiguring its ring. It records the previous running state, clears
po->num, unregisters the protocol hook when needed, drops po->bind_lock,
and later restores po->num and re-registers the hook from the saved
was_running value.

That unlocked window can race with NETDEV_UNREGISTER. The notifier can
observe the socket as not running, skip __unregister_prot_hook(), and
invalidate the per-socket binding by setting po->ifindex to -1 and clearing
po->prot_hook.dev. A one-member fanout group can still retain its shared
fanout hook device pointer. When packet_set_ring() resumes, re-registering
solely from the stale was_running state can re-add the fanout hook after
the device has been unregistered.

Treat po->ifindex == -1 as an invalidated binding after reacquiring
po->bind_lock. This is distinct from ifindex 0, the normal
unbound/wildcard state: ifindex -1 marks an existing device binding that
was invalidated when the device was unregistered. Restore po->num as
before, but do not re-register the hook if device unregister already
detached the socket.

Fixes: dc99f600698d ("packet: Add fanout support.")
Link: https://lore.kernel.org/netdev/20260701113947.23180-1-david.lee@trailofbits.com/
Signed-off-by: David Lee <david.lee@trailofbits.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260707104440.833129-1-david.lee@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1de0ef429f9310..d435a48bc0e3b7 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4608,7 +4608,11 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	spin_lock(&po->bind_lock);
 	WRITE_ONCE(po->num, num);
-	if (was_running)
+	/*
+	 * NETDEV_UNREGISTER may have invalidated the binding while bind_lock
+	 * was dropped above.  Do not re-add a fanout hook to a dead device.
+	 */
+	if (was_running && READ_ONCE(po->ifindex) != -1)
 		register_prot_hook(sk);
 
 	spin_unlock(&po->bind_lock);
-- 
2.53.0



