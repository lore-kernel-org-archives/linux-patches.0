Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4164F12FB27;
	Wed, 19 Jun 2024 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803126; cv=none; b=UNGVU5fAKA0jqj0Pe8INXBRcCuN1RGX92/QJl2SlLW6DntXXJNOZqfY1JCzrKsxQlT03CW88LFBvMH05OC4CNG7loFMCYFv+vG1UCy2F8XybQ7kvTS+/IDGU8Lp1EF470DUwGrVNB36L49NpuGdCHXvL4sZoDxT12BLi0cQRGxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803126; c=relaxed/simple;
	bh=S0rKqFKger+PIyyf2v5CGYDNj6zvL1imQMQHONHBNLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXN0McTF1+++PDGTUsDAqUzty0DhOriOCDC0p7Bxxt0F1dtcYlcOZq0rul7SB3jmCi9sLoe1h8hHeuuRfzbBsICQIX9DjcV06Y041nPkrFSLzxOVtLeOl/wodftYB5dezwaE/NTd3bQO7mYYb+b7BYywSHBMkxkZltZZ8zVJsBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iAusYPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iAusYPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E122C2BBFC;
	Wed, 19 Jun 2024 13:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803125;
	bh=S0rKqFKger+PIyyf2v5CGYDNj6zvL1imQMQHONHBNLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iAusYPEAseIgEXlEY2XDSuIRyQB3M/kGUaeCIi9PhsrqMyPDBrc8doiKILuwGEc+
	 JsoKYbBrhDjljP2URcMKEUp1a5a8DUkNRIuKhX4QOwvCHGMuZJYhz1dRC+zFhIbqTh
	 CbVtI8igbYpbHx5zBtzxDyE+V3H5fLMQKFWl/Ahg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 161/281] Bluetooth: fix connection setup in l2cap_connect
Date: Wed, 19 Jun 2024 14:55:20 +0200
Message-ID: <20240619125616.034723969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e3f5d830e42bf..9394a158d1b1a 100644
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



