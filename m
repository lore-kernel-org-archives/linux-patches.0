Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020892;
	b=aYYapHzZZduQxxDJCiT7Clc+nfl9AYnC6E/NO3xcBw09L1/Rhu8zbxpjwFXazBOxylSW
	 bOTgFDzDt7id0H0/WTKobo6kv2qhV07nk5MJymz7N3+50+O+l+L6SmSwg6a6AVSnBRyqX
	 bnAu3iZyqXFi1C1ILEIZ9c5HymeQu6et/raFLCrJ7TYvc1zi4f+eT1uRCwHJQFwVSlOvQ
	 XSwso5RjWAkC+Sa1wjiwQj98Z7cs9fBny4O2uLjkviLbnTCDsLE675zK2+8uB0BTG/RfW
	 D7MRX/Eunk95R5YcySrWUqLFAJuRpwvBRa3NzqCCY4Y/eqSMU31HAb8wYI312Iew9+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z41P2Q4hv4UIlJBSpeWvUcmtuQNuhNHOfkFEXQvDzjs=;
	b=A77e0DyTGA3hoSITXL9qUPwP07E7PW7kKiuSMSzSH6bRx1nwd49K/IE55QVMZGRJnZkH
	 WdeXp97Ty0eFKe6hK0xcyalRF+/zDSSqgvf3tzKMkdG03etu/OQQE6veodAx6WHvY9Wmq
	 yIhACFJB0s1C2FIC4xkkogTFFeMHxPKgPv31vpDUpxZKOgbiFTp20xSi1IC8gQsiICHgw
	 wbO8JmGqt3Cxy18HIGRdW+tBD3amTOcVkdUH21d7wO7X168zyp0e50+Gzb3dvtiLmztvs
	 UV+CRS8UDDphuAw3WbhPhs43WVi1wWG5UtTKPhEPDpJOa4Ww+x5m4kQ4yJpjA1obC0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nKyMgERM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DB7606A330;
	Wed, 18 Nov 2026 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nKyMgERM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EEA1F000C4;
	Wed, 18 Nov 2026 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020891;
	bh=z41P2Q4hv4UIlJBSpeWvUcmtuQNuhNHOfkFEXQvDzjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKyMgERMAoJUahhXzvstXm0jFu4EC4+MkAzaefeYV/B+4oFWTWiwwr0B9PpliAOgD
	 XHeDdQDd5+UWkSbnuMFMldQpdchYro71vLgz/YvQ5dtWpYT2IzJNghCiIC09Xt5VFO
	 MYEQMaR6YH4DNuTuEGCZ1urgQYljfREGonU3OQus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2114/2651] bpf: Assume no bounds for a writable tp with tail calls
Date: Wed, 18 Nov 2026 15:55:54 +0100
Message-ID: <20261118150402.045391391@linuxfoundation.org>
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

[ Upstream commit cd0490e671d70326d70c7d36e82388939fd9b071 ]

A writable raw tracepoint hands a buffer to the program.  The verifier
notes how far the program reaches into it, and bpf_probe_register() refuses
a program that reaches further than the tracepoint allows.  A program that
does not touch the buffer passes, and can tail-call one of its type that
reads and writes behind it.

Take a BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE program with a tail call to
reach as far as can be, as for the stack, the packet and the buffers of
iterators.  It cannot be attached any more.  Plain raw tracepoint programs,
for which the limit is zero, cannot get at the buffer, and a tail call
stays within one type: they are left alone.

Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-28-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/fixups.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index 7968e81100b89..3dcae0625a88a 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -2020,6 +2020,8 @@ int bpf_do_misc_fixups(struct bpf_verifier_env *env)
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 			prog->aux->max_rdonly_access = U32_MAX;
 			prog->aux->max_rdwr_access = U32_MAX;
+			if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE)
+				prog->aux->max_tp_access = U32_MAX;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpreter for every normal
-- 
2.53.0



