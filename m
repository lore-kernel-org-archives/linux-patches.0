Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827068;
	b=v5gcwJaHVVx8xPJbHjFDWemrdifnwfPKw7YUXvAM6f7TuXHEjPAXqJC2UhAz+5i02/CN
	 qO3VE4v5ai2AzwgNRLyGUhKGj+z0Ct59KnTuBwyrb4z+D5I+Kx5h4oVoe5EH7Xh9xWi5v
	 iq5niTuFvcUJFeiGmxMU1viZv7KABWgBnXeRbrwIXET/XBYMmkMV5V4kjarsC0O284/SH
	 LpTkE77K+cgipNOXntI9nLiVj2ebtN32EU/svkvOWtz0HZVVDhz06JVQI6Un17V69Or2Z
	 JDl9EmW0HDEse5wml89SKdsm1K335MuU25Mb+zNbKyR7pxbonloKoAIAlDdoJWdGj4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gt7UINXYvzYi/AwgglAw5Y6VFopcKtvWhXXhZG8Ln7Q=;
	b=B66qDEemPxJfFjn+z05MGK4xXwsv9q7qxvQrDxhAHWne/ZhVkFGVSCe89uFHry3PpSqk
	 H7hkJSNEEWICm1KWK5UpRyUZoi/CPr+dwXcJYpzFR0cTJxhMVsEjoqREAkNTXHSy3R1lJ
	 bRP9stBciieJIYdZNhIFnnEPrWeeBndU3+Qyalq8GyszALValGnWVRTxYE16d4SSvx0es
	 O6OLh24R7F0KzTeaw19bdgU1YxpQgI2BP/r+mSv3z30SzPmSS5qlltI9FSUmenKlzSVTg
	 x3DP0ENwdCzGh/rRTDlBje3FAlgywY2iBc/GpZFwHYTJ3CuYOGhDnavFaO2d02esv5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TntPMbA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05236606AE39;
	Wed,  4 Nov 2026 21:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TntPMbA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EDC1F000C1;
	Wed,  4 Nov 2026 21:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827067;
	bh=gt7UINXYvzYi/AwgglAw5Y6VFopcKtvWhXXhZG8Ln7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TntPMbAclVsZICXm+AQHxXzaA02pVyfnUM5vLY5LtpIbd7ev0qKlUiA0aOqmiTB8
	 OrdiA5Yv89XZRKt96jQWH2LBc6pw3435ZDQo6ayjY8YqoMZC4JN5qKfVgKXOD3WZTB
	 8HTRynwnLAVJtcrpfMVjLw9FMKy3gFRJ9N3W8b28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 174/547] s390/cpum_cf: Check session mask before cpu offline
Date: Wed,  4 Nov 2026 16:05:58 -0500
Message-ID: <20261104211043.091341383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 99a95985dfc85eecad97f0991a2401d2fcef294c upstream.

cfset_offline_cpu() stops counter sets for every active session without
checking whether the outgoing cpu belongs to the session mask.

For example, run an hwctr session on cpu0 and a cpu bound perf event on
cpu1:

lshwc -l 9999 -i 5 0:b
perf stat -C 1 -e cpum_cf/CPU_CYCLES/ sleep 120
chcpu -d 1
chcpu -e 1

Although the hwctr session does not include cpu1, cfset_offline_cpu()
decrements its counter set reference count. The subsequent perf teardown
decrements it again, causing it to underflow.

The perf event keeps the percpu state alive across hotplug. When cpu1
comes online, the hwctr session is started there and the reference count
moves from -1 to 0. Stopping the hwctr session then decrements it to -1
again, so the zero triggered counter set disable path is skipped.

Check the session mask before stopping counter sets on the outgoing cpu.
This prevents the unmatched decrement and the resulting reference count
underflow.

Fixes: a029a4eab39e ("s390/cpumf: Allow concurrent access for CPU Measurement Counter Facility")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_cf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -1797,6 +1797,9 @@ static int cfset_offline_cpu(unsigned in
 
 	if (!list_empty(&cfset_session.head)) {
 		list_for_each_entry(rp, &cfset_session.head, node) {
+			if (!cpumask_test_cpu(cpu, &rp->mask))
+				continue;
+
 			p.sets = rp->ctrset;
 			cfset_ioctl_off(&p);
 			cpumask_clear_cpu(cpu, &rp->mask);


