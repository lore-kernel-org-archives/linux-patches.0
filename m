Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6545522D793;
	Mon,  2 Jun 2025 14:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874480; cv=none; b=q8XgIi/TEVcH1p6FrUQKmtrBwDyhXuQ9QqVd6ty3HtSCtl6wb0sCABjJLJnLpCDTfvIJuX0eGLCI7DCP7dUrKUNqcDSz9Ba+pamLQi7Aa+nS7C64T3kf7j9wpdwwXQ+DFt7MvblVMnBdQOOaD3dSW18TuNJo6AuuKoYWkU7zLgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874480; c=relaxed/simple;
	bh=LQkt0oPZBotWs49ZOcwQJ45MGu+utPn7hYzzu48bQhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTd2rf0TqGlicrhTO8pkcDp9os9GUnDfEiEfjXd3CdFhsWQiVKB5J/WgfCZ9PrFIEH5XghQG0B9Q1xOWPhNToOsyNoBG1xlZlIVWM4XNoxsvTdYOvuZnxqji9+MR/xwMIEqMoqE63iobaOngOS88OsC/CEMMZEOtGKMHlpfLXfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFkG/IXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFkG/IXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5937C4CEEB;
	Mon,  2 Jun 2025 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874480;
	bh=LQkt0oPZBotWs49ZOcwQJ45MGu+utPn7hYzzu48bQhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFkG/IXKxEoCjEFvsXS9AGoXliJLsrucTx8NnCO97ZoeKhTt/0GdbhpJSSRm+fnE+
	 ZItNHQSmZFTRd4RG7FLJxMyrTwvmJsw61T1aOah5tPZDSmzq1k5KH7mQqe3603vuGr
	 MeIrKWltbPH4PrYBDPCGA9BM0YhpoIOP0vigeygY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/204] net: dsa: b53: fix learning on VLAN unaware bridges
Date: Mon,  2 Jun 2025 15:46:09 +0200
Message-ID: <20250602134257.098320341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 9f34ad89bcf0e6df6f8b01f1bdab211493fc66d1 ]

When VLAN filtering is off, we configure the switch to forward, but not
learn on VLAN table misses. This effectively disables learning while not
filtering.

Fix this by switching to forward and learn. Setting the learning disable
register will still control whether learning actually happens.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-11-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 9f5852657852a..d41c9006a0281 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -381,7 +381,7 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
 			vc5 |= VC5_DROP_VTABLE_MISS;
 		} else {
-			vc4 |= VC4_ING_VID_VIO_FWD << VC4_ING_VID_CHECK_S;
+			vc4 |= VC4_NO_ING_VID_CHK << VC4_ING_VID_CHECK_S;
 			vc5 &= ~VC5_DROP_VTABLE_MISS;
 		}
 
-- 
2.39.5



