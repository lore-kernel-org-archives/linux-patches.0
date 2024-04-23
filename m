Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107014389A;
	Tue, 23 Apr 2024 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908474; cv=none; b=RctHoexlJEvceDdJQDze1x/e6zxBXuNf4lZuVc8kMYp3Vyn48dN2VBxKv3gChvK2DFKkBiKm7/1zckKUkl9lYQvLZuOyr1ty+E+4mVqdzGD5cLhK7bly0ddJhKZiTHVrpv61J/kdTLiWXTcMO01gRdmWvcxU/o2IoLw/cMuosAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908474; c=relaxed/simple;
	bh=D5eW49wq4pHJPo8zew5zlz/vCWfy5WUWwvq8H9tL2mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNzOtgRdBwTEw/7s1FMUULST1HbMmKRE6qPlYv/TUIY1TS8Oyjsg62j7y0SJ1EJXBr+c9U1nrUfOAHoLSXQK+YKrLMqsTcJsQyxcjUhCpTR9LMPDTEV0pMtG2Rmbz1UGfbT8FzTybuPcLKNK+osdjOhQCvIdhvFEjdjl/fBulTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvskIORr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvskIORr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95523C4AF08;
	Tue, 23 Apr 2024 21:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908474;
	bh=D5eW49wq4pHJPo8zew5zlz/vCWfy5WUWwvq8H9tL2mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvskIORravxlOxgEq2Xm7BTSeiYLRRVxr9R7k8s+SQ1VH6bZ4Mp41af5eFQ6q2C1s
	 VMR5UXwiguKsodXlb4MP8IZb2RjKVljgjDOU1I6jbTegLEkHQeTjqWrXg+Gba+fEZt
	 JLkbWZb6keyupV23es4eOhVgnksVG34UL8BGhnac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 042/158] net: dsa: mt7530: fix port mirroring for MT7988 SoC switch
Date: Tue, 23 Apr 2024 14:37:44 -0700
Message-ID: <20240423213857.272699746@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 14f1b8d08153f..f37dc22356f15 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1947,14 +1947,16 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 
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



