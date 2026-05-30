Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5917D2690D5;
	Sat, 30 May 2026 17:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160719; cv=none; b=PObtTptAPdEcW0yC0DeoTr++J9O/gga/SHq7SNLjyxr3wrYBoYHy5sOp6LnHnedLl3Abw5Dw4+RSTR0P87Oymu7eW67u4LmQdwBZrefMVVBuczb3Ha+4XRRBnwyrvAVeWSYuAAo4UghkcBwPsH5px3+uyd6IwUtahzcrE4PKjhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160719; c=relaxed/simple;
	bh=XDpoq+or2Mela53TV4nXU7kxxPwl1WOPOj6Nzt0wl5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNWYdqhe1aQvtX7USpCl7tdHUMnTUkrvipX6/EWDPMy5OFBFdfQJLAK9AGpkowMgrYOLIjirZF9XbmybM5FiVEfNm79SZZvzj+dE5A4WfHCS1PcRt/cbv3JAQZloOk7TVr40FkyMk1X2LVexAhI6oAXlqbjfFXSZ0nbaC1eE230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lxp4v23H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lxp4v23H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFCD1F00893;
	Sat, 30 May 2026 17:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160718;
	bh=nnccGVOyZg+0Bu04iyQ5hRyQidfHVyrRPsYjcn5RfO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lxp4v23HscsLzwdYAMKNPtdxHXmgSDPbNj+Iy4/4tuHyRs4E1pjRuOXFjIxErsy3V
	 sswqvLIjxicuXi1fM8QUEKD9JGt5YlktOiHpbZY5PC9o6icNdBpoKRLVPUnXEjOW9E
	 0YjD1unzTdDHuLJ0x+CIKrUT9x2sZBUtPem5oVsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyes Bourennani <lbourennani@fuzzinglabs.com>,
	Alexis Pinson <apinson@fuzzinglabs.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 416/969] batman-adv: fix integer overflow on buff_pos
Date: Sat, 30 May 2026 17:59:00 +0200
Message-ID: <20260530160311.760905066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyes Bourennani <lbourennani@fuzzinglabs.com>

commit 0799e5943611006b346b8813c7daf7dd5aa26bfd upstream.

Fixing an integer overflow present in batadv_iv_ogm_send_to_if. The size
check is done using the int type in batadv_iv_ogm_aggr_packet whereas the
buff_pos variable uses the s16 type. This could lead to an out-of-bound
read.

Cc: stable@vger.kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Lyes Bourennani <lbourennani@fuzzinglabs.com>
Signed-off-by: Alexis Pinson <apinson@fuzzinglabs.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -335,7 +335,7 @@ static void batadv_iv_ogm_send_to_if(str
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	const char *fwd_str;
 	u8 packet_num;
-	s16 buff_pos;
+	int buff_pos;
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	struct sk_buff *skb;
 	u8 *packet_pos;


