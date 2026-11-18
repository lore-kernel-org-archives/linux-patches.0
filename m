Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021763;
	b=Uv7MmzOZIDE2lJgX44KI8ZlDrH/6+EFzCUTXPKsFlzpRKvYIAefOktgqR6JJerX080EO
	 /EeuOrkxSI7tCRwlGXH31iO7tkF4LTa5wxAnbSjz9GyKLg+FXtraxELwfFdmb37TRZq2f
	 1aT30Ky0gHXykAXW6pXK7MGbrDII+7c1cWPzqZcfVoboKXCiy7ywGhd7fJjpPRYYuHJip
	 f/XqbFHjLoMiV2DaAwJk86+eBSrhrLRe5hvVk7tSRx7dgFbo2Io9Kyga1KaY0CFqoLtJd
	 2V0SE1WcoNguqJAF8rO9ldmwTf3STjjCeYxxZrbDVKCi3KrllkVvpmNRnlLiG+vizmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qIn8HYYFa43QVerfTUUI2cHh7iaGhRUnb+JUpYPMoZA=;
	b=jNCg1HR4KjuU0VsDUMH6l54r7GR3v2SalGyLfBQyUmEOIKUZitSYK86BYLB5t+GPwsJE
	 /m/l5JGIj+6Fccyng4D61gZemlpd7TX2LG6wBNHCB7w+WyS6vDeHy5xV4zr+5VgBuFxdF
	 PgHT6nJYcJhB6Ud8mj8v4Ggs8zwXN/vZkj7jDFXnT5RmmxY2iqt7dnFL09WIwG1hSUVNI
	 yNn/gKs0iK1TfC/cI3vjuvaH26QGa9pgZ9grE5N6LA0VZqBMMmLmYurYL4ntGcxvo7/mk
	 4fGDu0h7vo1umoRd5MLFHZxviSF0VI6vbtwMem7SA/KC8t4eJYNoje1+TylHap6wdpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtSnbORp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560B760A2603;
	Wed, 18 Nov 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtSnbORp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D9B1F000C8;
	Wed, 18 Nov 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021762;
	bh=qIn8HYYFa43QVerfTUUI2cHh7iaGhRUnb+JUpYPMoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtSnbORpdNrNKFZf5GMA2S2L8w8cMET6ym5sBnRQcGJZa92Zks0fry8kTyQLiNJx/
	 eBa5risRjLlzbpG008zRqAmpIMWmHIE/LqnWrfsoh5DmZ+azxVnXgCZyxRZd4K/IAC
	 D4bwR4Q57LpBbq2q6GORz3to93JPZ8lKysEtPAV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Bradley Morgan <brads@mainlining.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2405/2651] kthread: Fall back when no preferred housekeeping CPU is online
Date: Wed, 18 Nov 2026 16:00:45 +0100
Message-ID: <20261118150411.914789099@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 78ff77ded78f2d3d6040705a3ab5a83cc45275e3 ]

kthread_fetch_affinity() falls back to the housekeeping mask
only when the intersection with the preferred mask is empty.

If the intersection contains only offline CPUs,
set_cpus_allowed_ptr() returns -EINVAL and the kthread keeps
its previous affinity, which may still include an isolated CPU.

Check whether the intersection contains an online CPU instead.
Fall back to the full housekeeping mask when none are online.

Fixes: e894f6339808 ("kthread: Honour kthreads preferred affinity after cpuset changes")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kthread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index a3f95c90456bd..0dbff3b68ffbe 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -343,7 +343,7 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
 	}
 
 	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
-	if (cpumask_empty(cpumask))
+	if (!cpumask_intersects(cpumask, cpu_online_mask))
 		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
-- 
2.53.0



