Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D941C2FF;
	Fri,  4 Sep 2026 06:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502920; cv=none; b=LwZNIKeICuWK7qJEjf87yGa9Qb6ryzrWN1llvbM8UCpmoCs8urDR1pXYxVfOgGvgRlN7Cb5EPll9QrRFz1nWl+mJyNL2Viokb02NpErtlxrvk57tVmnKuu7Qz/GLA9AEyBrOgw58s52VknlzJHq+SYpZtrOxFCERoXfuTBFzORs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502920; c=relaxed/simple;
	bh=tEDnyohrs2lx3LMCcvwXG9wlPefwVXYQMiJoYRYxzdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/zExu2NP6WxFXyuO0uf/iVkUXWVEreywigVPbODpJ5+nGKlOnF9MFi58m76kWsrq/njGWNQRonNZZK/qAHiq43dBZh++ftfQkT5wWrXpMIzTPQDuOvpYUgKjih0zujzwiuG5XijqQ6yFzF/VmSx6Aa5eKZdpidUp1ESRiY8N/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCPnBw26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCPnBw26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966DE1F00A3D;
	Fri,  4 Sep 2026 06:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502919;
	bh=fEGbnaQw7ITEUtABSdFgYjn9FuVhHZ4VpUvLuc32I5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCPnBw26U2AUYEWR0heeYp1J4KYBvjDXDqXDqvrOFnSD7uohf2+wy/KxZubyjAcxn
	 HuNgFrv5JyKY6SyEqX1MrOVhjv76d1+qAo7w2U3YqS/3Y1BeQSWIj9L3B79QuHdPdc
	 fPFYE6210UAbUKp1euyVy2vBhJhWcwThFO06iH74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhe Yu <junzheyu1@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 377/403] dm-stats: fix a crash if allocation of per-cpu data fails
Date: Fri,  4 Sep 2026 07:03:00 +0200
Message-ID: <20260904045743.369802372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit cc87e26d9cce22061dc21e51e11afef29dbbc36a upstream.

If "dm_kvzalloc(percpu_alloc_size, cpu_to_node(cpu))" fails, the code
jumps to the "out" label and calls dm_stat_free. dm_stat_free does
"for_each_possible_cpu(cpu) { dm_kvfree(s->stat_percpu[cpu][0].histogram,
s->histogram_alloc_size);", which crashes with NULL pointer dereference
if s->stat_percpu[cpu] is NULL.

This commit fixes the bug by testing s->stat_percpu[cpu] for NULL before
using it.

Reported-by: Junzhe Yu <junzheyu1@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -178,8 +178,10 @@ static void dm_stat_free(struct rcu_head
 	kfree(s->program_id);
 	kfree(s->aux_data);
 	for_each_possible_cpu(cpu) {
-		dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
-		dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		if (s->stat_percpu[cpu]) {
+			dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
+			dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		}
 	}
 	dm_kvfree(s->stat_shared[0].tmp.histogram, s->histogram_alloc_size);
 	dm_kvfree(s, s->shared_alloc_size);


