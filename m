Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27E31BC9E3;
	Tue, 27 Aug 2024 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771554; cv=none; b=G6i9L/A/T+hHDwq1NfC5Uyt0FvfbFtG8coQIOMQwabv3wdPDui55wL0EM6e10fugOCM7bfZchoyJFdoBRFSrQYwucZtiX7Gp9+qht+YExCoWA73Io8YWE88puls02TOFO2rkrS4YdZVIPDS0kunBljFvsbiXDySBq7PP+QgfnY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771554; c=relaxed/simple;
	bh=U3NRBUm/qCCfYQixEsNc81OQUmERtrZTIWfxzGX/07E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM04AwwgO1oTk+R9bPhr/T+yjBAkdDNcMCZDT1tCMqEK/Q9+qVonzIa1gFI2gLijxYgLe9ZH7heo+KYY+XMTEc01G57Gtycp5UpicgowbCRY2LiNHUFGZa/hSAJYP/s5lYRix1N7qswpH/K06D5brTquM7XE3huVAt/hfxBspJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osMOqvMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osMOqvMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3D8C61042;
	Tue, 27 Aug 2024 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771554;
	bh=U3NRBUm/qCCfYQixEsNc81OQUmERtrZTIWfxzGX/07E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osMOqvMebrGVj7y1mgkRCr2Zo6Ya9PPg4GWRZ0BFt8Vbcu82ZTQraIOd7oTPBg0iA
	 uAoq3luLSgKjxq2Wk/Kbnl9qzavsaW5IwNvoHHcwvQo0s90txQG0jAw7EdtJpR4Ca9
	 sWYv2zkURhrKSvSUGwliO4cI7NqJe1WqLgInjS5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.10 223/273] Bluetooth: MGMT: Add error handling to pair_device()
Date: Tue, 27 Aug 2024 16:39:07 +0200
Message-ID: <20240827143841.891765550@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 538fd3921afac97158d4177139a0ad39f056dbb2 upstream.

hci_conn_params_add() never checks for a NULL value and could lead to a NULL
pointer dereference causing a crash.

Fixed by adding error handling in the function.

Cc: Stable <stable@kernel.org>
Fixes: 5157b8a503fa ("Bluetooth: Fix initializing conn_params in scan phase")
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Reported-by: Yiwei Zhang <zhan4630@purdue.edu>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3457,6 +3457,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


