Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063245;
	b=EicC3yKnk8HEEnAWyzgeIwg2tooPdxasHZDy3l9v1N44A+uHzTwnOEScCy1et1e/Fk2u
	 WHHF5erHhHdivoDCPj3NXPbp+BBMDgF1IbZSp9UHQtYE6sKzlDZzIz754/cQMlb0FxmrW
	 TNGUVsg9RpxDxJu927DWTFKOHR0xInVwc1RaC4LBHhCJDuVHOYvOAAllTMRVW4hPqjNW1
	 ilFOWE/Ybp46ghsUrjdb8EVlB180/g0iRsGVL7HcOYlf0KcmixzseyulwroQaQ6X+Ai9f
	 dktccpTsTFtmXuLZc2zeMA3vgNJFsb6tbkmEDYwORpjXd3bmWO5FGO2xDgDGaYZf+MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62a9uqV4SKgDz8cDZkggAkD3d0r6AkLytmPOG/vstF8=;
	b=LlbgWrt+5niKqWmBIMqW3NIa8PlbuJkXFi6Ubmx5LZI4V3GhsGdHQtAfsKf4KW4oLy4p
	 e62QFq6tM8ua+93kNUa0hJXWSWPkp6yP2TjhxiMZZ66m047FagTammJMm47DKyRRuZmyQ
	 +OH6T/6z8pkuTSS4tKJeoWiG7G4Ito/E0freCqSQVovWRi8lb1AOT2B9hJeIfiqevg4mS
	 uDGKK2OEePRA1/CXckrALZrUAMGRUVuX5ODM8rOK/AqZSpCYjQmpahWn4eajD6WiHoLc1
	 ERcu1stCDPcNuhqvNm6/DlgRZaoJe7OyFK9Ig/QmJIEff+goGOWXWYyQOeCRG+9pyLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgBwCPY7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28070606A33A;
	Sat,  7 Nov 2026 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgBwCPY7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACBD1F0089F;
	Sat,  7 Nov 2026 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063244;
	bh=62a9uqV4SKgDz8cDZkggAkD3d0r6AkLytmPOG/vstF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgBwCPY76dPBCTnZ/U2Dxkgo57keTdPwv5Bhs67TZjXVc5LnW12NqGuaqxdskkX9F
	 xyLzNqgaMo8x7uBkYCa34iH6LZjbMIY7pDdHBqdNA8xmny20WFF+d0hldd0rNJ4Qqf
	 c4O0XCTaOilajHGPWTqTiYHrBXglDQZCOzPHmafg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/869] slimbus: messaging: fix leaked PM vote on tid allocation failure
Date: Sat,  7 Nov 2026 08:52:11 -0500
Message-ID: <20261107134908.951433076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit c26cc979e28f5193310e4379e14aa6417375c565 ]

In slim_do_transfer(), when a transaction needs a tid and
slim_alloc_txn_tid() fails, the function returns directly instead of
jumping to slim_xfer_err. The runtime PM vote taken earlier with
pm_runtime_get_sync() is then never released, leaving the controller
permanently powered up.

As txn->tid is still 0 at that point, jumping to slim_xfer_err drops
the vote exactly like it is done for other failed transactions.

Fixes: d3062a2109309 ("slimbus: messaging: add slim_alloc/free_txn_tid()")
Cc: stable@vger.kernel.org
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101448.1084691-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/messaging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/slimbus/messaging.c b/drivers/slimbus/messaging.c
index e2dbe4a66b703..ee127ef42046b 100644
--- a/drivers/slimbus/messaging.c
+++ b/drivers/slimbus/messaging.c
@@ -139,7 +139,7 @@ int slim_do_transfer(struct slim_controller *ctrl, struct slim_msg_txn *txn)
 	if (need_tid) {
 		ret = slim_alloc_txn_tid(ctrl, txn);
 		if (ret)
-			return ret;
+			goto slim_xfer_err;
 
 		if (!txn->msg->comp)
 			txn->comp = &done;
-- 
2.53.0



