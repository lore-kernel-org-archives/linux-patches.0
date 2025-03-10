Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E3E17CA12;
	Mon, 10 Mar 2025 17:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629351; cv=none; b=DQR9K+U8JyrbEsbu6JrgrqQg0nAJGxYFPl5S0jJYNpyhnXT/2UohHKl5vRP+imf/BDorjJ0qLiEwZ9dqPuwjvwWPO1CHz85Bv7Rc3pJytqfJI9WFfHds8v62k2+VHkqQpmA8X2blK9v+6fn6CuZ7/IuJrIHa4nmh8txca8JN7FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629351; c=relaxed/simple;
	bh=gAm8ShSQRiH9SbxLMJP95YoSk1PEu0YpjGt6IPQCwYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgTgy4vNEhCxJei0BrKRCDX9WIWDrNjwVML4DFbW0bqeeqSeVdQj/DmA1l+I0MrRJO72T3vGnsnPqKl8zNKwte4v5bJCBgln/rKxw60ya40A+GZEvkftxckupA1rBoFvdqpn/Ce7ACCBcIA2JMIfH7/HpY6F9sXfk3fI5RlM1c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rgPyfuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rgPyfuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FF3C4CEE5;
	Mon, 10 Mar 2025 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629350;
	bh=gAm8ShSQRiH9SbxLMJP95YoSk1PEu0YpjGt6IPQCwYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rgPyfuM4sy4WQPAoDWT+uZwvgG8E1x3jrNTONJKd6KRw24hmYvNuPL78jw4qAd4X
	 bYyJ7ZcZTMl2z/LRPJ0Xfb7BD1kxE7RaSILPuze97MUcGkaJ+bTu7H3MvjUDkxb744
	 R3EhbfhXivfKtOS5t7MvKq2UtVe1MVSs0u00NjAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 265/620] Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection
Date: Mon, 10 Mar 2025 18:01:51 +0100
Message-ID: <20250310170556.084894132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -727,12 +727,12 @@ static bool l2cap_valid_mtu(struct l2cap
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
 


