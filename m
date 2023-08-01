Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91113E545
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA5FC433C7;
	Tue,  1 Aug 2023 09:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882699;
	bh=ETTFX7bRzTx5UAO6fPCr8R6J5LIYV08RVC4qYy8AHE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgGdvBhOFcdVjJ58u5vj4utuPeSQJI087mIzC6EYTubeaxNzlUfnt/peLtOAKq9kH
	 i0aCGY1GY7szx79KQCNvXTPz1XOboqbFY0rqIErxa3Jq9Jj8Nox08oqllc3CtL/4I+
	 3pT7qPBhLXjKABzW9athyYNtjJW0NAi0C4v8wZdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 199/228] net: dsa: qca8k: fix mdb add/del case with 0 VID
Date: Tue,  1 Aug 2023 11:20:57 +0200
Message-ID: <20230801091930.066453488@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
@@ -853,6 +853,9 @@ int qca8k_port_mdb_add(struct dsa_switch
 	const u8 *addr = mdb->addr;
 	u16 vid = mdb->vid;
 
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
 	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid,
 					   QCA8K_ATU_STATUS_STATIC);
 }
@@ -865,6 +868,9 @@ int qca8k_port_mdb_del(struct dsa_switch
 	const u8 *addr = mdb->addr;
 	u16 vid = mdb->vid;
 
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
 	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
 }
 


