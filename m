Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065381;
	b=17l2RMU5swkxDdeaGBf2QrMZkaQCOpeXxY+HT8QzAh9u599lq2L5q09qIbYimbrI3slT
	 CIaH9g8mc4t+NxRv6MFcASv+bU35y5/4cBn02va2YZj/TxKgY3rlzYWRdUF9hXoPUaCNx
	 uDDLS3niUU5sZ1Nn6aA8QgPHFLJRvcDF5idG1ZNZ5Kqa0MxYgIvvpNKjIUupF1kN6rVSY
	 Wem3bOEK/ovvb75z0AvQRmTiL7z151drCESItxjQD1eLMW5MguE31OMGOgg76onqdx3vC
	 81Kd15Y0D6aLiqATtC3ittRIgXTNLCKUXOlKE+pIO1QfkQ4QUZkwMRrP/4UDhuMARIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKJ0xUO+NMI6OGnY9qfTypZqPrKmzZXPJSanau9Vo+w=;
	b=CS32NDWU4b+IHHY3VgGGORrMnXW5e2SH/zsdHSTWPXgNi1nKLPffkL8GakI5K162FqOa
	 6yEgUAL7tmnmUUOtidoqP8xU26aSzE8bpssxtcG13IEypV/rLnwJiwBro+jNxUzQQUk2S
	 YBaoGr9QO3Xcysd0vaJEMUbQalulJiAnmHsb0DOwRc6aegBffUwOWAZ1Q68OgXXhSMi6V
	 OAnImlo+8VS0bMk9EHq6RbcjoVmigelmSqz/4Zv7QENWTZ3jbDVV7xPZHaKhK5tsY3ptw
	 Rfg5BkiUUkTdtf/oAr+LgDeghJNcQyGt3RdIvk544u2bdRaxt1s16MSB72rA3UTwOcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eW/XYwJ9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF5606A32C;
	Sat,  7 Nov 2026 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eW/XYwJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70E1F0089F;
	Sat,  7 Nov 2026 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065380;
	bh=kKJ0xUO+NMI6OGnY9qfTypZqPrKmzZXPJSanau9Vo+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eW/XYwJ97kMy75Oc9bi8UyC6qj6efNV4f/qb/sQSZtuUXexHWoza810E0hTIbQ0I1
	 SUVWz7JPKKsA2GZoH7mdmOtsqcxKE8KgVa/HnBPN6J+1Fp7lU3iT5kpoacgYv2I0yT
	 rpsCBK5suffOEqF11OBMpz7kdHD3ulVIT/syNuuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1107/1257] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Sat,  7 Nov 2026 08:56:43 -0500
Message-ID: <20261107135009.829908492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit ef60f61208a30eb5b941b707debdf04517271b4f ]

get_cpu_itimer() returns a zero remaining time when the sampled CPU time
is exactly equal to the nonzero expiry. This makes an armed ITIMER_VIRTUAL
or ITIMER_PROF timer appear disarmed.

The cputime cleanup replaced cputime_le(), which implements <=, with <.
Restore the inclusive comparison so the equality case returns TICK_NSEC,
like the overdue case and set_process_cpu_timer().

Fixes: 648616343cdb ("[S390] cputime: add sparse checking and cleanup")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020223957.87842-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/itimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index 03a32dffc56cc..f7de39769095f 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -60,7 +60,7 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 		thread_group_sample_cputime(tsk, samples);
 		t = samples[clock_id];
 
-		if (val < t)
+		if (val <= t)
 			/* about to fire */
 			val = TICK_NSEC;
 		else
-- 
2.53.0



