Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1726E230BEC;
	Mon, 10 Mar 2025 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626741; cv=none; b=P9ZB6Xp9lQkdr2/OgTdkHPyxcxmG1AYxu9eizCaCwD3Lp3p9rj9TOfslkdPf5yu7RjQ5ddtm1q5gJGfngB6RIkInSrW2VwaC/fUc6h1g6D32o/2wFgpsTb7cZTs5TOPahVqPCYA05+yE7nm6E9RhJhOdHtIdxsLs5LA8Q3PAY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626741; c=relaxed/simple;
	bh=JeywlziXQd7S5ayr9STxpFJmNNLNhFiQ3/6VJiY0fdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL58Gh/2/7E2s0IDmMRzYE02JcdJEPqGLkrIEB0Idc7fAIi7jy9c0mnIbKqS64AWbJdSqbAg7Dd3UqoayeTqtlIOWTXmjLLzB6JsUdt989F9CGREUhOazt8ajRCGA9BigSDsqFGjUbuVW2Ub3gQtYdfXV0VTCpfnqo1bkxmtHEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB8WuNJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB8WuNJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918ADC4CEEB;
	Mon, 10 Mar 2025 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626741;
	bh=JeywlziXQd7S5ayr9STxpFJmNNLNhFiQ3/6VJiY0fdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB8WuNJAEcZnI0GwpNlh5dch/NMzT7kZQq+oULu3lDPv0KfQqBk1isS5VfB8PYqsa
	 +2UNz30giVv/m5aaop9NgjQnxWRvMUSle5A6YmnsjqiFqyDpYlHQ4nrer6vvzoUiDO
	 V8kNzOGAbMjUBOtUEMlcRfqjq07M4pJALREA6z44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 096/207] wifi: mac80211: fix vendor-specific inheritance
Date: Mon, 10 Mar 2025 18:04:49 +0100
Message-ID: <20250310170451.572883743@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 130067e9c13bdc4820748ef16076a6972364745f ]

If there's any vendor-specific element in the subelements
then the outer element parsing must not parse any vendor
element at all. This isn't implemented correctly now due
to parsing into the pointers and then overriding them, so
explicitly skip vendor elements if any exist in the sub-
elements (non-transmitted profile or per-STA profile).

Fixes: 671042a4fb77 ("mac80211: support non-inheritance element")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250221112451.fd71e5268840.I9db3e6a3367e6ff38d052d07dc07005f0dd3bd5c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/parse.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 3d5d6658fe8d5..6da39c864f45b 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -48,6 +48,7 @@ struct ieee80211_elems_parse {
 	const struct element *ml_epcs_elem;
 
 	bool multi_link_inner;
+	bool skip_vendor;
 
 	/*
 	 * scratch buffer that can be used for various element parsing related
@@ -400,6 +401,9 @@ _ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params,
 					IEEE80211_PARSE_ERR_BAD_ELEM_SIZE;
 			break;
 		case WLAN_EID_VENDOR_SPECIFIC:
+			if (elems_parse->skip_vendor)
+				break;
+
 			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
 			    pos[2] == 0xf2) {
 				/* Microsoft OUI (00:50:F2) */
@@ -1054,12 +1058,16 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 		multi_link_inner = true;
 	}
 
+	elems_parse->skip_vendor =
+		cfg80211_find_elem(WLAN_EID_VENDOR_SPECIFIC,
+				   sub.start, sub.len);
 	elems->crc = _ieee802_11_parse_elems_full(params, elems_parse,
 						  non_inherit);
 
 	/* Override with nontransmitted/per-STA profile if found */
 	if (sub.len) {
 		elems_parse->multi_link_inner = multi_link_inner;
+		elems_parse->skip_vendor = false;
 		_ieee802_11_parse_elems_full(&sub, elems_parse, NULL);
 	}
 
-- 
2.39.5



