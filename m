Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621228;
	b=MTl9i2bW1ZkSMUREa6mMzEQfwrpAHKHnqvSyr1PIJPhobmYBQ7IvamtUp+KLKavYpr08
	 v6mrLBpXumt7mkx/p3lh47gSrL+6JegHxqU7LKJbwbixDZeGFc1jKVMV3nsqG2glxFDX0
	 cW9P5bq0OvQrbEGP+jBnxwlo62dIIM3gTBjdSmJJs6eD3iWgtjixGTXOAZ0FUymRln7Sn
	 ejMqlER/f69QAyH2bkGOZ3TONrQA8IT4ScmXHTg622QAZrMIGw/LzajGqRMSE6NedSS+y
	 9tqVTYUgoyE5H3eG46bSj+aBs7n2HIA2ux33GfxehdYekOjqicND35OJ17JsD+91F/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PRtoFk500/0u42f2HGvmQ5BKQAXZbQibKfzNPb4MbMM=;
	b=VfSEDhelx9NDHkU+vCSnS52QP1XwP2p4ESHpAhlYakgnkjrX7QZt9sYRtIimSBhBZhbG
	 6+VEDIWhVjSjrH0dK51G+vFzkwdhU3vtyevYT+KibSFowvVFDHOi0Rk0F0ZW9pJ0GFqdL
	 +Oi4FeeqNtmeGiA+w5WLCejIyCFqO9umOq0jFD9YMIqszdJYztwf/1gh2HsvREUtRGU+Q
	 RRhoH0YDjgaTbn80JN07QFJjN3CsucNmdi7hQ95OZjoyvwbgG4Bz8O1skfbFQorqVs8ag
	 k/iP4Zqb4agFMbUquONfw6GYMDaW63x3rx+9OcmCMa27hSvhv61TEJX0kMnR02KYqkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zk7gVYi+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA30606A697;
	Wed, 25 Nov 2026 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zk7gVYi+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C311F000E6;
	Wed, 25 Nov 2026 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621227;
	bh=PRtoFk500/0u42f2HGvmQ5BKQAXZbQibKfzNPb4MbMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zk7gVYi+9uE/sAc0fq+hBc0F78czhqvc10fz6gdqRz9Tgl0KIT4yOVSD4VV7xwH30
	 6rjHpb83shivT7RM9xC+RDKTiWfnq96iqtTFO3e6gMovFrD7Pxzv30Bg5k5mN7/mnF
	 egG6QVtz7bUL4dbMojeDb/SGyjILWLD4RpDRG6OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/990] bpf: Require prog fd or capability for cgroup detach
Date: Wed, 25 Nov 2026 15:24:43 +0100
Message-ID: <20261125143824.803538597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index c652ba01bc8bd..9223d76774f21 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1125,9 +1125,14 @@ static struct bpf_prog_list *find_detach_entry(struct hlist_head *progs,
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



