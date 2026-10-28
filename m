Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211833;
	b=4RUgcTuQgtC6/REwS9Ajt61CETnLhPiieMC3y8aaN5ktDiTQAXV9VxmUwHak3G0aXziK
	 E37NUBFypwlmtUV4m+afr/oJxWDU+Zf8Mvt2l5huL3azU/wqf70qOFqTkGgIpqTA34++f
	 QSlsS/PnzZSAnAwsqgsrAIy92wzS4oHLKNoc65mx4uS/Yun6BFD2KmYsd8pT71q6Pdni6
	 XhQe3yLwAqE9AxNVc5uvYO+FM+DhKIA8qP4GUDpkP0DkCta1bMY9J7+32njXVAZcIUB0n
	 AznTT9mnvD/wUUQfJdd2DvTHvpEedZvOP48DN5heiEk4tTwuW87UT+J7YriKrPVPsrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C05SP7c1Kldsc1pJzZisjbFquv7DmS8p1G9ag2V2KPE=;
	b=t07ATwGRsWsPge3jOk9TItJDVBvGYQDyM1A7nkbKE0r1LyrBFwZvdWZQW7TOLIFiQdi/
	 AoMjdCw6aFXKP0PyPx9ASem2p/+jzeLTWgWJFU4hJ4W/My+JzAGivjuBXPn7kaUU7uqqA
	 q+JKotsRp466YAfYhbG5kI1g6s6QUHR39kvGbDq3l9NUmkKsSXoRtxRiw7osnqYjBBDyE
	 MxZ9jaKFx8Uj5MRcbuHSjAzki+w9AXSUt554SCcE6OpV8vo4GGT0IphWbVIr7kXD12IwJ
	 h1/xRUJDxazmrweeifyHviwp3ePU70DQj02lIzMQ1K71qV9o0Q2qJ9HqkRyI57RlEAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3yVMqMQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD69606A334;
	Wed, 28 Oct 2026 18:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3yVMqMQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2461F01825;
	Wed, 28 Oct 2026 18:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211832;
	bh=C05SP7c1Kldsc1pJzZisjbFquv7DmS8p1G9ag2V2KPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3yVMqMQVqA3iSwNaagkm/tVJ+66mM1LxG8OD/FgvVhL6rHN0gI54dA4/1Lfwd0cy
	 +w6sxwS97A3Et2aTEtSaLlkfwyIHdmVD1V9ildblVvSncZCeojPZpevHzwzl0XtA/C
	 lrHBhrRB+oOgTwyXDKr7t41TyPlj5Wzc+lQS4U5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/571] Drivers: hv: Dont reset VMBus connection state on error/exit paths
Date: Wed, 28 Oct 2026 18:00:17 +0100
Message-ID: <20261028170019.173403561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit ec31dc39e835ccde0930daccece8c492d28282fc ]

In two places, current code forces vmbus_connection.conn_state to
DISCONNECTED prior to calling vmbus_disconnect(). But vmbus_disconnect()
calls vmbus_initiate_unload(), which unloads the VMBus connection
only if the conn_state is CONNECTED. Consequently, the connection
remains and the Hyper-V host might continue to send messages or post
VMBus interrupts.

The problem was introduced in commit 74347a99e73ae ("x86/Hyper-V:
Unload vmbus channel in hv panic callback"), in that
vmbus_initiate_unload() started checking the current connection
state before doing the unload. This commit removed some occurrences
where conn_state was forced to DISCONNECTED, but these two remained,
apparently due to an oversight at the time.

Fix this by not forcing conn_state to DISCONNECTED during VMBus exit,
or if a failure occurs when establishing the connection in the first
place. Whatever value conn_state has at the time is then read by
vmbus_initiate_unload() to determine if there is a connection to
be unloaded.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hyperv/20260805205806.B5AC31F000E9@smtp.kernel.org/
Fixes: 74347a99e73ae ("x86/Hyper-V: Unload vmbus channel in hv panic callback")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 1 -
 drivers/hv/vmbus_drv.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 47fb412eafd35..09863960c4b06 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -274,7 +274,6 @@ int vmbus_connect(void)
 cleanup:
 	pr_err("Unable to connect to host\n");
 
-	vmbus_connection.conn_state = DISCONNECTED;
 	vmbus_disconnect();
 
 	kfree(msginfo);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 7125bccebe2a8..85ef058f9ecda 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2807,7 +2807,6 @@ static void __exit vmbus_exit(void)
 
 	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
-	vmbus_connection.conn_state = DISCONNECTED;
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
 	if (vmbus_irq == -1) {
-- 
2.53.0



