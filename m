Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B86030E0DC;
	Sat, 30 May 2026 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163826; cv=none; b=dVUo4Sk/BVjwcqr6dQWFT8Mefq7FaxKQG45SEckiEex5cJb6ZEmmFDahTGWlgDvYKCx1VhRxfR4ZDL1L5146SMOeA7QYvtF0eDXJG8piroKUaiAxuoX+v/IbDKLyNgMMbOdFpwZGf1S+WB2fw3FqQWJXNyetw1pflwSHN1m9AIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163826; c=relaxed/simple;
	bh=bzeTaBtHNMrgnfm1Zfim7q25G8lRd7ykEsIHGIaj65I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPyvhJNXnGNYmeB3AUg5Oo/mfrjeOwXog3Fg83iNss9fZfRPMn390uNRJGoieOfJimZbzOeBrOFMxWeqpGcMQ9auFkrP8TzfXVYXx/V1i5fmw3ZbDNDyDtk4A/eHpIdroHWa8b3kUVL3VVdKhZld1MQTQkaXJCXWrUOyZCnMWiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXh0+k21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXh0+k21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DB01F00893;
	Sat, 30 May 2026 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163825;
	bh=uuI48wPCzJqWrWwYALqux5aOO5wHHWbqISmnHE+vTZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXh0+k21k3HHAzvoA3JqdUFjTvRUVnTS8AwD4E6IXyi8Y2pvxgTbZV08chm09bkqH
	 HYob8gnrY2UrYeCXw0fWP8hUz+jMlf7rOonK5U5CFNHxYDRdoNqfsFxRh9xpq8fdB4
	 lsTLWoyPpebZG/4PsR+BpwC4Okj6i26DSAjbbnTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyes Bourennani <lbourennani@fuzzinglabs.com>,
	Alexis Pinson <apinson@fuzzinglabs.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 374/776] batman-adv: fix integer overflow on buff_pos
Date: Sat, 30 May 2026 18:01:28 +0200
Message-ID: <20260530160250.201315172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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


