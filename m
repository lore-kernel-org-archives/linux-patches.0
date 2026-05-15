Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63E176238;
	Fri, 15 May 2026 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860456; cv=none; b=KFW255uSCvbQt5h5pk+CpOS8dCZc9fpkbiaxgMByNO7AZECjOlq2SIJJ2uHm0hJu6ibBXsGCBsPYDHFrDAFeFw9cpfE1EVZ3W2sJY+DJOxWYcMOBePuknxbqwZDA2drkXfGVnKYN5Ccjx6R18Bht9zwQPOCK68FyIGlfD4XAIA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860456; c=relaxed/simple;
	bh=zRZjHln0MBf4PXvLagqLKQAOxU+ni2yZL7Yx2ZsWpRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLwubtcgADprfIAR+qREz/+65ujS11CYuaGUSF9xeCzCACPtFYpoZdovE80aex+qQ6nBRz8NE7N7YwLOLy3j6fYTr4jS5LjNWiha1rzVzPj5Qk5hlO55mFqEn9mx7lKwMvdg/yQhEbZyFap7Lly3iVkmNGcko5YeJ+bfWSke4pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQNdyEzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQNdyEzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4D2C2BCB0;
	Fri, 15 May 2026 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860456;
	bh=zRZjHln0MBf4PXvLagqLKQAOxU+ni2yZL7Yx2ZsWpRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQNdyEzUUBCVFkgdQ4FWnf4vFYfY7dqaw/9cIvreyvrwDgLnj2cWm0wxR8xhQhHPO
	 lARYUUhAuZXS7ljZLU5agtMSYorawdCtdCb7CKpmPCPX1SKmiF/9iNnG6lwtBDs6xr
	 qnmLuWOzAVkYOjwJB2rGwx8HTx1XVibfb6acJJcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyes Bourennani <lbourennani@fuzzinglabs.com>,
	Alexis Pinson <apinson@fuzzinglabs.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 095/144] batman-adv: fix integer overflow on buff_pos
Date: Fri, 15 May 2026 17:48:41 +0200
Message-ID: <20260515154655.712209924@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
@@ -334,7 +334,7 @@ static void batadv_iv_ogm_send_to_if(str
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	const char *fwd_str;
 	u8 packet_num;
-	s16 buff_pos;
+	int buff_pos;
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	struct sk_buff *skb;
 	u8 *packet_pos;


