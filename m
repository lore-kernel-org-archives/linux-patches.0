Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6413FBB40;
	Fri, 15 May 2026 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862173; cv=none; b=K7qLAgh3TBWQLDsYpZX03lysU3Q3xHUOq4311V6tsMVHx4WOuKgeHHEsIR27OAeLCEwVPB05BdRL6m8/qfGfcabdJoVekc/8q2wkOXbBmmdQ3Y4qcFM4rlXQNRJBVgNIHleTJdLVIlFZi8pS4jiREOiXHJB1Rli/XFm05bIpk+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862173; c=relaxed/simple;
	bh=eljk+e9Mrxgw39gRTkICb+Colj8Uwz5xjpRa6Iodemk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucg+y5ubCId1YhA5MtuK0QnuQy4Wf5WwgTBBhVLxCKGi04bDIY535ZQeL2jSSgfZK+XRy5PJpggGB5XkwjuvA7ykMwu5Mp6REeZbfJ7X+FIwc6LEGUzK3JxrZXHfcfrzZKmAFxdKQQd1naNYwb8Wmoh37poOm0696X1DkWsvcKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SldXS1ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SldXS1ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE63C2BCB0;
	Fri, 15 May 2026 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862172;
	bh=eljk+e9Mrxgw39gRTkICb+Colj8Uwz5xjpRa6Iodemk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SldXS1ki5qnTVMXYyqi/lsc15dTYugHTwbrrFRVdZ5q59fm/g55wfhFVTHtVkCysm
	 51zZQ+sBmaD9gPKvPV9opnlTHDx9Mv9dY27I46+W4vhBITNkaRKpS3ooZ7JS67dYT5
	 b45TCGigzvdS/H0gD1C2sHXl/O7rx15jyoWUKFg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyes Bourennani <lbourennani@fuzzinglabs.com>,
	Alexis Pinson <apinson@fuzzinglabs.com>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 136/188] batman-adv: fix integer overflow on buff_pos
Date: Fri, 15 May 2026 17:49:13 +0200
Message-ID: <20260515154700.279383213@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


