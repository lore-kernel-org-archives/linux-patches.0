Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8833A47125D;
	Tue, 21 Jul 2026 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659153; cv=none; b=fj6nsqjEBKVkuN9tkJ3WxZIjafk1QcnmsR9J3liAG1Ycu1xPc1Op+325R3bn+IftV9vgbeaAe3+XyLe+ERHg3pjb1YOPDI2sSnn2ubVc2V6SdXJLFr+h9TVGTCH4EYqoB/YT0eXO+BB0UnSkRDvRJLkmOyhwanDwLCh0ggEuPoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659153; c=relaxed/simple;
	bh=0272/+L08FRZF0aPMjFuRgHiUVs0zcrmWSQ+SeF+IMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3IUm12nyp6RQfI9ac0Rh6ZtkUk9Id5Q0/DdLL15USGliTRcFDBM8jD2d4YOo1Tcf0JY6Q2u6UVG77DrXhzlguwjm2Es6MDRciuJO2wKAqrEjVbXRYJ1lNmOzY6OQIHYSDKhRR4nzvr/y/tskufdI52UN61UlGBUQeXNj2LsHUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gboXm4bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gboXm4bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9CA1F000E9;
	Tue, 21 Jul 2026 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659152;
	bh=CjBR+1MSlobwIYD7MXXzWBIWbmQj4IW/QlVpdmoEht0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gboXm4bgXV4lJv04gpGCseuv+aCP5l6crV4ZSD7pFGtSlkLlzBdwPQRFxPVSoScRW
	 RC0ma9pUM+9xYxSf5t/Vv56A/k0OuaInoCqY5su3wXmAY5tBdKp7VedCx42N/PO0OC
	 15irA5dVe5GjL29DxPcCO/MIlsWdu9mFBbGnJnkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.18 1413/1611] ieee802154: allow legacy LLSEC ADD/DEL ops to pass strict validation
Date: Tue, 21 Jul 2026 17:25:29 +0200
Message-ID: <20260721152547.223079093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit a6bfdfcc6711d1d5a92e98644359dedc67c0c858 upstream.

The LLSEC ADD/DEL doit handlers under the legacy IEEE802154_NL family
consume IEEE802154_ATTR_LLSEC_KEY_BYTES and
IEEE802154_ATTR_LLSEC_KEY_USAGE_COMMANDS, both declared in
net/ieee802154/nl_policy.c as bare length entries with no .type
(defaulting to NLA_UNSPEC). Generic netlink strict validation rejects
all NLA_UNSPEC attributes via validate_nla(), so every LLSEC_ADD_KEY,
LLSEC_DEL_KEY, LLSEC_ADD_DEV, LLSEC_DEL_DEV, LLSEC_ADD_DEVKEY,
LLSEC_DEL_DEVKEY, LLSEC_ADD_SECLEVEL, and LLSEC_DEL_SECLEVEL request
fails at the dispatcher with "Unsupported attribute" before reaching
the handler.

The doit path has been silently dead since strict validation became
the default for genl families that do not opt out. The dump path is
unaffected because dump requests carry no LLSEC attributes to
validate, which is why the LLSEC_LIST_KEY read remained reachable
(patch 1/2). Introduce IEEE802154_OP_RELAXED() mirroring
IEEE802154_OP() but with .validate = GENL_DONT_VALIDATE_STRICT, and
use it for the eight legacy LLSEC mutate ops so admin-driven LLSEC
configuration via the legacy interface works again.

Fixes: 3e9c156e2c21 ("ieee802154: add netlink interfaces for llsec")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://lore.kernel.org/20260520141640.1149513-3-michael.bommarito@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/ieee802154.h |    9 +++++++++
 net/ieee802154/netlink.c    |   20 ++++++++++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

--- a/net/ieee802154/ieee802154.h
+++ b/net/ieee802154/ieee802154.h
@@ -16,6 +16,15 @@ void ieee802154_nl_exit(void);
 		.flags	= GENL_ADMIN_PERM,		\
 	}
 
+#define IEEE802154_OP_RELAXED(_cmd, _func)		\
+	{						\
+		.cmd		= _cmd,			\
+		.doit		= _func,		\
+		.dumpit		= NULL,			\
+		.flags		= GENL_ADMIN_PERM,	\
+		.validate	= GENL_DONT_VALIDATE_STRICT,\
+	}
+
 #define IEEE802154_DUMP(_cmd, _func, _dump)		\
 	{						\
 		.cmd	= _cmd,				\
--- a/net/ieee802154/netlink.c
+++ b/net/ieee802154/netlink.c
@@ -100,22 +100,22 @@ static const struct genl_small_ops ieee8
 	IEEE802154_OP(IEEE802154_LLSEC_SETPARAMS, ieee802154_llsec_setparams),
 	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_KEY, NULL,
 			     ieee802154_llsec_dump_keys),
-	IEEE802154_OP(IEEE802154_LLSEC_ADD_KEY, ieee802154_llsec_add_key),
-	IEEE802154_OP(IEEE802154_LLSEC_DEL_KEY, ieee802154_llsec_del_key),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_ADD_KEY, ieee802154_llsec_add_key),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_DEL_KEY, ieee802154_llsec_del_key),
 	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_DEV, NULL,
 			     ieee802154_llsec_dump_devs),
-	IEEE802154_OP(IEEE802154_LLSEC_ADD_DEV, ieee802154_llsec_add_dev),
-	IEEE802154_OP(IEEE802154_LLSEC_DEL_DEV, ieee802154_llsec_del_dev),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_ADD_DEV, ieee802154_llsec_add_dev),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_DEL_DEV, ieee802154_llsec_del_dev),
 	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_DEVKEY, NULL,
 			     ieee802154_llsec_dump_devkeys),
-	IEEE802154_OP(IEEE802154_LLSEC_ADD_DEVKEY, ieee802154_llsec_add_devkey),
-	IEEE802154_OP(IEEE802154_LLSEC_DEL_DEVKEY, ieee802154_llsec_del_devkey),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_ADD_DEVKEY, ieee802154_llsec_add_devkey),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_DEL_DEVKEY, ieee802154_llsec_del_devkey),
 	IEEE802154_DUMP_PRIV(IEEE802154_LLSEC_LIST_SECLEVEL, NULL,
 			     ieee802154_llsec_dump_seclevels),
-	IEEE802154_OP(IEEE802154_LLSEC_ADD_SECLEVEL,
-		      ieee802154_llsec_add_seclevel),
-	IEEE802154_OP(IEEE802154_LLSEC_DEL_SECLEVEL,
-		      ieee802154_llsec_del_seclevel),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_ADD_SECLEVEL,
+			      ieee802154_llsec_add_seclevel),
+	IEEE802154_OP_RELAXED(IEEE802154_LLSEC_DEL_SECLEVEL,
+			      ieee802154_llsec_del_seclevel),
 };
 
 static const struct genl_multicast_group ieee802154_mcgrps[] = {


