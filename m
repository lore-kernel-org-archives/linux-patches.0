Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2683FF1AD;
	Fri, 15 May 2026 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861086; cv=none; b=eh/ZYAg3LKsZs6O5JQOGjpOrcNwGyTX1Xt2cY2lFC5e4Oo8l2DnUGLbATh5MlijGyZRdMHbYhvGovVmLBeQldhcK0SJD3w9jP0RX/Ew8ZJm4EG7er3ZPOjNPKVht8xGvZba+SkDKI2sAocKTLxccqdm7ZXuo52wSWiY0BSXizX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861086; c=relaxed/simple;
	bh=a+JILWhhe3O0NeB7F3YQsw7R2akQdbfmhudalObIOxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ8Kky/UQKKGkeu+PT0Io/ezhtWpCrcuSVP3mVMa9lQxP1bzlv2pUxt6k8/1dtcLncD08g7ehftZ2rtrX7o5hpY4Gx4Ltd6XZXlrr4x7ZxY+gRpaXePBOewoNct9gW9al0poU8Zu6fDcugjnyIvFGYFmmarKIhHQ3IBI9L2Z/Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xy8SSQzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xy8SSQzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE64C2BCB3;
	Fri, 15 May 2026 16:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861085;
	bh=a+JILWhhe3O0NeB7F3YQsw7R2akQdbfmhudalObIOxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xy8SSQzN7+IKLp7/yP7qBP6O5GcdjPGsLOcjnHrzkaK4uTJ8pYjEZO85SoU1U4ZMn
	 0Vy6FI8fcXQJr1czKe6mt7BYcPvYz5EXldAGLrwwO7V3OqNQp5ZTZiXOQJ31f8R4Vo
	 2wRC4srU5Rnq8+7e2Ef2enRz4mwFXGF1NHTwPJzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 192/474] wifi: brcmfmac: Fix potential use-after-free issue when stopping watchdog task
Date: Fri, 15 May 2026 17:45:01 +0200
Message-ID: <20260515154719.174528698@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


