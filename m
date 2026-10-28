Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209438;
	b=mZ1wqFDwCl5IRcDgW3hPnHS3IURpGMs8fcN+jePbe6uFS1l/2i2zWs+HycsvJKnIrmfo
	 tYVHn9AuLIRZ3xkv71dX2rCZDNqAN3B/Cs5bPGinB9NfCYi54B3s8RtE2EPgIwpNyCQS0
	 JNvlckamNc2dtDSzKNjdFne+vtec+MfjMTZdKdRj8RYQS5HHL/pIL3k4gdYeXIt1JF43u
	 0C3MGrylS3JJRVX/6SXgBP5XL/NVWocUd6iQ2t4pVWq4n02x/W5mvl0AJor6Ir1xtyuh8
	 O95on4oacYPtmUb5AYHb3NgwBlIIWx6+gb1aaAmZRzAMvtIC73Z11Z3s8L75t/qmmnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sxtc9bhit0GJ5peKj+Qg+tci7O2dVaYWJ6wg77LSDR0=;
	b=us81zq8XD6bbpE4HQ3VUV7O1xRhRPOxjHAeqhs7fVOUjSllRJR3feyIbJFwcbcWl5MN4
	 +7IJxKohA1q6i3MZyA4NOLU2h8PmER9+qDLneypopSQZwlZLuQo0RyILLwdfwlllH+fWM
	 cvOKot0tMdG5UYnDHSdD9R7/nMf0tuzsoKmnp/hXkIlN5ia+bLHvlTemUR7z45twMiezi
	 NewXmoZUIYL66GQ+vfOEIvWakgc+JGheV9t9ZShBAiVkqj8c4cQ4t7y/Z5fSpA+9wLJq2
	 hAj7sv/lKST3CIIGvNIOG0/xknFNrs+kjdfGSHCm4Lulmg0T7QebJFpKiisnhn/OeBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkOZmpHR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00560606A321;
	Wed, 28 Oct 2026 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkOZmpHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D8A1F031E1;
	Wed, 28 Oct 2026 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209437;
	bh=Sxtc9bhit0GJ5peKj+Qg+tci7O2dVaYWJ6wg77LSDR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkOZmpHR3VOSXny6sD9GRT5CIkNu6tz78d8Hkv2O/HzmhaqqgXV0EqzfwWe2M+u3L
	 wuapmSYl99cRi1aIUDgYzyxYgmCUTLXgY//ZITzaqtlM1R05Jt9ES5Dr2/JrovEWsy
	 jTtBPloxPpSIv4TRx2B45tYeAW9Ot24/hJldpna8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/516] Drivers: hv: Dont reset VMBus connection state on error/exit paths
Date: Wed, 28 Oct 2026 17:59:39 +0100
Message-ID: <20261028170013.602262581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 683fdfa3e723e..4f46a59e994ee 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -264,7 +264,6 @@ int vmbus_connect(void)
 cleanup:
 	pr_err("Unable to connect to host\n");
 
-	vmbus_connection.conn_state = DISCONNECTED;
 	vmbus_disconnect();
 
 	kfree(msginfo);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 8d5245b74d23f..15cd9ee7a2efe 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2704,7 +2704,6 @@ static void __exit vmbus_exit(void)
 
 	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
-	vmbus_connection.conn_state = DISCONNECTED;
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
 	hv_remove_vmbus_irq();
-- 
2.53.0



