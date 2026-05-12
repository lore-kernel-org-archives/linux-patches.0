Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351533BB13F;
	Tue, 12 May 2026 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608438; cv=none; b=rSAUhQz4DLcV3hiL0zbbhIEUlejeNB5ROSo4ckruyWD6DB4BQRLUKsaoRuR9nmSZ2WxCaWJml3zVCfPCe1enjId5T0X8HVoFmwx0ohbjUvyGD7D6JGmTKindeSewWo5n7jP4zcgGcT0YWvfpKr/Z+sp760JOlnR/Jch5LUeRcYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608438; c=relaxed/simple;
	bh=EmPxuYYylQ3ev/E9W8b9EFrqAA7GoI1nyATEPLC0KK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6E1cYj3kZruPUVenzBzY+iYeUMc0iYc8H/+yNMMZvtSRzjaagXMZ1WEqIidZN9WgZb1XCOkncz2VKZht4w9ltD2YzfF5jXZZOoXsm0IgmnYlQk1JcAEbePqpb9L6deRj+DDHtCCUEOEpSoif9/gFRAF3bdFSc8SVHYXInmXylU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmEQuP3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmEQuP3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D536C2BCB0;
	Tue, 12 May 2026 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608437;
	bh=EmPxuYYylQ3ev/E9W8b9EFrqAA7GoI1nyATEPLC0KK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmEQuP3l8QOk8DLzw5JpclJQOSxbltVfAkFEmHLCsMKULeH0k0YztnDgJqLY+ZJYO
	 AXxscZ+Ux6u9nYpxWyIPrSskyd57lLnEFVZlnHFSj/lyWe6O+Aap9Wq89HMFFY/ASb
	 D1ngImxSZO1a0kauo2qfVbMRD6tzXRS6d3YLkAdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 037/270] wifi: brcmfmac: Fix potential use-after-free issue when stopping watchdog task
Date: Tue, 12 May 2026 19:37:18 +0200
Message-ID: <20260512173939.236368162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2476,8 +2476,9 @@ static void brcmf_sdio_bus_stop(struct d
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (bus->watchdog_tsk) {
+		get_task_struct(bus->watchdog_tsk);
 		send_sig(SIGTERM, bus->watchdog_tsk, 1);
-		kthread_stop(bus->watchdog_tsk);
+		kthread_stop_put(bus->watchdog_tsk);
 		bus->watchdog_tsk = NULL;
 	}
 
@@ -4567,8 +4568,9 @@ void brcmf_sdio_remove(struct brcmf_sdio
 	if (bus) {
 		/* Stop watchdog task */
 		if (bus->watchdog_tsk) {
+			get_task_struct(bus->watchdog_tsk);
 			send_sig(SIGTERM, bus->watchdog_tsk, 1);
-			kthread_stop(bus->watchdog_tsk);
+			kthread_stop_put(bus->watchdog_tsk);
 			bus->watchdog_tsk = NULL;
 		}
 


