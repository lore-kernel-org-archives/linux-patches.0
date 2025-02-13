Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF362143736;
	Thu, 13 Feb 2025 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460528; cv=none; b=SwkwzHZbV9Rk9ahwY95TtLH24c1V0uwrobYTQAl/JvPYVcse1iJ8A0BGkLjlFXJ9dt63k4er3ez7sYaRQfRZTVWfeIiRQS7GCE+Cv8dihd8OrUKCYLvVHeG8U88u6ZvPgn2ZUe6Wa6pt1P0ystMG8x/a6a2bb8z2ORGQhD+ACFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460528; c=relaxed/simple;
	bh=1tJVKv/XsxTaNSBtP4k4sOiwF+sieXPHEfK6HYoUVzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp+FVURX3OMiPW3ilNt8N1RzwcxEWASs1Ec/RaOWdNAtA5bZ4ENSd5I/AZWtpLMAEWOE3+PC82qD9366bjmDyYx6gS9uAc8mZMKkCenfqpfG7Jy7FW5zvraciCFHAAUOMNq0vDmDFwEqVmVpEsQkNXvqIgktLZQ/CkC6T2b27WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASZSGQVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASZSGQVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B670C4CEE4;
	Thu, 13 Feb 2025 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460527;
	bh=1tJVKv/XsxTaNSBtP4k4sOiwF+sieXPHEfK6HYoUVzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASZSGQVn+aRuQoy24+riX7BXQd5LqwPh/kCCbW4kW5XdAXV9rVOsbFlcV1s92+sbY
	 HWeKYZzaULn5iBBzURt3q6RmTuqUIwRw9gBRN+zZJQMPo0U8+bcHc/+23jZt+1frUz
	 AGqC3QW44/WjGt34OdxqM63bynDD8P9uEQETguzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 105/273] Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection
Date: Thu, 13 Feb 2025 15:27:57 +0100
Message-ID: <20250213142411.496550709@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -709,12 +709,12 @@ static bool l2cap_valid_mtu(struct l2cap
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
 


