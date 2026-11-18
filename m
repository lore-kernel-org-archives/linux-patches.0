Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027273;
	b=3CPY/HxasSVA/b86tvih/qv/fqBwnaDIdYONopYA022cexYKRnWnsvfTCB6+Xgu4eF3O
	 t+mrYirDAWIsZG2419ySwAxD35P3Jbb8OM425FSNQStnuYeVPBo5+nf4DjBSx1YF4miWV
	 ZzkF4YJ5boipl+qlw6G7DfghI2cihZ9E13doLPDyWEcLdblbY+pUofjYJpsIVwJFP9Szh
	 g5kkg/iWwgsYx3HVsCuykeT4HnWpFnuiRvNRDIf6aJOjCrALTBKvOYvHzkIBUjHKSczvn
	 D92ttIIMnQuwV+F3df7RgExODYBhc4+Xh7v17qvov46GKdZBG6qiaXqXHAN/MR1hO5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u4W3Y9TSRrTCXyLyxXq/h4JJEEHALmDxAskQGuu1V0E=;
	b=aQAClgUNu8uShuQz6Uy22bv2HimUrACbqCqiwv7jFfto2/9rvTHGTmhR68qdZaqc4BZy
	 Ud/PV8tlJpIi6gAXPe/mlqzOrQsVkyzv/qEwzZNRF5kNGjQ/+ida8kIHlPvp39IuYs4l5
	 9EHhxltuNbpzPD4MjLsEj7THHAPevugmwaMWEWoWAckZ4CesJn5Q589uBeIIyRWD584tS
	 fdcfnIMoRKkPcFElwJokqWe9++vG92n3GZChfpyoCS5+3vflRiQb/yosAUjWBEgAS/WM7
	 RD8fTTkc7QeT7Ejr45sUKN+addelULWQWTD6ImTCkWScvabZake8/eep+EJ2mRA72uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFPxkK6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9AE606A74D;
	Wed, 18 Nov 2026 18:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFPxkK6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41001F000C4;
	Wed, 18 Nov 2026 18:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027273;
	bh=u4W3Y9TSRrTCXyLyxXq/h4JJEEHALmDxAskQGuu1V0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFPxkK6gUPbFSQME78xGUKvQDBeO81EwwM/kKDSAzhBmrBjegTzIvTBO47GzMr/AV
	 8yYIpCrzFWGvsLPu0JgL+8u0J/EYNouCS/SRz7D7sLkeYAae76rmXDOlGnwHOgzRNc
	 2/OdFXUqrAM8DnzWxxqssfL6XLL/N+gLgebOTqm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1729/2151] bpf: Dont bind a program to a netdev that goes away
Date: Wed, 18 Nov 2026 15:57:44 +0100
Message-ID: <20261118150224.841828195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index bd4f4184e573b..f2a0ddd2958c6 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -276,7 +276,14 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
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



