Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C0D36CE19;
	Wed, 20 May 2026 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300260; cv=none; b=fyTm81LZ50I24wEx4LR69F0e9QwwOMP0gcDHutuPxLWcLC3umkEure2ku6f3VtFiH+NvPYzuYNg0GaDggMzCjxSIfTliYBBJsfX7nbdFwjXj7f9GygQgW/z4zJiaJ0SZajlwMebokPmlkyJ3YWjvABcnbli0CnPre485Hn33TXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300260; c=relaxed/simple;
	bh=K19uBbxqFnC/ENN8AwKg/2wUulXVLb7Eagiz6lGxJ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjZ2trmc5azwvWrvbaNnP5xzB9OL2v8VBTNV8U9fgOOKhNXCSqfpn3E3E7f4Oq2bGnVr3oimg2KDsp3ZX1tSMMnhsBv0PsdpPelU8YnAhN19HQ+1QGrDcavWp9z5VpFk1kbofB1yzmWcnXR3opa+eSTiEKKz8CZm5LkCor6x9eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2y5rec1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2y5rec1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B851F000E9;
	Wed, 20 May 2026 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300258;
	bh=YbxPHWP09iZ04Rp2PMVHRT8v/y1dqvMUSQD/m3bXYV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2y5rec1kzPAup8wmB6IGh6GsSk7qK0wOLuRR9Uuy0cKY6x88nrvhv4arV+XwwLE/
	 pI8A3C34/wEapku/Rc9MshFhfOfN2P10tZol5or4jkgdlem8BFQigsaLBaDAqymfL1
	 wDzRc5kmHqrnRSvfJM9y+e+SrN8gZ/S6jk9BVIuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/666] Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU
Date: Wed, 20 May 2026 18:15:17 +0200
Message-ID: <20260520162113.518650711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 15bf35a660eb82a49f8397fc3d3acada8dae13db ]

The code was printing skb->len and sdu_len in the places where it should
be sdu_len and chan->imtu respectively to match the if conditions.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: e1d9a6688986 ("Bluetooth: LE L2CAP: Disconnect if received packet's SDU exceeds IMTU")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 307f7fe975b59..bb927603c2d15 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6657,7 +6657,7 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 
 		if (sdu_len > chan->imtu) {
 			BT_ERR("Too big LE L2CAP SDU length: len %u > %u",
-			       skb->len, sdu_len);
+			       sdu_len, chan->imtu);
 			l2cap_send_disconn_req(chan, ECONNRESET);
 			err = -EMSGSIZE;
 			goto failed;
-- 
2.53.0



