Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A411A5BA4;
	Tue, 11 Mar 2025 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706811; cv=none; b=pqB+m47tWiy8P1GNXILciPvf+3YnFLUz48umQseKuZ0GTs76R2rx4Nih+A4EcNVu6br+z6hS468kckuo3+70+PEI3a5uxShKSI6hJwmHpQBleLLkonCsZqQzpLgG9zE1LpkX4s6nxwp1pNMYdVDuiYfoggw1h6Y4fimBBdiriew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706811; c=relaxed/simple;
	bh=n5YzSNXlrPJLF9wqOWtvpwGSOz69Ee3C7KEZKt4+oKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN4nPw6Kr0IzqFuh6/3YSVhjuW4fYq9Ikh7Wtb+qmbMoChI68SmWg7dIiPUP4F6AxFq2fsgZytG1H2DOtaF8CNtrCCNE/8yrAcanpl9/pbTBmw2stib3qgXUFVU5+L8qOCiy8qoY6Ui6XXzlt4anGH03BUthh4NgPUoNWO/KOB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0fzKlg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0fzKlg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA0DC4CEE9;
	Tue, 11 Mar 2025 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706811;
	bh=n5YzSNXlrPJLF9wqOWtvpwGSOz69Ee3C7KEZKt4+oKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0fzKlg6CqHAM7EFFIWxLEdHEAnA2oy+/MeOp9t3UEh3dgQK3aPMxCkAd4+cECK+g
	 fsXCDq9SKlpAdeza+5cmvSmzpcUAKEMYxN0L/41sv8/qFVbFnRn/7MnB7KWjqWi2pa
	 3ZT3/r6XgYV0V0joaVJH6H7HQM7gspmmpcypeoJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 174/462] Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection
Date: Tue, 11 Mar 2025 15:57:20 +0100
Message-ID: <20250311145805.229641063@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


