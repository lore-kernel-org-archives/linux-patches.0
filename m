Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F154652;
	Tue,  6 Jan 2026 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720371; cv=none; b=PuqmjappyzmfNfAQNpy6eI8P3OnpkxJl64ZSXVvGthDJYD08UlBdeARWopdnQyPS+7GZ6V7Rl2IRK+jfwtrI19kAvAgpOmA5bcBvAmeM6FpaJdW6WKLMR3YUGKfp0ncusD5lZCSGhb8uoGW2CulmJQqZOA83taWdQwcqpquJiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720371; c=relaxed/simple;
	bh=3nqc3gw7IeN0z0XtDvI6T3cYcaRPFSuWRwPeFBXiKNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug9BQ0Sd2iuXEnhnepb1z8rFrx1ZmwOoE4oZFpc/CkzBcbHizf2cv/7Y0+ZDmLCDQwPSYUiY6VTtUQLsHuJKzFnIyNDJYWRaYWssPeZcpzfSK2wfD/qQ+VrilRmElDC7cHZk9DUD3pKtlAA25vCSyCyZAwXJJzgYN/9GN5VYFs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUcsuRpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUcsuRpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97269C19424;
	Tue,  6 Jan 2026 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720371;
	bh=3nqc3gw7IeN0z0XtDvI6T3cYcaRPFSuWRwPeFBXiKNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUcsuRpAjoukoHE+R3UXa34LkPanQ1AgovgF7by8LXMPoYbrd8tkAuy5M/LULdQjG
	 O34LM4SjJgURtObxZDvVfzWdeL5UJvLc3UmSY9lF3yT2aekf/86wQtwCrjwRUp9WbF
	 jBd82IZnS/BFVoZltS/Xk//E0l0Bgd05/4o/8dMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 217/567] parisc: Do not reprogram affinitiy on ASP chip
Date: Tue,  6 Jan 2026 17:59:59 +0100
Message-ID: <20260106170459.344276371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit dca7da244349eef4d78527cafc0bf80816b261f5 upstream.

The ASP chip is a very old variant of the GSP chip and is used e.g. in
HP 730 workstations. When trying to reprogram the affinity it will crash
with a HPMC as the relevant registers don't seem to be at the usual
location.  Let's avoid the crash by checking the sversion. Also note,
that reprogramming isn't necessary either, as the HP730 is a just a
single-CPU machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/gsc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -154,7 +154,9 @@ static int gsc_set_affinity_irq(struct i
 	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
 
 	/* switch IRQ's for devices below LASI/WAX to other CPU */
-	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+	/* ASP chip (svers 0x70) does not support reprogramming */
+	if (gsc_dev->gsc->id.sversion != 0x70)
+		gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
 
 	irq_data_update_effective_affinity(d, &tmask);
 


