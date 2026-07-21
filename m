Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF20347BC6;
	Tue, 21 Jul 2026 22:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674419; cv=none; b=KhOMKloE6naavyKPw2nxT/Wo1cAtx98vA0zDLw0scAKZzFcSoQEH9rCCJbT0YOxPlXkLJHK4A5plAqF+AJTbKbCsQTCsFDtuIYZCmZoak0gPlm5phRnSgr5Mpc20WKDtY7kArvYTi6EQxTeQ67Nt8CBXQ3mjuH/bp2KyteJyqpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674419; c=relaxed/simple;
	bh=DiPfHx5E8DWM5UxqqYP+lh/zuYcqkc2sTrMAmrdaqU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI2bLEtSOaDN1UpIoxqam1/zkiGRl8N/5BX0bJCMabzvYu3E7/M0X/qFOIk9iIPyZiZwAHAi4KG73YxFn430RaxxThvhj+bYdnEK6YUxNak81aHJhqdZD9Ccqt1Ho7+8aaN6IKc2Vg09YYGlLDkgNcYJbH1aW+EL9V/TcbxO63U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqQ7ooiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqQ7ooiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7A11F000E9;
	Tue, 21 Jul 2026 22:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674418;
	bh=yk9VCBgHIJFsctJYLh9/dkK8z8z3GA8MBx3fKkar8Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqQ7ooiuXjta4lpZUaBNrQJMotNstLRKBKE8rAODGv1sUTJeY/0nzUDNZofZV1TWh
	 DOXi2cPwrc63+etGm+8+Mim9N9/HW2UfL0Khyh0xfjAw9uJFRXD+v6euN9J3RYY4fF
	 ItkkxPhvGH4MkCZG1Xtkjv0DHeFowHYXzDujvCwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.10 533/699] ieee802154: admin-gate legacy LLSEC dump operations
Date: Tue, 21 Jul 2026 17:24:52 +0200
Message-ID: <20260721152407.722692392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 9c1e0b6d49471a712511d23fc9d06901561135e8 upstream.

In net/ieee802154/netlink.c, the legacy IEEE802154_NL family ops table
builds the LLSEC dump entries (LLSEC_LIST_KEY, LLSEC_LIST_DEV,
LLSEC_LIST_DEVKEY, LLSEC_LIST_SECLEVEL) with IEEE802154_DUMP() which
sets no .flags, so generic netlink runs them ungated. The modern
nl802154 family admin-gates the equivalent reads via
NL802154_CMD_GET_SEC_KEY and friends with .flags = GENL_ADMIN_PERM.

Any local uid that can open AF_NETLINK / NETLINK_GENERIC can resolve
the "802.15.4 MAC" family and dump LLSEC_LIST_KEY on any wpan netdev
that has an LLSEC key installed; the dump handler writes the raw
16-byte AES-128 key bytes (IEEE802154_ATTR_LLSEC_KEY_BYTES, copied
verbatim from struct ieee802154_llsec_key.key) into the reply.
Recovering the AES key compromises 802.15.4 LLSEC link confidentiality
and authenticity, since LLSEC uses CCM* and the same key authenticates
and encrypts frames.

Impact: any local uid with no capabilities can read the raw 16-byte
AES-128 LLSEC key from the kernel keytable on any wpan netdev that has
an administrator-installed LLSEC key, by issuing an LLSEC_LIST_KEY
dump on the legacy IEEE802154_NL generic-netlink family.

Introduce IEEE802154_DUMP_PRIV() mirroring IEEE802154_DUMP() but
setting .flags = GENL_ADMIN_PERM, and use it for the four LLSEC dump
entries. LIST_PHY and LIST_IFACE retain IEEE802154_DUMP() because the
modern nl802154 family exposes their equivalents to unprivileged
readers by design (NL802154_CMD_GET_WPAN_PHY and
NL802154_CMD_GET_INTERFACE carry "can be retrieved by unprivileged
users" annotations).

Fixes: 3e9c156e2c21 ("ieee802154: add netlink interfaces for llsec")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://lore.kernel.org/20260520141640.1149513-2-michael.bommarito@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/ieee802154.h |    8 ++++++++
 net/ieee802154/netlink.c    |   16 ++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/net/ieee802154/ieee802154.h
+++ b/net/ieee802154/ieee802154.h
@@ -23,6 +23,14 @@ void ieee802154_nl_exit(void);
 		.dumpit	= _dump,			\
 	}
 
+#define IEEE802154_DUMP_PRIV(_cmd, _func, _dump)	\
+	{						\
+		.cmd	= _cmd,				\
+		.doit	= _func,			\
+		.dumpit	= _dump,			\
+		.flags	= GENL_ADMIN_PERM,		\
+	}
+
 struct genl_info;
 
 struct sk_buff *ieee802154_nl_create(int flags, u8 req);
--- a/net/ieee802154/netlink.c
+++ b/net/ieee802154/netlink.c
@@ -98,20 +98,20 @@ static const struct genl_small_ops ieee8
 	IEEE802154_OP(IEEE802154_SET_MACPARAMS, ieee802154_set_macparams),
 	IEEE802154_OP(IEEE802154_LLSEC_GETPARAMS, ieee802154_llsec_getparams),
 	IEEE802154_OP(IEEE802154_LLSEC_SETPARAMS, ieee802154_llsec_setparams),
-	IEEE802154_DUMP(IEEE802154_LLSEC_LIST_KEY, NULL,
-			ieee802154_llsec_dump_keys),
+	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_KEY, NULL,
+			     ieee802154_llsec_dump_keys),
 	IEEE802154_OP(IEEE802154_LLSEC_ADD_KEY, ieee802154_llsec_add_key),
 	IEEE802154_OP(IEEE802154_LLSEC_DEL_KEY, ieee802154_llsec_del_key),
-	IEEE802154_DUMP(IEEE802154_LLSEC_LIST_DEV, NULL,
-			ieee802154_llsec_dump_devs),
+	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_DEV, NULL,
+			     ieee802154_llsec_dump_devs),
 	IEEE802154_OP(IEEE802154_LLSEC_ADD_DEV, ieee802154_llsec_add_dev),
 	IEEE802154_OP(IEEE802154_LLSEC_DEL_DEV, ieee802154_llsec_del_dev),
-	IEEE802154_DUMP(IEEE802154_LLSEC_LIST_DEVKEY, NULL,
-			ieee802154_llsec_dump_devkeys),
+	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_DEVKEY, NULL,
+			     ieee802154_llsec_dump_devkeys),
 	IEEE802154_OP(IEEE802154_LLSEC_ADD_DEVKEY, ieee802154_llsec_add_devkey),
 	IEEE802154_OP(IEEE802154_LLSEC_DEL_DEVKEY, ieee802154_llsec_del_devkey),
-	IEEE802154_DUMP(IEEE802154_LLSEC_LIST_SECLEVEL, NULL,
-			ieee802154_llsec_dump_seclevels),
+	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_SECLEVEL, NULL,
+			     ieee802154_llsec_dump_seclevels),
 	IEEE802154_OP(IEEE802154_LLSEC_ADD_SECLEVEL,
 		      ieee802154_llsec_add_seclevel),
 	IEEE802154_OP(IEEE802154_LLSEC_DEL_SECLEVEL,


