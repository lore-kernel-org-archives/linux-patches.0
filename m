Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBE43E7BAB;
	Fri, 15 May 2026 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862857; cv=none; b=qebCcFLTE/p7fdrhceadWxNRPvsxO88hzjyQxBZ2rEZE5iv+idyIuvtHrB41gq5JYVXwdTD8yJf6r2L+v/vnvIlmmYYtuVv/J5MMHO0auKEZ9s/JzZoGdhtCKCKSSaXJ9Rovf/dhQVmECdrFR/MdyCP5b4CVdY99xFJdt7q4qdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862857; c=relaxed/simple;
	bh=02/D+EsE/TAmRZyLC0gJcOD6K3TqcmE9tf/hWf7aTME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwYM8UXW2Fo46sHEutCqcLyYF3TDk2kSSKQducNxYWhq6g98cgvRl1qTaf2dczZ5qyvam/1bPdIaR2RmYeiL/o/eBl2XCjxOMZwgIhHcx3PTtTNFGKNwG/TvHn4g6z+fyBFVpSDjFbCnuXVTU/Iwu+OMRiEm7Ao/ldMVa4Q5qkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhTSFiPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhTSFiPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D51C2BCB0;
	Fri, 15 May 2026 16:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862856;
	bh=02/D+EsE/TAmRZyLC0gJcOD6K3TqcmE9tf/hWf7aTME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhTSFiPN9i2wvaFIvGxdcdyC8DC7J01YZFhaRXAiTJkqo+PJRmn7VblpCcsH9yNyW
	 jt3LXHb5wEiWOi2yMfkM9v84QqIVKR2z4tInVz0f/95ceZQ+sYFMvDNQzP+ktFrgiF
	 5rj3Z0i/ySvZXwG3CrsJSYjxPRFIh/biQH1pKZK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyes Bourennani <lbourennani@fuzzinglabs.com>,
	Alexis Pinson <apinson@fuzzinglabs.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 173/201] batman-adv: fix integer overflow on buff_pos
Date: Fri, 15 May 2026 17:49:51 +0200
Message-ID: <20260515154702.323281403@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->mesh_iface);
 	const char *fwd_str;
 	u8 packet_num;
-	s16 buff_pos;
+	int buff_pos;
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	struct sk_buff *skb;
 	u8 *packet_pos;


