Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516474418E3;
	Tue, 16 Jun 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632414; cv=none; b=qpmTcZt0G2hVeIa9IiGRCu0tUDfcH8H4Y9REEPFIBigcpL87c0d/GJTznle2ebBPNkMHH7vZBbPckL0PjW0Ou/YQ4bD8JkCi1u/5ppIbAGPouv7RkKg90DPrudHUDoIlOfokwaAYpExcVRSx1q9rmYgzYTMMap+TP3ZzMTfpnOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632414; c=relaxed/simple;
	bh=g97H1G170FYJ8GXoG/OBxZ3emP6iWQHCgfVjrqK2nY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7y/mh5PR0Pnz8D3V4n/RwUi/w/Wl/jAJvveCMc2VVGihrXJ9C6m+c8KkcNO+kopbIfhr0UYN/8I02JqinuJhAill68GBJzDxzyWlLwr/z+k7aTEOGzdP8kbsjuGsjNRUnHs5hQtAYGPPOw1xaLDnInlm9ohTiIQy+HJT6BX9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp2CI0Er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp2CI0Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A581F000E9;
	Tue, 16 Jun 2026 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632413;
	bh=3Eyy/rGemLtEIChY4se8PzFatth6D6MBMJGMGLl9Tjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qp2CI0Er6UgocWZpZgnrUyPnJFtBl9NHz889HVWcIheAjHaF9qV8Q6KU2rrPstiKL
	 TqawHjobViPQWCs9EUMW4PQm5C+40/CQOfddujDnvVIo6Vs+juS69Q4QM51sYik8ng
	 7/sRUmUbW1CKtgkA5jdnOGgiHDirQCJ9cDwKGe98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 373/522] wifi: brcmfmac: Fix potential use-after-free issue when stopping watchdog task
Date: Tue, 16 Jun 2026 20:28:40 +0530
Message-ID: <20260616145143.224247198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit c623b63580880cc742255eaed3d79804c1b91143 ]

Watchdog task might end between send_sig() and kthread_stop() calls, what
results in the use-after-free issue. Fix this by increasing watchdog task
reference count before calling send_sig() and dropping it by switching to
kthread_stop_put().

Cc: stable@vger.kernel.org
Fixes: 373c83a801f1 ("brcmfmac: stop watchdog before detach and free everything")
Fixes: a9ffda88be74 ("brcm80211: fmac: abstract bus_stop interface function pointer")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260416093339.2066829-1-m.szyprowski@samsung.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ replaced kthread_stop_put() with open-coded kthread_stop() + put_task_struct() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2477,8 +2477,10 @@ static void brcmf_sdio_bus_stop(struct d
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->watchdog_tsk) {
+		get_task_struct(bus->watchdog_tsk);
 		send_sig(SIGTERM, bus->watchdog_tsk, 1);
 		kthread_stop(bus->watchdog_tsk);
+		put_task_struct(bus->watchdog_tsk);
 		bus->watchdog_tsk = NULL;
 	}
 
@@ -4549,8 +4551,10 @@ void brcmf_sdio_remove(struct brcmf_sdio
 	if (bus) {
 		/* Stop watchdog task */
 		if (bus->watchdog_tsk) {
+			get_task_struct(bus->watchdog_tsk);
 			send_sig(SIGTERM, bus->watchdog_tsk, 1);
 			kthread_stop(bus->watchdog_tsk);
+			put_task_struct(bus->watchdog_tsk);
 			bus->watchdog_tsk = NULL;
 		}
 


