Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020875;
	b=3Gtoe94orH9j2L4ofDPaWKxut1uAqOA00ekTQw4RsvFhOdbAe+CK3cpA/LgYmNQipd9W
	 hD+yLGcEK3cYVwlYiOBvftO9NlIRkFeSfrwmAmQkVFnQ37IbHfzdzI0MT2cNerjvse9cr
	 hQ+m89rs3m+0kh5AwjJdk8B6FqdWjBO1ePBUAMhlpqz2Jt3b51hnOpAtYiL1zxMyzf8DW
	 WlIp68NpeueYkyVtAZa9uqcoXSPxXFdE922o6BLnUJJdE7/kD4e+E1VjeNhG97GSoG+33
	 4rce4dGkUSSq1aWonKSS+RK7EUxg7Ph9OJO05R9eEYWa5bhDMGxgO8HSAfEY6tHoHNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QM1UJEgXtvzk3ijvH07S7mUf5CYsixfMxSfYBrOKFEE=;
	b=KeyLL1gEFTdAVWYpJYCXhEjUtioytaK0JBkbsCt1edFrqoqqLy93fc1qtyTDLdIhMKg8
	 RZ/s/ba3ARBV9u35P7th5CZXxJKI6pC/8oKRuumKMkiUy5OgIBeLrIpSyFfJlaOl4SZQH
	 BhfMaz8UyPrVEMIJu1bL/oDZxlVXAFVbduirQWnZNX9qtct4iQBNaHj1fZf91hNsS4Zex
	 z0ASNETDOUVjDg39DI/EFBRNFnC5TvEAtzoT5HQ6Qvs9J+oD2YneAxU9Ey5YAHt2dXU7K
	 q4Hr1T5O239nzimQ7AbpKAS+tvoI1hYLm+WgNueIroGK1Dp55MXMhhFIMNxVF2J4MOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5CtS8tB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DC6606B5B1;
	Wed, 18 Nov 2026 16:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5CtS8tB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3261F000CA;
	Wed, 18 Nov 2026 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020875;
	bh=QM1UJEgXtvzk3ijvH07S7mUf5CYsixfMxSfYBrOKFEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5CtS8tBUCzSNVbcJuIccwbEBWD1Anuc18vaJ1opLYcA+oq9zXkrhoz1hqjPq/ylC
	 ACHE25qGVJ30sx0KTqvR9dKQ6Hjqtn38J+Sf0HuY6mqjDtm/+d2LaSDHK5U6u1iHOg
	 XYMLstIJ+G7F0mAyZjKZ1ckAshym+9m74s7ii65w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2108/2651] bpf: Dont bind a program to a netdev that goes away
Date: Wed, 18 Nov 2026 15:55:48 +0100
Message-ID: <20261118150401.852708421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5a10f40a7831d..f7bfff1760cc6 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -266,7 +266,14 @@ int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
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



