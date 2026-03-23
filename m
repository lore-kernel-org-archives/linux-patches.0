Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA9B1DA0E1;
	Mon, 23 Mar 2026 16:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283205; cv=none; b=ajomKE7we48ShdOeQVQgtDQgB9gzamJYAPUee/v2VioiT1SC7My3sScUrTf2eWSwCmJPEooNRDfMJ3sSS6E95g+YEmW1nDZ1YDnCSGajzAUMw9BCcLgdF9wcivcFKiJ7YO2RH+opZeEN3hfJM23QY7zrxYMZlL9aT65uiWPY1Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283205; c=relaxed/simple;
	bh=RdSpidvOcgeeaL2s/ygUgrz6nuWvdiVSjDlLHiwT+Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW3s6Bp4nE8bWvqXb7g9O+2BpBkeGJV+Ive0/oqmuYAxowyemEgA3mbfOkbNQ+VYcHnAZddybKmOCYlbQWYv5PcHlnF8RSqtbQtJT+GfwX0TldyCj+yVUJKHXg5anj7lYwUA2ynallNZAYbWyXHpKCgWcKVz8AwEs0PpjkHQJxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSGIVpXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSGIVpXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07A8C2BCB3;
	Mon, 23 Mar 2026 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283205;
	bh=RdSpidvOcgeeaL2s/ygUgrz6nuWvdiVSjDlLHiwT+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSGIVpXO7Vj5lvoaNStvwrXQFPHwG5fy6fXAm64q3MDdELuRZ9ryRBxQqYEc12CUq
	 xywpdsGe+zPgtOQALhR7HywYtVEy5jOEDxEZSImCLXjB6gqJMHRIlUF7IbcGQ7pq3V
	 HkUR4hsDCZt/aLsq7OHvxwomy/l9vwwNyO/TmcFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/481] Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ
Date: Mon, 23 Mar 2026 14:47:03 +0100
Message-ID: <20260323134535.959840831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5b3e2052334f2ff6d5200e952f4aa66994d09899 ]

Currently the code attempts to accept requests regardless of the
command identifier which may cause multiple requests to be marked
as pending (FLAG_DEFER_SETUP) which can cause more than
L2CAP_ECRED_MAX_CID(5) to be allocated in l2cap_ecred_rsp_defer
causing an overflow.

The spec is quite clear that the same identifier shall not be used on
subsequent requests:

'Within each signaling channel a different Identifier shall be used
for each successive request or indication.'
https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-62/out/en/host/logical-link-control-and-adaptation-protocol-specification.html#UUID-32a25a06-4aa4-c6c7-77c5-dcfe3682355d

So this attempts to check if there are any channels pending with the
same identifier and rejects if any are found.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ adapted variable names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6062,7 +6062,7 @@ static inline int l2cap_ecred_conn_req(s
 	u16 mtu, mps;
 	__le16 psm;
 	u8 result, len = 0;
-	int i, num_scid;
+	int i, num_scid = 0;
 	bool defer = false;
 
 	if (!enable_ecred)
@@ -6072,6 +6072,14 @@ static inline int l2cap_ecred_conn_req(s
 		result = L2CAP_CR_LE_INVALID_PARAMS;
 		goto response;
 	}
+
+	/* Check if there are no pending channels with the same ident */
+	__l2cap_chan_list_id(conn, cmd->ident, l2cap_ecred_list_defer,
+			     &num_scid);
+	if (num_scid) {
+		result = L2CAP_CR_LE_INVALID_PARAMS;
+		goto response;
+	}
 
 	cmd_len -= sizeof(*req);
 	num_scid = cmd_len / sizeof(u16);


