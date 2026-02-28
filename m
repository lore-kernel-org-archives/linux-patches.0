Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA4933F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301242; cv=none; b=K4/YYX2421fQNZXi3vKseY3izI5Zsv8UkbcXFLEMJewvn/5+mdi+yU2KraMAf8s1MXrKpus8rW7ViOHb3AOmtitiNIQqToVC/Vmjer2QMMrUhajUCyfsLBscV6VjjEtFOV5zmoRmMpSf3+su07YJ8jQdQnZoa07Yzhzahoxa7OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301242; c=relaxed/simple;
	bh=VCB41qA4rYJXQYjUsxH4Xxfa3XgWvLNeWlaY+p3XSeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/HkVDnysXjj0m9DbSQqhW4eWaE89AC4iZu/SHB/FzptgFMzLiGd5/Jakn1XW3X2+cbLcUdow4XMPCaJVye3HReCrHk0s2fPIrTFwhdeY9EnjdrCPqUYdzeXjF2mj/0pFfY42YutSdmtD0cHFDkjCDmR0oFkdNFRXPvRtddSDPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OW7yTihh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OW7yTihh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01530C19423;
	Sat, 28 Feb 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301242;
	bh=VCB41qA4rYJXQYjUsxH4Xxfa3XgWvLNeWlaY+p3XSeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW7yTihh+ql96Idgfj6mpYAfOVc4eNW94C/gjz4x5J3+i/WPvFMkJ2JfywOLhSKIj
	 TCG7gxKF3vOCqTwhHDVW+pu6/M3925n+1SqpcD80bGRCYUtaCww3r9BxOQszzRgH+y
	 b8NP41EQi+AFSVZqVLoeh790AaZBWhXmsUP4EA3zu6VWr4/LVzp+ZSCpH3tZiQKewE
	 w9L9S52mFS/h5h2o0U/e+s18yyiw51b1gZ+YxOzM/TspbgXs1kwstOCK0Flf+6Hgka
	 Y0qIpbGmM5mSMgxIL60ERiPQTauDzq3JVnDurwbSxTxIkHluyYKbrpPbywQ57smTys
	 qXpzRBtD25uyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 423/752] Bluetooth: L2CAP: Fix not checking output MTU is acceptable on L2CAP_ECRED_CONN_REQ
Date: Sat, 28 Feb 2026 12:42:14 -0500
Message-ID: <20260228174750.1542406-423-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a8d1d73c81d1e70d2aa49fdaf59d933bb783ffe5 ]

Upon receiving L2CAP_ECRED_CONN_REQ the given MTU shall be checked
against the suggested MTU of the listening socket as that is required
by the likes of PTS L2CAP/ECFC/BV-27-C test which expects
L2CAP_CR_LE_UNACCEPT_PARAMS if the MTU is lowers than socket omtu.

In order to be able to set chan->omtu the code now allows setting
setsockopt(BT_SNDMTU), but it is only allowed when connection has not
been stablished since there is no procedure to reconfigure the output
MTU.

Link: https://github.com/bluez/bluez/issues/1895
Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c |  8 ++++++++
 net/bluetooth/l2cap_sock.c | 15 +++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a5038160675ea..29af3f63e89ce 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5101,6 +5101,14 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		goto unlock;
 	}
 
+	/* Check if the listening channel has set an output MTU then the
+	 * requested MTU shall be less than or equal to that value.
+	 */
+	if (pchan->omtu && mtu < pchan->omtu) {
+		result = L2CAP_CR_LE_UNACCEPT_PARAMS;
+		goto unlock;
+	}
+
 	result = L2CAP_CR_LE_SUCCESS;
 
 	for (i = 0; i < num_scid; i++) {
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 814fb8610ac43..c877fe5aed07d 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1029,10 +1029,17 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		/* Setting is not supported as it's the remote side that
-		 * decides this.
-		 */
-		err = -EPERM;
+		/* Only allow setting output MTU when not connected */
+		if (sk->sk_state == BT_CONNECTED) {
+			err = -EISCONN;
+			break;
+		}
+
+		err = copy_safe_from_sockptr(&mtu, sizeof(mtu), optval, optlen);
+		if (err)
+			break;
+
+		chan->omtu = mtu;
 		break;
 
 	case BT_RCVMTU:
-- 
2.51.0

