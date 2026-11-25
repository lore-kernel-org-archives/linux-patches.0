Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624143;
	b=DDhy9Pjj6AtDhz8ku3nYk8uDXgFr6/HHVoGLybOTnmN11oYOpZZ/81ssyJY4PA9Sumhv
	 QoLCVXjGT9b6m6KKZVhq6sVpcDxhLXdP/xMX5o1kaSgZklojeno2yA1hBDCK/2tr9G8Iy
	 SS75qCP/ab2aSBeGkBzJ1D90QzlktdxSeuG5Af0iQpOstSx0TYv/wQwwefEEASE2nlISn
	 8XJ5/YAEJy7pnItFS+SCjqGR0S22QTKZdx4CLYh8C1mmZn4w+h8SI17n25Q+WX4GIvduU
	 pPeDNj2EKkVrlH0vjYCaVSuH2E0c6QxYHrlaaDQMm03QxGvxY6Kdqj+1PJAM7CFWiUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QlMkydF5A7pB1mkMZh+A41C6lme5/nPb+TEWBir0PwQ=;
	b=omnnmqvH6Z35eE6JWkNtnM/ju/zB2CSF7lJutWF6gbIsl7hzneDL99SuN/zECWpffOCH
	 RjRmEPu8+Fy2/j9hjtgE0A8stSEhxPIb819ywJCPVNeP/BNzY+Jb3Q+K4W+2bo67R/xXQ
	 eByMQnuHFIxDyh09TENoFuIT5skDlsYyON0pLg1NXMcd/vWuXpHuvmTH0XbfzISsTs+HI
	 Q0QK4lwBOokNgk4QhmDb9i+vZ1Kt9VAuddsu42nUq2eqZxJmaswtqp15SNNHUsy2INWoC
	 Wm4s9LDnZ3I8aZhgGBZ1QUTorrREKB/wTaQrh2hoYxdtYmOJ4HlMPT1gSJjRzqSjnWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1gBKxKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F29606A339;
	Wed, 25 Nov 2026 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1gBKxKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A161F00A3C;
	Wed, 25 Nov 2026 16:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624143;
	bh=QlMkydF5A7pB1mkMZh+A41C6lme5/nPb+TEWBir0PwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1gBKxKntTf+bXxNiEZWBFKroG0PRiksb7byXKNesudB/PbHEy0sDPqtXQrSJiQmW
	 GaySd0iGUR28wUwnntnTQ1eAwpl7DQf+9i/D6CL3E6m52gpGLVTN8tNwvbFEpfvaRg
	 l16H8WOdg4muJ3zITK3DtecIGv0aozIRD74aNA+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/816] bpf: Require prog fd or capability for cgroup detach
Date: Wed, 25 Nov 2026 15:27:27 +0100
Message-ID: <20261125143851.509090012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 2962329f7c86fc51c177d4049c0f15a95ebd270c ]

Since the commit below a cgroup prog detach does not require CAP_NET_ADMIN.
The fd of the attached prog gives the permission instead. But the detach
requires this fd only with BPF_F_ALLOW_MULTI. Without this flag a cgroup
has only one prog per attach type. Then find_detach_entry() returns this
prog and does not compare it with the prog of the caller. Thus the kernel
detaches this prog for a caller with neither the fd nor a capability.

Compare the two progs. If they are different, require CAP_NET_ADMIN or
CAP_SYS_ADMIN in the initial user namespace. The error is -EPERM. A detach
from tcx or netkit without a prog fd already requires these capabilities.
With BPF_F_ALLOW_MULTI nothing changes.

Without these capabilities, a caller of bpf_prog_detach() of libbpf must
now use bpf_prog_detach2() with the fd of the attached prog.

Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-14-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index bd47c4cb19910..f075f3a8cda30 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1071,9 +1071,14 @@ static struct bpf_prog_list *find_detach_entry(struct hlist_head *progs,
 			return ERR_PTR(-ENOENT);
 
 		/* to maintain backward compatibility NONE and OVERRIDE cgroups
-		 * allow detaching with invalid FD (prog==NULL) in legacy mode
+		 * allow detaching with invalid FD (prog==NULL) in legacy mode.
+		 * Without the FD of the attached program the caller needs
+		 * CAP_NET_ADMIN or CAP_SYS_ADMIN in the initial user namespace.
 		 */
-		return hlist_entry(progs->first, typeof(*pl), node);
+		pl = hlist_entry(progs->first, typeof(*pl), node);
+		if (pl->prog != prog && !bpf_net_capable())
+			return ERR_PTR(-EPERM);
+		return pl;
 	}
 
 	if (!prog && !link)
-- 
2.53.0



