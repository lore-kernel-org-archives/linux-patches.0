Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8446D385D85;
	Tue, 12 May 2026 17:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607803; cv=none; b=aBEOUQD7Rk7vSvXJGte1Tw7HCQj4iC2howCvYuQGqswAV2Foc2F0xcZgZbfX4ZtlXCwdQYxMAIzmAih9baglR/PBG/P2D4sQaAulohHZXDUSWUG9U4d+zDu6BlWzWmPJGUZ1HFGX4ZSWJmFepBtGt8l0XxZfBbfYRfGmFAd5p6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607803; c=relaxed/simple;
	bh=p7L2ILFS8v1nirILhGlhUMqh7YxOvX8k3V4rSRQ3crA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZZPCPozXeJ/mnalgk2dv0B2Bv6Po+IR0n7KTSK95NOzuTkUk2oR483iLpyN9owjrcj+lBOzYlPNzNgzl83HD7GCnhuq2n2WtDmkOtuRuAWf3HYdXt9Qt1k9yV3M9Az3HhGdjZ4ejwrawiHnsba1ONi+gqSZO0KD/ZPz4dRTtZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m23DM8IN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m23DM8IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E459C2BCB0;
	Tue, 12 May 2026 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607802;
	bh=p7L2ILFS8v1nirILhGlhUMqh7YxOvX8k3V4rSRQ3crA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m23DM8INR1MRE914wq1wA2O6SIRlxyZMMtQUkV0PZHz4k0dUjv8Gxvco/IcAAi2q9
	 Ek7G7y3rcn9eAC3a62EuB9G5Jd4Zy/Cnk9fO4rAot+7Wy0/sZNcHe9r90KF9wVBwAp
	 4nL7ea8/iVeV2EUXmJMzuBXhblJUEk/QNM1uTDr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 040/206] wifi: brcmfmac: Fix potential use-after-free issue when stopping watchdog task
Date: Tue, 12 May 2026 19:38:12 +0200
Message-ID: <20260512173933.682066053@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c623b63580880cc742255eaed3d79804c1b91143 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2475,8 +2475,9 @@ static void brcmf_sdio_bus_stop(struct d
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->watchdog_tsk) {
+		get_task_struct(bus->watchdog_tsk);
 		send_sig(SIGTERM, bus->watchdog_tsk, 1);
-		kthread_stop(bus->watchdog_tsk);
+		kthread_stop_put(bus->watchdog_tsk);
 		bus->watchdog_tsk = NULL;
 	}
 
@@ -4557,8 +4558,9 @@ void brcmf_sdio_remove(struct brcmf_sdio
 	if (bus) {
 		/* Stop watchdog task */
 		if (bus->watchdog_tsk) {
+			get_task_struct(bus->watchdog_tsk);
 			send_sig(SIGTERM, bus->watchdog_tsk, 1);
-			kthread_stop(bus->watchdog_tsk);
+			kthread_stop_put(bus->watchdog_tsk);
 			bus->watchdog_tsk = NULL;
 		}
 


