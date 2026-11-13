Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590087;
	b=qBWMBHGebgV5XzvC+z52Frjd/7hVKStp5PPPN/ePSWY57f4ZDP9m2EJ5pRvLJc322pSF
	 Vs3ecNHAJIMIu/MPF3w7dxPzz2sPvoEDgZ5rfbR2FCVK03ekKfg36zyt1W+OSat681d5p
	 vjil3iTrfqaw5nWiHxvalg6HPQStn35HGjl3T195Z8Iu7+WEAOzyPMVZJ7BVF7NGb9+tr
	 cBiH8JukDjx4JDJ0WPTVUsdTcDlDgGNUHfdRAtPgUWZ+VTD8Ap7vGV/E01IQthFW6BxXA
	 yZ1nNBFXQIXJ+uSdvxYrWiCTPoYt5Zmfg0GBcgViLAP+W4zzwVKiur3GWQeqlV83ZVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MdjEVxGo/B4WDcT82MW4X63dpbzC+g3A3+9HMVCkJAQ=;
	b=uRGYzVgVQZC9ImwNKdd57c2EKrhTcAQf7IZHSMpHqPfWGQC4OvzuphawC8FIaofcfhdQ
	 xIcw9ibZbpFKcBsBb47SP2oPQUlAT/KlnLq5x5EtSi5X+b8WFLPcc3I3rIZLNhSqxrphr
	 tiw5QE9tl2ujN7yWPcmddjO10yhCXtj2aj8vKuAXCyOXoyHD8SICqx27WZ43dNXJxKXe5
	 YRCgY5XgVwQ/c3bE26LDU1uIJ2KgC3m1cozyauAM8PLY69597xkiNuaUO0/FvmAYMvG+i
	 pPwUR8k/RbkgflEAWcs5zpIry0n6HYJKKK93htgAPqWHGyp1kknut4uQXVtfxx3LkKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7bKbIP6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAFF606A332;
	Fri, 13 Nov 2026 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7bKbIP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF40A1F000C5;
	Fri, 13 Nov 2026 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590087;
	bh=MdjEVxGo/B4WDcT82MW4X63dpbzC+g3A3+9HMVCkJAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7bKbIP6WNwcePqbR1SZ34suWy6TXN5HvvJFmxTGMmtojaaIfnr9mpqGuwDx2vhjX
	 rY+ROajY6hZy23R41qQoGKvZ0CPOgVvEx+Lox98CSr5Sw4LlMD9luqtEHK8wqVnQEZ
	 5mKD0CUe48pEthf2wg1QUZuXIpB5f+Qh80/4PDU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/686] 6pack: restart the transmit queue when the interface is opened
Date: Fri, 13 Nov 2026 10:44:07 -0500
Message-ID: <20261113153824.706094649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

sp_close() stops the transmit queue, but sp_open_dev() never starts it
again. After the interface is set down and up the queue stays stopped,
sp_xmit() is never called again and sixpack_write_wakeup() cannot wake
it because sp_close() cleared TTY_DO_WRITE_WAKEUP: the interface no
longer transmits until the line discipline is detached and attached
again.

Start the queue in sp_open_dev(), as mkiss now does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 0bcb990faaef028c18b553d416037efad044c81f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index c8b2dc5c1becc..549bd79d76365 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -256,6 +256,12 @@ static int sp_open_dev(struct net_device *dev)
 
 	if (sp->tty == NULL)
 		return -ENODEV;
+
+	/* sp_close() stopped the queue: restart it, or the interface
+	 * never transmits again after it is set down and up.
+	 */
+	netif_start_queue(dev);
+
 	return 0;
 }
 
-- 
2.53.0



