Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032370;
	b=iF4d9ZATjaWNsQvwu//H74YIT/NR5KOp+S7kiI0xWYwJ3TuPPXbORc6K18oRb4qAWKkE
	 KB4Ske6VZk3qrLoCggSupo3TfibM3ABZ6XJvuUejhOAKmWa3N2DHNFkx7iHMgiIi7wpW6
	 FoDglhVIuuwiy8YKqd8oONWzXHrlVpMZJFR0Z8QPm9Yh5ZfUTWy4RnY+3isRmIhEOguUz
	 rC9AbK/TEmee7BZIGbCl2Rk9mU5nkAVwlw3pE8XcRCI+diLgg0DbGlnYInbnBfn1ZiYA/
	 daWNNS4KRKHDNJqNCL/a+YpYJw60NPwQFrfKOpaamua7oBzHILpknkDdUbJLX7iGdUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EGAAhFeShdL29n2+EsmSK9o8hnxkxfZG/AVXlTT9Hsk=;
	b=UYi5cs43xGSL+/zTMNJp1+FdLszRdsUt/cvEW0YSXE+Blif8jAOMP3SfbZvZkmERle9R
	 ZV6YOVlil28CIpz0K9pRa3j+8v5qT5CqZO5YBLgmjI4QjWPT/Vmkyaaj18bozjF58JsTX
	 3HrUDF4lu4/u3Gw3pI7EwdY9X0gYc/Z1e4+Wk2jDr6CxW7NlBCmRRqViLAemWUSHnHGAR
	 DhmqKfngEM+Mnaxz4EWddQbgoSXCvaulyT8J5G9ishT4Gr74MmyKeDtAhUNIgJoNBjq8Y
	 S6hYlRELMaOOqoO8EZG9TK8zEqWAl2+EMjvWoyyXWPOZh/h+W7kbDJ4BEYx+MSR216g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7nbHWDQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416D0606A320;
	Wed, 18 Nov 2026 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7nbHWDQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8051F000C4;
	Wed, 18 Nov 2026 20:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032369;
	bh=EGAAhFeShdL29n2+EsmSK9o8hnxkxfZG/AVXlTT9Hsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7nbHWDQpNEgqZAvR3yaag4PezZ5ogo8a5igkhT/Ao4aWlBAs72wDiqfUAZQNOlVA
	 pwhEi6pOKYL5GWoZTz3y9zt6EzwqM1jXEixQtQDVY62HCXcauVAeNqm4OJbtbEaqQn
	 HX2XhgHnO04NLMUKAND6t+qc/E5fC0W9sKGfpjjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1371/1756] bpf: Dont bind a program to a netdev that goes away
Date: Wed, 18 Nov 2026 15:58:18 +0100
Message-ID: <20261118150103.808852410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 791da915112fb..01a7ea343a3db 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -275,7 +275,14 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
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



