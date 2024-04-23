Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A38144D15;
	Tue, 23 Apr 2024 21:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908593; cv=none; b=gh3TL3MmjgqSNCjU2PxyASFV11AcP7RfLOrYGxaZQkyyXTHWvLHP8Ar4dRZ6qOpAoPhG6iAz2bIcJ+IouMAFLgsckIcQt5cyda04POC49tfAubRCMVqZsYr2HAjZN4B5Fqs0lY5WcAlxsDR5dhfvOrcfn6fHZ3KMAUYzZrGbtcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908593; c=relaxed/simple;
	bh=pqRU7fKaNHtXrZF8ebXY2AxqdGNCHk8cqFRJXUwZl6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFBcdaJoHvbkyotGZcu7fobVD3XVYOpSHMA06J7OGbRd87eseeiCek0uHxHtjQ2cMPhR0z8hegRjNmcBruWWupjND7HLD209N2Q2G84RLnH+79W8RaVEy6Ek3xDsDJk5gempuU8iW0ldf6PfZ9gUtjxXoJXAkqOy82tcU/I/iWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3BE0u54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3BE0u54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2225C32781;
	Tue, 23 Apr 2024 21:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908593;
	bh=pqRU7fKaNHtXrZF8ebXY2AxqdGNCHk8cqFRJXUwZl6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3BE0u54V+F8yoKL7lZtTLZTNnyVSCu9ZJ+u9kCGoJFqkZk6qK8F8ofMgGn8knVEZ
	 VTvmtbd2ZZmmckN44cMztloofh0ine1OO138qLHsaWa+qqktKqRoTlTuVA9NtmXb/c
	 Z0IRV69bzrlVaE2BR4CapQibszOgRhZh/IthvQHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/158] net: dsa: mt7530: fix port mirroring for MT7988 SoC switch
Date: Tue, 23 Apr 2024 14:38:11 -0700
Message-ID: <20240423213857.531194574@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 2c606d138518cc69f09c35929abc414a99e3a28f ]

The "MT7988A Wi-Fi 7 Generation Router Platform: Datasheet (Open Version)
v0.1" document shows bits 16 to 18 as the MIRROR_PORT field of the CPU
forward control register. Currently, the MT7530 DSA subdriver configures
bits 0 to 2 of the CPU forward control register which breaks the port
mirroring feature for the MT7988 SoC switch.

Fix this by using the MT7531_MIRROR_PORT_GET() and MT7531_MIRROR_PORT_SET()
macros which utilise the correct bits.

Fixes: 110c18bfed41 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a123bb832db91..ea59f19a724c9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1948,14 +1948,16 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 
 static int mt753x_mirror_port_get(unsigned int id, u32 val)
 {
-	return (id == ID_MT7531) ? MT7531_MIRROR_PORT_GET(val) :
-				   MIRROR_PORT(val);
+	return (id == ID_MT7531 || id == ID_MT7988) ?
+		       MT7531_MIRROR_PORT_GET(val) :
+		       MIRROR_PORT(val);
 }
 
 static int mt753x_mirror_port_set(unsigned int id, u32 val)
 {
-	return (id == ID_MT7531) ? MT7531_MIRROR_PORT_SET(val) :
-				   MIRROR_PORT(val);
+	return (id == ID_MT7531 || id == ID_MT7988) ?
+		       MT7531_MIRROR_PORT_SET(val) :
+		       MIRROR_PORT(val);
 }
 
 static int mt753x_port_mirror_add(struct dsa_switch *ds, int port,
-- 
2.43.0



