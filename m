Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585B412FB31;
	Wed, 19 Jun 2024 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802403; cv=none; b=DP2bowmRXwXHr4Hb67X9QPhWSN0jw0HWxw11ob+AV4N25ejnJtrcmJMVGhVs5Axy2yzOWnib2snWVxbl5DCg1GGZQLJRcI6JV91mjo3gTH/emN7j8r7hCiu8QRY6RzWNz2gHxZ5us5gLFbbwKIwKGszdeo42osHSVmsT/YKD0gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802403; c=relaxed/simple;
	bh=XIbgUqSgG77x08uFR9EIj8P+DTWOw8Q0VPzbFJppY78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWOYOZcseeDnJIMXSMAMjDE2ionOK31Uc4XyxxELPHD08Rpb0gIk80zTi3ycp8pXFfLg4vbfyhKtX5JSGRL4zhO2eRjIS1BQiZG4BScGEddf2r2BZJKxS9ojfAwrFA77+QxMtoZ/6D86bve4/sEWImIsTeJaunCs8pv77OPj6ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO8F5sEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO8F5sEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5078C2BBFC;
	Wed, 19 Jun 2024 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802403;
	bh=XIbgUqSgG77x08uFR9EIj8P+DTWOw8Q0VPzbFJppY78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO8F5sEueR6u+vTiHFOJ3fFvEfElRrYjK/3rW/yRAzVIX0xEFr5v92kZOesU07CPQ
	 JlnH+FwoCpMA3slEgsaOocNl07BOJ5k5y1dOgkmzUAdHEz0a3OClz65Tpu1OpAAzK6
	 wNujgYbD4EuZsWMvYx8XY49gH4hc/FqqfHzx2SF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/267] Bluetooth: fix connection setup in l2cap_connect
Date: Wed, 19 Jun 2024 14:55:05 +0200
Message-ID: <20240619125612.255255820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit c695439d198d30e10553a3b98360c5efe77b6903 ]

The amp_id argument of l2cap_connect() was removed in
commit 84a4bb6548a2 ("Bluetooth: HCI: Remove HCI_AMP support")

It was always called with amp_id == 0, i.e. AMP_ID_BREDR == 0x00 (ie.
non-AMP controller).  In the above commit, the code path for amp_id != 0
was preserved, although it should have used the amp_id == 0 one.

Restore the previous behavior of the non-AMP code path, to fix problems
with L2CAP connections.

Fixes: 84a4bb6548a2 ("Bluetooth: HCI: Remove HCI_AMP support")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index d5fb78c604cf3..bf31c5bae218f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4009,8 +4009,8 @@ static void l2cap_connect(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd,
 				status = L2CAP_CS_AUTHOR_PEND;
 				chan->ops->defer(chan);
 			} else {
-				l2cap_state_change(chan, BT_CONNECT2);
-				result = L2CAP_CR_PEND;
+				l2cap_state_change(chan, BT_CONFIG);
+				result = L2CAP_CR_SUCCESS;
 				status = L2CAP_CS_NO_INFO;
 			}
 		} else {
-- 
2.43.0



