Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2557A403B02;
	Tue, 21 Jul 2026 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655017; cv=none; b=peET/p5Ab66t2TUgTtKjOQeJkTc7ukjcjMSpAFyDhhIaxHsyQoMFTl1xC69NBC2f7NzwTDKEOC2LoY0y2+0AK0nqzmjB09IFnJErlfQUa8Ce8thrDsTLLyVGu9HpwXjWlngcd2T8mNaZ2O/X6+qqz3Huk2iTji0f/hRBRWpAASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655017; c=relaxed/simple;
	bh=28rhRpVvW65U6UHkOx4HBhPyn/+PwUm4bAH/ctDB66k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmHB56uv/9OBZT+kbDsz0M720llRFMtI6pEgdLrTK63eCR1IlOlVHtXBT8YaROYe4G2LP3MRVzVxxLiMqrO0DZYA7V2WqUsN4j0OA7pMTYF8NLtK7MtOd05rMpICCpMQV5FR5LPM0Qm2NUHsl6/DxYeotGJ5F02kFr8jv2VSlP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddftWzno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddftWzno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A201F000E9;
	Tue, 21 Jul 2026 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655016;
	bh=hx9QJZLBBYRbC3Hs7C+oMGvTxQZBV5PsO0umWFwbffI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddftWznodGx5dPCaEffylUvh3wPbVFs8+P0WW042W2C+LBuDaN+S3+XNnltrNnYxI
	 z0st+T2xjCiyuxaLX5iQXJFC/BGA0ipI9gq1tiGwVsgnk+lGZhUsHqscVfSM/HQUVv
	 UU9Osyomp8M/RpsRM8X2ly2El2XOM36h7VKpJ/SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 7.1 1923/2077] ieee802154: allow legacy LLSEC ADD/DEL ops to pass strict validation
Date: Tue, 21 Jul 2026 17:26:36 +0200
Message-ID: <20260721152638.070222531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


