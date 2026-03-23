Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD69F38CFE1;
	Mon, 23 Mar 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277357; cv=none; b=WZPSaRP7bgCl0Nt2prM6dJyQyAtwjZmULrXvrAi6lO/qWuMftlfb77MGOgdweKHcOvExfxT8aFl9ZQQw1RJ0T5GBaEN7o5KGueB3ojblu2dGDmejzLlNG9Vdy7tA/561TOZjhoxItVUrF1ikOz2sFcCuaRv+K55yZBg5Xe3Pp3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277357; c=relaxed/simple;
	bh=Qad2mGiK7P/Fxt2pA8iDuyOwMOO949HpR+p9LZxy6tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgEOj0yZjNqupR/1el7gf5UqxFrvGSwjvLs5mrNyTXa1fmyIIGBnq03Te/Sr2vMDPjIQbMIiIfvBrtcmWg8dnen3Ac4z0ua4bgVq87k2pbhus6yzh4KhzYUXsFocte/PMMxp36JaKib1u41ot/Pd4mOyHG5ILsVAsKSiSSvL4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrsc3f9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrsc3f9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7E3C2BC9E;
	Mon, 23 Mar 2026 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277357;
	bh=Qad2mGiK7P/Fxt2pA8iDuyOwMOO949HpR+p9LZxy6tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrsc3f9HfRU13cztk/th2p2wumkcO/TX972z78wt3f+c768qPEtqwV6uy7BASgNuy
	 hPN6dPjBtz8gKKlY8cQokBGXoRlw8W6l3aVdaSIWAr7sXQVCiaog3Wh3OatKx3Ok5o
	 Z9ZsfGb8/O4W8j6gnTeXuXnQuszATUzyXGqkT7QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/460] Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy
Date: Mon, 23 Mar 2026 14:46:18 +0100
Message-ID: <20260323134535.957072043@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 0e4d4dcc1a6e82cc6f9abf32193558efa7e1613d ]

The last test step ("Test with Invalid public key X and Y, all set to
0") expects to get an "DHKEY check failed" instead of "unspecified".

Fixes: 6d19628f539f ("Bluetooth: SMP: Fail if remote and local public keys are identical")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 3a33fd06e6a4c..204c5fe3a8d08 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2743,7 +2743,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (!test_bit(SMP_FLAG_DEBUG_KEY, &smp->flags) &&
 	    !crypto_memneq(key, smp->local_pk, 64)) {
 		bt_dev_err(hdev, "Remote and local public keys are identical");
-		return SMP_UNSPECIFIED;
+		return SMP_DHKEY_CHECK_FAILED;
 	}
 
 	memcpy(smp->remote_pk, key, 64);
-- 
2.51.0



