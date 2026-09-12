Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D02832E757;
	Sat, 12 Sep 2026 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225871; cv=none; b=u2BCw6qma3e3fEQTu5MM+B7haW6b6N7dZVFbQRoY3JwLJemNjMdIMMydlTCMYOLAkuoMcWtvKvWo5Hl7NYcpj2jwDxeJAmPOFtHTQEwd92qNWdwrIA70I1Ve0jXVNyGB3kW8rRdQATbj1m2dwXyFCzccjV0+DkIZ/pvpoi0XvGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225871; c=relaxed/simple;
	bh=CK61Se0N631hkUaAWYXSxt52SfVI6sYLqhA8YFVgPcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhu8C5RaqCoo4ywghS+SAL7rBj+KOsSDz8MG5qleXk3+OlClsDxbY5Z29a1H+s3ZMcyzmKP8mVGCAp1uYyMVZ9s0r4LaS0ZIA3uyPgwpud4baJ9CKPiBSHCFG+BSFBa6fkcFzVMO58XeqO7GraE4LebiKx6jWNWkk/xYoNdre8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebxp40Qb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebxp40Qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF581F000FF;
	Sat, 12 Sep 2026 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225869;
	bh=RriIXdRqUX83qmz4FD7yDBGy116dFrITN5ibi4m5lxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ebxp40QbVWCZapiXYN9iPhU7BGrSAAtiRDt40FczcOIneehT94theXeKu1uYdzAkX
	 iPG57z0xHnFc0uApTHHl747fVL2eA93tyvC2PBPwbGjzSzFus8iG+EpCOHO7UvlUCV
	 2ZqQrzDDeBTDmJb+NPSiCx5F4KEA+BzCQUQ2HiE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1287/1424] bridge: add MDB get uAPI attributes
Date: Sat, 12 Sep 2026 09:01:59 +0200
Message-ID: <20260912065636.094757334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 83c1bbeb864f2a197603b91b3e0f748cca64543d ]

Add MDB get attributes that correspond to the MDB set attributes used in
RTM_NEWMDB messages. Specifically, add 'MDBA_GET_ENTRY' which will hold
a 'struct br_mdb_entry' and 'MDBA_GET_ENTRY_ATTRS' which will hold
'MDBE_ATTR_*' attributes that are used as indexes (source IP and source
VNI).

An example request will look as follows:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_GET_ENTRY ]
	struct br_mdb_entry
[ MDBA_GET_ENTRY_ATTRS ]
	[ MDBE_ATTR_SOURCE ]
		struct in_addr / struct in6_addr
	[ MDBE_ATTR_SRC_VNI ]
		u32

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bc2dc66a6693 ("vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if_bridge.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index f95326fce6bba..2e23f99dc0f15 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -723,6 +723,24 @@ enum {
 };
 #define MDBA_SET_ENTRY_MAX (__MDBA_SET_ENTRY_MAX - 1)
 
+/* [MDBA_GET_ENTRY] = {
+ *    struct br_mdb_entry
+ *    [MDBA_GET_ENTRY_ATTRS] = {
+ *       [MDBE_ATTR_SOURCE]
+ *          struct in_addr / struct in6_addr
+ *       [MDBE_ATTR_SRC_VNI]
+ *          u32
+ *    }
+ * }
+ */
+enum {
+	MDBA_GET_ENTRY_UNSPEC,
+	MDBA_GET_ENTRY,
+	MDBA_GET_ENTRY_ATTRS,
+	__MDBA_GET_ENTRY_MAX,
+};
+#define MDBA_GET_ENTRY_MAX (__MDBA_GET_ENTRY_MAX - 1)
+
 /* [MDBA_SET_ENTRY_ATTRS] = {
  *    [MDBE_ATTR_xxx]
  *    ...
-- 
2.53.0



