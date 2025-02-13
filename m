Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2C526B094;
	Thu, 13 Feb 2025 15:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459180; cv=none; b=Xmqo08I3X6cVkQkbP0z32ExoX8aIW9zfA4ra8SPoqS/8Bhhs71rDQJdUGvU5bXM6oisvrtntTxEpUpCewR7rSI5qi2GKSjhf0mzxxNMqBLjC95T7anjOXqoJddr+z+L4EhQUHgDSG/hrMoTFU+tmGAu1rmQLUNXkPQhYUviCQcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459180; c=relaxed/simple;
	bh=TNUd00VNclZeDb/rBL4wRkI5I4e2Q064vQpaE3HuQ+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg1VRhwmcyIGiIFpTzSuvGmrBheOck4OSHbhb9JfLLsIOHWNb5arCT2JPpnPu5l/lkiIlbic8YOOjxdiMLL5FeaPILKZ5/jxD5q3NQy4nBbVYS8ibhdinmT+4uqTpIZ2FOj3TrucVuB/Eql0QqonxU4lsVHj1c5/udQxBIm1mWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgtWA3ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgtWA3ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE97AC4CED1;
	Thu, 13 Feb 2025 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459180;
	bh=TNUd00VNclZeDb/rBL4wRkI5I4e2Q064vQpaE3HuQ+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgtWA3ev3pN49xvyFRL6BFy0GG04/1swhaWY8oT4RNLdVmu3RxCZ5pI3cW5jaLiyc
	 dmJLkwzmK5a9OrzUoNj8X3nSoM2Kt1F2YmoRRX09rl97l4GI59ykXqWEbbPTKXwsqP
	 j9xk4eWFWzif1FxS4lnDygDdhEBl+fsuO+R6zBGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.13 190/443] Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection
Date: Thu, 13 Feb 2025 15:25:55 +0100
Message-ID: <20250213142447.944363464@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 5c61419e02033eaf01733d66e2fcd4044808f482 upstream.

One of the possible ways to enable the input MTU auto-selection for L2CAP
connections is supposed to be through passing a special "0" value for it
as a socket option. Commit [1] added one of those into avdtp. However, it
simply wouldn't work because the kernel still treats the specified value
as invalid and denies the setting attempt. Recorded BlueZ logs include the
following:

  bluetoothd[496]: profiles/audio/avdtp.c:l2cap_connect() setsockopt(L2CAP_OPTIONS): Invalid argument (22)

[1]: https://github.com/bluez/bluez/commit/ae5be371a9f53fed33d2b34748a95a5498fd4b77

Found by Linux Verification Center (linuxtesting.org).

Fixes: 4b6e228e297b ("Bluetooth: Auto tune if input MTU is set to 0")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -710,12 +710,12 @@ static bool l2cap_valid_mtu(struct l2cap
 {
 	switch (chan->scid) {
 	case L2CAP_CID_ATT:
-		if (mtu < L2CAP_LE_MIN_MTU)
+		if (mtu && mtu < L2CAP_LE_MIN_MTU)
 			return false;
 		break;
 
 	default:
-		if (mtu < L2CAP_DEFAULT_MIN_MTU)
+		if (mtu && mtu < L2CAP_DEFAULT_MIN_MTU)
 			return false;
 	}
 


