Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38130EF6B;
	Mon, 13 Apr 2026 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098543; cv=none; b=fbRiI+YeGh3Kk9OqjPqXhkTehc2rAAdLAtGhxLiR6ivhnf/khtpVtAdQyPY6z7+RwZKBQWFgzLLLURa/L1VWDfDh2Q8IGkLDKa3MimYZAJG9DDTc+3Hce6nFWEffsdRd2zUVWQoTeERAHKF/0WITdhRnMPhGIHWaYpLuoY8Dbws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098543; c=relaxed/simple;
	bh=D69PR1QrB30vONYtjIxIEuwaueQH3YFaIQwUpWR0xBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuJcfnbeJn2bPRIwgOjKDBcsb1anQWOiTXnV1wBctB/CGiJFs7ocJp3s8c/e38wlHFRpWho0Ra8eWpi67CR2mOQD67bUetFRs2G67kBlkq0gfCm7LnWffza/0EcSQVRTr+qaO6DvEpF0b6f43hSW1wK22B5mkkLn5PEEXQQ8dX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fk8FBC2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk8FBC2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EA6C2BCB8;
	Mon, 13 Apr 2026 16:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098543;
	bh=D69PR1QrB30vONYtjIxIEuwaueQH3YFaIQwUpWR0xBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk8FBC2ZJOQpAeJ7gGIpsPhYBAM0bnKD09NY3b0NYtXqo6cHrApTOkXg07blxrB45
	 knv90TWKDA/VKqHq8yef7SiizNtSJznDv1j4PeGXR77ndVmEYWWe6EEO/L/XnCCBDK
	 ACCb50bghOeibOSjzAsmvoMqs0RV4/7VRIhTsKAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 565/570] Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ
Date: Mon, 13 Apr 2026 18:01:36 +0200
Message-ID: <20260413155851.641533436@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6043,7 +6043,7 @@ static inline int l2cap_ecred_conn_req(s
 	u16 mtu, mps;
 	__le16 psm;
 	u8 result, len = 0;
-	int i, num_scid;
+	int i, num_scid = 0;
 	bool defer = false;
 
 	if (!enable_ecred)
@@ -6053,6 +6053,14 @@ static inline int l2cap_ecred_conn_req(s
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


