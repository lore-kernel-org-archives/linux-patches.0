Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1C83F7887;
	Tue, 31 Mar 2026 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975003; cv=none; b=q9LzteNnogR52XIi9b9ufVq7oU8ZqYZzcaCMylDQZwzTsU4K9jfBukMkPL4xcwsmBREyaxU0029bu5VHilIESDgPOiJb8On2bRDihaT3y8HPgRukew4T3B6yy/JHl41xk8pGiXpSWcii7j2eRibS7cZCFFCjMMI1bHmOOlrZ6/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975003; c=relaxed/simple;
	bh=FZW+lvqXXghfr6ipYx4F4rHP73ANP87dmWsm/HEVmjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZcvALcUmvSAPffLO9iAlE56OroAMCD/PBBzVHNGXqT6/9Yc+ZOPhEYIU0pc3T3AlvvqJ3ciUSMuntWYUn5YRxLTzBTKUKaoxxJVMseVd97NdOabdMLQt9tn9XfRCDIWxUTG+Z7DNsOZnrHBSV9mb3/7x/lYCPIqrdIXNuUCuHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aomkaXLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aomkaXLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8079C19423;
	Tue, 31 Mar 2026 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975003;
	bh=FZW+lvqXXghfr6ipYx4F4rHP73ANP87dmWsm/HEVmjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aomkaXLIpbO33Fxw84SoJgbUdLUNlrnT+bOkHRK2botPz/00zsX/SaZxw3By4ZZsf
	 aNmsnLkBu/nl1AS7YNcZQP2+nWCRKDUSjghChRvGtcKj19444mdwPP2ZL8CwTUTXQV
	 bAjAHGJo8wT1NoS2wTd0KFEc7MENc80x+Jqmjr10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b7f3e7d9a596bf6a63e3@syzkaller.appspotmail.com,
	Minseo Park <jacob.park.9436@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 093/342] Bluetooth: L2CAP: Fix stack-out-of-bounds read in l2cap_ecred_conn_req
Date: Tue, 31 Mar 2026 18:18:46 +0200
Message-ID: <20260331161802.442130054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minseo Park <jacob.park.9436@gmail.com>

[ Upstream commit 9d87cb22195b2c67405f5485d525190747ad5493 ]

Syzbot reported a KASAN stack-out-of-bounds read in l2cap_build_cmd()
that is triggered by a malformed Enhanced Credit Based Connection Request.

The vulnerability stems from l2cap_ecred_conn_req(). The function allocates
a local stack buffer (`pdu`) designed to hold a maximum of 5 Source Channel
IDs (SCIDs), totaling 18 bytes. When an attacker sends a request with more
than 5 SCIDs, the function calculates `rsp_len` based on this unvalidated
`cmd_len` before checking if the number of SCIDs exceeds
L2CAP_ECRED_MAX_CID.

If the SCID count is too high, the function correctly jumps to the
`response` label to reject the packet, but `rsp_len` retains the
attacker's oversized value. Consequently, l2cap_send_cmd() is instructed
to read past the end of the 18-byte `pdu` buffer, triggering a
KASAN panic.

Fix this by moving the assignment of `rsp_len` to after the `num_scid`
boundary check. If the packet is rejected, `rsp_len` will safely
remain 0, and the error response will only read the 8-byte base header
from the stack.

Fixes: c28d2bff7044 ("Bluetooth: L2CAP: Fix result of L2CAP_ECRED_CONN_RSP when MTU is too short")
Reported-by: syzbot+b7f3e7d9a596bf6a63e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b7f3e7d9a596bf6a63e3
Tested-by: syzbot+b7f3e7d9a596bf6a63e3@syzkaller.appspotmail.com
Signed-off-by: Minseo Park <jacob.park.9436@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9ea030fc9a9cc..583fe3b654c11 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5065,14 +5065,14 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	cmd_len -= sizeof(*req);
 	num_scid = cmd_len / sizeof(u16);
 
-	/* Always respond with the same number of scids as in the request */
-	rsp_len = cmd_len;
-
 	if (num_scid > L2CAP_ECRED_MAX_CID) {
 		result = L2CAP_CR_LE_INVALID_PARAMS;
 		goto response;
 	}
 
+	/* Always respond with the same number of scids as in the request */
+	rsp_len = cmd_len;
+
 	mtu  = __le16_to_cpu(req->mtu);
 	mps  = __le16_to_cpu(req->mps);
 
-- 
2.51.0



