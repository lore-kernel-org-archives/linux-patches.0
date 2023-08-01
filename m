Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B97C1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DD2C433C7;
	Tue,  1 Aug 2023 09:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883355;
	bh=43J0HHvCc63AeqPCrdVY75NniK/07YDiYE0wKZyyY4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hX3ZNQkeaZ9RHXf8gtyYOmx/kQGGqLxJBRPzk6Vo63xovxk0rKAny1fYYC5FaueqU
	 fg8ZDog6IXPbHxIeFwTW9hgEPu3En73CTNxuQFIDP+viVZ5Zbl5QO4+wRAy1isad8w
	 ZtoHdFXwwY55O3pHPtTtvD+xWBz6Yhw9qJWzb6Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 206/239] net: dsa: qca8k: fix mdb add/del case with 0 VID
Date: Tue,  1 Aug 2023 11:21:10 +0200
Message-ID: <20230801091933.233769993@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Marangi <ansuelsmth@gmail.com>

commit dfd739f182b00b02bd7470ed94d112684cc04fa2 upstream.

The qca8k switch doesn't support using 0 as VID and require a default
VID to be always set. MDB add/del function doesn't currently handle
this and are currently setting the default VID.

Fix this by correctly handling this corner case and internally use the
default VID for VID 0 case.

Fixes: ba8f870dfa63 ("net: dsa: qca8k: add support for mdb_add/del")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca/qca8k-common.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -816,6 +816,9 @@ int qca8k_port_mdb_add(struct dsa_switch
 	const u8 *addr = mdb->addr;
 	u16 vid = mdb->vid;
 
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
 	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid,
 					   QCA8K_ATU_STATUS_STATIC);
 }
@@ -828,6 +831,9 @@ int qca8k_port_mdb_del(struct dsa_switch
 	const u8 *addr = mdb->addr;
 	u16 vid = mdb->vid;
 
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
 	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
 }
 


