Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041972;
	b=et1RMVtQF4h7I9rpl+72GoD50lfB/MCIJEfnXc1lmLpbTEtDdQ157j5RE8FI8lMZv76M
	 aDsjzFvKH7qivcZzYowuDbFaCrye+1WOY7upI+7wMUrQIi8uYG4592JGeay9+g1Sk72HD
	 Jg7DeVX6HX1gYOPZpYdrJKUpIyWz+7kxx8hp2pf4rZJ0lbOMXB8vMwAvH2HQjMiT7ceY0
	 iSMcMhwiq6SOdsBVI+5A7vEML54AstmG9IsQKsRf8PG01rZuqCnoWHhxfCGEzRChozMJ1
	 NYXblgCfXQzAsL8fRXbE5yfDEy5plex2daSE7vah29vD0MjFjkP8ZG1AzfyhW/PewEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n/iqQLnW5xyZjHEfnOND3SgPNrc81AuSt/L6ZPMGQMQ=;
	b=Paz42ImpWZqDlNVY80Pt6DZpEvs+is9rFrITGgXCXVyHXIOx3x9f1vNQu0bdSnzcexhf
	 jRUP/Yc3SyIUDJtHfT7EOCoueXN/PxAXVGKD2qc0zRhWvD3W2a8mtMSVVosnQHbv8uVPA
	 SEl3lXnM6k0YzVsEolaO3sNv2zJwyBlxTtQ5OXj47HEA95gcrFHfbMc3m6nOf/RC/12rg
	 X2NVjEohgbyMcMmTbBxqOyZlKHQYesFN6Mj5Y8/g/08dZrGxQGNVEI1lDClOBiE1GULry
	 +oewIqqVlV9m1utGs2L8C2imBiIrdVuZHvHh/LAE3aP8UbgK9XRzGg6Tmm0ccaknNQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bPaMH5aM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F094606A31C;
	Wed, 18 Nov 2026 22:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bPaMH5aM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF621F000C4;
	Wed, 18 Nov 2026 22:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041971;
	bh=n/iqQLnW5xyZjHEfnOND3SgPNrc81AuSt/L6ZPMGQMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPaMH5aMIyEQHQsRQmDNdtEdzcAlmahV9km8xrPoFfi+F9+d0SqEncZwVDLQ4kqiq
	 HMTJxFhQwRWZx2P5qC+UXOeWZpyudh1veU6wLfAc1pdqF6kWJXNP75Mu5lwANreCUT
	 rm5m0mZ0xaHuMRu4EtGe0zE9PX6M7LQywjkuIg/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3004/3318] bpf: Dont bind a program to a netdev that goes away
Date: Wed, 18 Nov 2026 16:00:26 +0100
Message-ID: <20261118150450.373600680@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit af929bc938e0d0ecd839e6fed9a2ce5eb5185e5c ]

bpf_prog_dev_bound_init() looks the device up, takes bpf_devs_lock and
registers the device for the program.  The reference it holds does not
keep the device registered.  If bpf_dev_bound_netdev_unregister() has run
by the time the lock is taken, nobody takes the program off the device any
more: the bpf_offload_netdev and offload->netdev point to a net_device
that is freed as soon as the reference is dropped.
bpf_dev_bound_resolve_kfunc() dereferences it while the program is
verified, and a new device at the same address finds the old entry.

unregister_netdevice_many_notify() leaves NETREG_REGISTERED before it
calls bpf_dev_bound_netdev_unregister(), which takes bpf_devs_lock.  Look
at reg_state under that lock, and treat a device that goes like one that
is not there.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-22-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 21547b5d63809..dad387fbcae6f 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -268,7 +268,14 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
 	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);
 
 	down_write(&bpf_devs_lock);
-	err = __bpf_prog_dev_bound_init(prog, netdev);
+	/*
+	 * Behind bpf_dev_bound_netdev_unregister() nobody would take the
+	 * program off the device, which goes once the reference is dropped.
+	 */
+	if (READ_ONCE(netdev->reg_state) == NETREG_REGISTERED)
+		err = __bpf_prog_dev_bound_init(prog, netdev);
+	else
+		err = -EINVAL;
 	up_write(&bpf_devs_lock);
 
 out:
-- 
2.53.0



