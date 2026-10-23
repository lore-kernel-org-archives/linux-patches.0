Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774089;
	b=ZHYNdPXE5fkl1lqMDuRVHycXvG1fhSVBpmu0guiHsshIteCfRoQb22yE/rRYK4s6no5j
	 aEiOhQ/Jvv8Cp2SMGIrjypbgLomkExZ26Vzg+JacecSizQs46XR1GcVO4sWOyLzqavCkJ
	 HDjJSuW/qbCqiT0amb07IEM4XGTydLELqeZfU4xfrVypRctoN9DBwjW21GmRIGkbgknTP
	 tReYtiTOlfJ5H1bD8MMeKoH/Z+J6467uoh+weH2gDUXHFpEhj6niQK7Ucak9lr3OgRor9
	 1YXCowxxF9DGxHo6iarGKrmKLr9j5TrZwjgArp3hIr5bdWHBVsv4hQbMvUUh+rsxsTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YBOPd/yPKpTmWCR4nMoFa25Ci5ZubOGal9uF5qgUR9o=;
	b=3K2CASaxVu0gItvyjSYk147kcikDLadxZYWniC7wTWTQqvyrC6p+VdzWRehNo+sBIsCG
	 U6/IyE1AW0U25eWh3HKeVpccimDeVsd8J6/az/Bk72CMZT0eFNsa3FKF7rigchGWwTFBT
	 o4XnIugEeDpkmD/jk53PcgcqYw8XxSlZgQsRU953qjAlp2+M5d8WSCz6wxMqRAy6wJ0MW
	 hFGH8IU4D9NeR+/6V7/PW+D1ubnvlPxupWvansySffLCZcRfw8eQoIBBC34ftECPyckL2
	 DBmAHBmTKahktKyHKY+aJFogTShocPpm6Fm9ePikED/R2dKB/JnUa0qKa4uv6Gtd27A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhECGITS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F317606A31D;
	Fri, 23 Oct 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KhECGITS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773A01F01825;
	Fri, 23 Oct 2026 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774089;
	bh=YBOPd/yPKpTmWCR4nMoFa25Ci5ZubOGal9uF5qgUR9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhECGITS1mZI/qjg5u50EhHASFGT2vLdvkFLW3PnNhqukcsu+Jon65OxzvDyK02EN
	 kx+k4Lbf4mOxDoWFySpn36gZJ6H7HWF8IB52wk6mQx/bmGMX0/upFgqslniNcMosIU
	 SLNO6/czhxSkq0OzIffd4f+yaY4Ht04qnG15ENC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 117/193] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CONGESTION)
Date: Fri, 23 Oct 2026 18:36:34 +0200
Message-ID: <20261023163716.971650551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 5271b79b7ad68dcb222e893773f92bdabf7750f3 upstream.

do_tcp_getsockopt() reads icsk->icsk_ca_ops->name without holding
rcu_read_lock(). Since commit 0baf26b0fcd7 ("bpf: tcp: Support
tcp_congestion_ops in bpf"), icsk_ca_ops can point to dynamically
allocated BPF struct_ops memory that may be freed concurrently via
setsockopt(TCP_CONGESTION), leading to a use-after-free.

  BUG: KASAN: slab-use-after-free in _copy_to_user+0x37/0x60
  Read of size 16 at addr ffff888013505260 by task exploit/149
   _copy_to_user+0x37/0x60
   do_tcp_getsockopt+0x158a/0x2460 (net/ipv4/tcp.c:4585)
   tcp_getsockopt+0x91/0xf0
   __sys_getsockopt+0xf7/0x170

Fix this by holding rcu_read_lock() around the ca_ops->name access,
using READ_ONCE() to load icsk_ca_ops, and copying the name to a
stack buffer before releasing the lock. Also annotate the relevant
icsk_ca_ops stores with WRITE_ONCE() to fix the accompanying KCSAN
data-race issue.

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Suggested-by: Eric Dumazet <edumazet@google.com>
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Link: https://lore.kernel.org/all/20260821182449.79785-2-blbllhy@gmail.com/
Cc: AutonomousCodeSecurity@microsoft.com
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/d3f97f1acbf0010898148be6e6406e4b8b4a5c84.1787870710.git.blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c           |   14 +++++++++++---
 net/ipv4/tcp_cong.c      |    4 ++--
 net/ipv4/tcp_dctcp.c     |    2 +-
 net/ipv4/tcp_minisocks.c |    2 +-
 net/ipv4/tcp_output.c    |    2 +-
 5 files changed, 16 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4555,16 +4555,24 @@ int do_tcp_getsockopt(struct sock *sk, i
 		val = !inet_csk_in_pingpong_mode(sk);
 		break;
 
-	case TCP_CONGESTION:
+	case TCP_CONGESTION: {
+		char ca_name[TCP_CA_NAME_MAX] = {};
+
 		if (copy_from_sockptr(&len, optlen, sizeof(int)))
 			return -EFAULT;
 		len = min_t(unsigned int, len, TCP_CA_NAME_MAX);
 		if (copy_to_sockptr(optlen, &len, sizeof(int)))
 			return -EFAULT;
-		if (copy_to_sockptr(optval, icsk->icsk_ca_ops->name, len))
+
+		rcu_read_lock();
+		memcpy(ca_name, READ_ONCE(icsk->icsk_ca_ops)->name,
+		       sizeof(ca_name));
+		rcu_read_unlock();
+
+		if (copy_to_sockptr(optval, ca_name, len))
 			return -EFAULT;
 		return 0;
-
+	}
 	case TCP_ULP:
 		if (copy_from_sockptr(&len, optlen, sizeof(int)))
 			return -EFAULT;
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -223,7 +223,7 @@ void tcp_assign_congestion_control(struc
 	ca = rcu_dereference(net->ipv4.tcp_congestion_control);
 	if (unlikely(!bpf_try_module_get(ca, ca->owner)))
 		ca = &tcp_reno;
-	icsk->icsk_ca_ops = ca;
+	WRITE_ONCE(icsk->icsk_ca_ops, ca);
 	rcu_read_unlock();
 
 	memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
@@ -253,7 +253,7 @@ static void tcp_reinit_congestion_contro
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	tcp_cleanup_congestion_control(sk);
-	icsk->icsk_ca_ops = ca;
+	WRITE_ONCE(icsk->icsk_ca_ops, ca);
 	icsk->icsk_ca_setsockopt = 1;
 	memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
 
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -111,7 +111,7 @@ __bpf_kfunc static void dctcp_init(struc
 	/* No ECN support? Fall back to Reno. Also need to clear
 	 * ECT from sk since it is set during 3WHS for DCTCP.
 	 */
-	inet_csk(sk)->icsk_ca_ops = &dctcp_reno;
+	WRITE_ONCE(inet_csk(sk)->icsk_ca_ops, &dctcp_reno);
 	INET_ECN_dontxmit(sk);
 }
 
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -508,7 +508,7 @@ void tcp_ca_openreq_child(struct sock *s
 		ca = tcp_ca_find_key(ca_key);
 		if (likely(ca && bpf_try_module_get(ca, ca->owner))) {
 			icsk->icsk_ca_dst_locked = tcp_ca_dst_locked(dst);
-			icsk->icsk_ca_ops = ca;
+			WRITE_ONCE(icsk->icsk_ca_ops, ca);
 			ca_got_dst = true;
 		}
 		rcu_read_unlock();
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4030,7 +4030,7 @@ static void tcp_ca_dst_init(struct sock
 	if (likely(ca && bpf_try_module_get(ca, ca->owner))) {
 		bpf_module_put(icsk->icsk_ca_ops, icsk->icsk_ca_ops->owner);
 		icsk->icsk_ca_dst_locked = tcp_ca_dst_locked(dst);
-		icsk->icsk_ca_ops = ca;
+		WRITE_ONCE(icsk->icsk_ca_ops, ca);
 	}
 	rcu_read_unlock();
 }


