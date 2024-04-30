Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2289A8801;
	Tue, 30 Apr 2024 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476018; cv=none; b=u3kcAyQe0q/pTq+gzAp8d5O2/amHO0PPuRTIwQUoInUF2eOhDYubWl5NkOpTrT0/FyEUh8U1oESNNQHiSYyOD2aI7DSb10KWMFq9ItueJ20AUnIYXfUKRHxVibqV/HEdOjiZyX6jsABeN23E8P/ZMuHnEudk3/TJRrIp0p3c1/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476018; c=relaxed/simple;
	bh=nFwLMQvRWsHyXb5UbI/RJRUv7oU5Q+Y9nSbuBvIgqCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTepBIlNzWddNxsDcfwpuue3gDeR0ZN7GxrPIsfjRBeFhKoRSHLav1YrT4489C1K8dN59/qwZMSZ/yd0wHeyez3XW62zWxa6bVS3ZOdMnMqqInXMZMKFK+ypJJfw4A3a66Pq9BQpojtoSF+vkUPffMV1TwxFvKOuhVXImN+7oK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WESD4NSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WESD4NSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9242EC4AF18;
	Tue, 30 Apr 2024 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476018;
	bh=nFwLMQvRWsHyXb5UbI/RJRUv7oU5Q+Y9nSbuBvIgqCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WESD4NSMtVqNH9NUcEaxfb6T2jNqU0DPl9lbn2ZhiXyFBBMFSThheDY5k6xccUMHs
	 Mmiz9ka687FAq49pND/cHB6jofA9Q6sq5hV6aOHee2uQWKeHzm+wMgCUCedlsp6Ud6
	 eL+nryNAz4m2aQppuSNtGoMifw4qPLWJeYoleXlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a6a4b5bb3da165594cff@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.4 001/107] batman-adv: Avoid infinite loop trying to resize local TT
Date: Tue, 30 Apr 2024 12:39:21 +0200
Message-ID: <20240430103044.701842056@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b1f532a3b1e6d2e5559c7ace49322922637a28aa upstream.

If the MTU of one of an attached interface becomes too small to transmit
the local translation table then it must be resized to fit inside all
fragments (when enabled) or a single packet.

But if the MTU becomes too low to transmit even the header + the VLAN
specific part then the resizing of the local TT will never succeed. This
can for example happen when the usable space is 110 bytes and 11 VLANs are
on top of batman-adv. In this case, at least 116 byte would be needed.
There will just be an endless spam of

   batman_adv: batadv0: Forced to purge local tt entries to fit new maximum fragment MTU (110)

in the log but the function will never finish. Problem here is that the
timeout will be halved all the time and will then stagnate at 0 and
therefore never be able to reduce the table even more.

There are other scenarios possible with a similar result. The number of
BATADV_TT_CLIENT_NOPURGE entries in the local TT can for example be too
high to fit inside a packet. Such a scenario can therefore happen also with
only a single VLAN + 7 non-purgable addresses - requiring at least 120
bytes.

While this should be handled proactively when:

* interface with too low MTU is added
* VLAN is added
* non-purgeable local mac is added
* MTU of an attached interface is reduced
* fragmentation setting gets disabled (which most likely requires dropping
  attached interfaces)

not all of these scenarios can be prevented because batman-adv is only
consuming events without the the possibility to prevent these actions
(non-purgable MAC address added, MTU of an attached interface is reduced).
It is therefore necessary to also make sure that the code is able to handle
also the situations when there were already incompatible system
configuration are present.

Cc: stable@vger.kernel.org
Fixes: a19d3d85e1b8 ("batman-adv: limit local translation table max size")
Reported-by: syzbot+a6a4b5bb3da165594cff@syzkaller.appspotmail.com
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4190,7 +4190,7 @@ void batadv_tt_local_resize_to_mtu(struc
 
 	spin_lock_bh(&bat_priv->tt.commit_lock);
 
-	while (true) {
+	while (timeout) {
 		table_size = batadv_tt_local_table_transmit_size(bat_priv);
 		if (packet_size_max >= table_size)
 			break;


