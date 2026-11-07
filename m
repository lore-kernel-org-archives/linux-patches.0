Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062542;
	b=VBFYr/INc+5Su4miaiYP9yzHiYfPSkB5dGCqihvQ6FHDIAuiZ5lIHtXdsaPK+Suyd0qV
	 D1ZqFgksL9GiD7Lz21OI6TF0OwKgD217eL4MMb4nvbfFdT3vQmx6LRPOmW5cutwN2YNpu
	 QWAbNZl0PNmRKrEY9u9on48uq5cx+trJQTfMDBz176J94DlVyBC1r2wQ4B5mvqBNv3vE5
	 pFtk+mTlyoOyb870FvaQbVga0fBUUVlk2e/drrqtrnAw87BqjghYntwyC9ZgSpXQWkfVV
	 XUNAZfsGa5V5P3ipjN9uwO4G6Av90Vwvk7RKKRnRJqQVxrcjNbCx4wef4b0H7FOboKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUewd9SpG5Q2G9CfnUMcrrhB30Amtsycj9jB+vM6Tzo=;
	b=aGj9KgnBs6V0Ifqwn/6+76V22v03Mq9rbJJVDI8JBO5HiBIyX3ErITdYa0go7qONMHex
	 EFGePUhkmH9eXlvEUO7CrmcIw9kCa4xjoY2ivR8qJu2dbXjFjvld9qDz5DBjI24nsfWu4
	 6dn/Lp4Va86UIl5xHmGxPg70M5UHoR34jHM2aoUlvkJvHP2KMT7Dp8xxjKvspoHzCaNJn
	 gEeJAu7bjen5Ulj4js9bIuTH36Hru5PqFHFo1whF1CdN2YcBby2yQOh6HX8NWMj3znflA
	 VcDsj17ZAcdOb4ECC3geEnpOVQVrN3OKRXRNlxXwPEvly3fxlM039exbehpZoCwj3vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0tWNA2Kl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A923F606A334;
	Sat,  7 Nov 2026 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0tWNA2Kl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568C41F0089F;
	Sat,  7 Nov 2026 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062541;
	bh=ZUewd9SpG5Q2G9CfnUMcrrhB30Amtsycj9jB+vM6Tzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tWNA2KluaEWCU80HugZrpUw0LoZpl1qQw7Te0dnBiM1Azoi1ZIlGb7i5AfGP96zB
	 MtaKCh/JZeZ47AV0mAitfBnIDuTb7q+wodvXLcv00XqTyV8XMGbrl41k5cEvN3MAb6
	 YHgN7hXo2Mw70LzqoQkebK6GwnVzN8kedQe6nFkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yanxia <yanxia@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1430/1536] veth: fix stale peer max_mtu on XDP program replacement
Date: Sat,  7 Nov 2026 08:57:26 -0500
Message-ID: <20261107135037.998686538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yanxia <yanxia@cmss.chinamobile.com>

[ Upstream commit c955325db639e9503941227e14e1f1ccc99442a1 ]

veth_xdp_set() calculates the peer MTU limit from the incoming program's
XDP fragment capability, but only stores it when no program was attached.
Replacing a program with one having a different fragment capability
therefore leaves the peer's max_mtu stale.

Replacing a regular program with an xdp.frags program keeps rejecting
otherwise valid jumbo MTUs. The opposite replacement leaves a larger
limit in place and permits MTUs which a fresh attachment of the regular
program would reject.

Update peer->max_mtu after every successful attachment or replacement.
Keep the GSO feature update conditional on the first attachment.

Found during review of the XDP replacement path and confirmed with
native XDP on an isolated veth pair. Before the fix, direct replacement
rejects MTU 9000 after switching to xdp.frags, and accepts it after
switching back to a regular program. Detaching and attaching instead
produces the expected results in both directions.

UML tests on net reproduce the problem before this change and match the
detach/attach controls afterwards, with both devices up or down and
with either endpoint receiving XDP. Failed replacements preserve the
previous state; same-type replacements and detach also behave as
expected. Small-frame traffic passes in the devices-up cases.

Fixes: 7cda76d858a4 ("veth: Allow jumbo frames in xdp mode")
Cc: stable@vger.kernel.org
Signed-off-by: yanxia <yanxia@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261020020147.790274-1-yanxia@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 31b9c9feb47d9..564bf57bc8979 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1621,10 +1621,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			}
 		}
 
-		if (!old_prog) {
+		if (!old_prog)
 			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
-			peer->max_mtu = max_mtu;
-		}
+		peer->max_mtu = max_mtu;
 
 		xdp_features_set_redirect_target(peer, true);
 	}
-- 
2.53.0



