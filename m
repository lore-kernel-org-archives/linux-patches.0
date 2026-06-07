Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D52D2E7373;
	Sun,  7 Jun 2026 10:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827218; cv=none; b=lpE1+jIYhTmswpoCFbSI/Giu98xH55f9XBOgpatp/ihdqrHqKP1g3BtXo90eLbuY2qmoXFTgSi8fqYmonsBlRa9rvM4A+/UJA2lcLz0+MabakEH0f7HaDMnz46cSgwZN/gS16fnCdVi3j4LY/7SnKXH/Ibz5T7DjdFM7r/IG3Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827218; c=relaxed/simple;
	bh=9gzf99YeQjE1GdZKuphbaYPK+rtKP8Dr2+wDgna9MWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8253Qwed+PYbe+A/1aL0v2iTNwNy3QPDuTLJU5r9jzvRBFvY36Sk+e/ujJ8Uw2AMsyUThe+DARukputoR4NtC230DRBfSjcPqB3GZX5LaIGuEHUwH40q3gyReCeNYv6DlFa2U3RukGyeHInMcHeHLzfxR6PLkLXHQja/t63Vu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhqGmOoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhqGmOoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9511F00893;
	Sun,  7 Jun 2026 10:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827217;
	bh=iufm3OKHOH8Z9IYf9cFMbl/fGCcoLeyBVCzHV1yjpks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhqGmOoSINwChd7ctUbM6MO6vn2Yq0qvqr9t9GD5rd8QGTFdoTMJm/pB20uBk+8xs
	 lfjg4QB94M+vfWrYtHb4lvEz3wv6KnIUlgybnHhrvj/xnQrBlVTP+wisOOo0qJNt+y
	 4e0YtzKE9Rz0WOZy71vXNKwZeudYBmY8ZDuVoIMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 073/332] ethtool: tsinfo: fix uninitialized stats on the by-PHC path
Date: Sun,  7 Jun 2026 11:57:22 +0200
Message-ID: <20260607095730.818749419@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1de405699c62c3a9544bcdcfb9eff8a01cfc7582 ]

tsinfo_prepare_data() has two code paths: a "by-PHC" path for
user-specified hardware timestamping providers, and the old path.
Commit 89e281ebff72 ("ethtool: init tsinfo stats if requested") added
ethtool_stats_init() to mark stat slots as ETHTOOL_STAT_NOT_SET before
the driver callback populates them, but placed the call inside the
old-path block.

When commit b9e3f7dc9ed9 ("net: ethtool: tsinfo: Enhance tsinfo to
support several hwtstamp by net topology") added the by-PHC early
return, it landed above the stats initialization. On that path
the stats array retains the zero-fill from ethnl_init_reply_data()'s
zalloc. This leads to the reply including a stats nest with four
zero-valued attributes that should have been absent.

Reject GET requests for stats with HWTSTAMP_PROVIDER or dump.

Fixes: b9e3f7dc9ed9 ("net: ethtool: tsinfo: Enhance tsinfo to support several hwtstamp by net topology")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-7-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/tsinfo.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index c0145c752d2f8b..cb1491e0a28bac 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -81,6 +81,11 @@ tsinfo_parse_request(struct ethnl_req_info *req_base, struct nlattr **tb,
 	if (!tb[ETHTOOL_A_TSINFO_HWTSTAMP_PROVIDER])
 		return 0;
 
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		NL_SET_ERR_MSG(extack, "can't query statistics for a provider");
+		return -EOPNOTSUPP;
+	}
+
 	return ts_parse_hwtst_provider(tb[ETHTOOL_A_TSINFO_HWTSTAMP_PROVIDER],
 				       &req->hwprov_desc, extack, &mod);
 }
@@ -521,6 +526,12 @@ int ethnl_tsinfo_start(struct netlink_callback *cb)
 	if (ret < 0)
 		goto free_reply_data;
 
+	if (req_info->base.flags & ETHTOOL_FLAG_STATS) {
+		NL_SET_ERR_MSG(cb->extack, "stats not supported in dump");
+		ret = -EOPNOTSUPP;
+		goto err_dev_put;
+	}
+
 	ctx->req_info = req_info;
 	ctx->reply_data = reply_data;
 	ctx->pos_ifindex = 0;
@@ -530,6 +541,8 @@ int ethnl_tsinfo_start(struct netlink_callback *cb)
 
 	return 0;
 
+err_dev_put:
+	ethnl_parse_header_dev_put(&req_info->base);
 free_reply_data:
 	kfree(reply_data);
 free_req_info:
-- 
2.53.0



