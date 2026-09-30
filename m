Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077DC3E1681;
	Wed, 30 Sep 2026 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796481; cv=none; b=RyTtFxkwGoUWstv1S5CWSVOOvN2A8bEe1lpgvToJCDruGFBaSOW80c4KEntqQZQC9tG3yXZdsQriziH+/XDV9DXa8KzSDZqfMwlmnHbgeSaFxYiilgKrFKRXC89qTKeVT3fmbHkkpexc5GglMywtX37dGXtJJhosCAoUDJqLstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796481; c=relaxed/simple;
	bh=Vog8M1Ts0utbbwveEgfCSMzHowiBpTWcNhBzh4BfrO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/qsAN3f1IZGGd7tYS6d40Xw84I9Tcy/7W8IsPYZ5uPJkIQcQ3XhxBZ4GbMkC4hn4p9qhas+KiI0glBsE423DUSnSnxCAwBOmxJo91Wl8g+MM5IRj6J6FBuV7arYP4lqaz82xiBbNyqAN3YHpv9k4dyazamwIyLd8IvOjwd6sMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoZDiGbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoZDiGbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEAC1F000FF;
	Wed, 30 Sep 2026 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796479;
	bh=XcAcv/NdGirMftzCcjJjuAxsF3WWArI2/Np1EVLNNNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoZDiGbXg4tT3NOjV40YkULyscfFcngfBu7AizliGvQmxUTadX/iwWBRLAIQpADFq
	 ZsscjAkGt7kkcch6N/MG1WyhXais9dsqaujfb0DK7IT9v/QNOMiIPfJHOzEWJdjKbJ
	 YDC2e7b8f3DbzvplRgT3qaCES5khLJ8sPjMrOuWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Brian Norris <briannorris@chromium.org>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0928/1193] wifi: mwifiex: validate action frame fixed fields
Date: Wed, 30 Sep 2026 17:26:52 +0200
Message-ID: <20260930152454.858829841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 1c25bfad93e69ce13f744a2fb919f02ea396a985 upstream.

mwifiex_process_mgmt_packet() accepts an rx_pkt_length as small as a
four-address struct ieee80211_hdr plus the two-byte firmware length prefix.
After stripping the prefix, mwifiex_parse_mgmt_packet() can receive a
frame equal to sizeof(struct ieee80211_hdr).

For action frames, the parser reads the category byte immediately after
that header and, for a public action frame, reads the following action
code byte without verifying that either field is present. A truncated frame
can therefore make the parser consume up to two bytes past the
firmware-declared frame length. If those bytes look like a TDLS discovery
response, the malformed frame can spuriously update peer signal state.

Require the category and public action-code fields before reading them.
Use sizeof(*ieee_hdr) so the checks and field accesses directly match the
firmware four-address layout being parsed before address4 is removed.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Suggested-by: Brian Norris <briannorris@chromium.org>
Fixes: 72e5aa8d2a6d ("mwifiex: support for parsing TDLS discovery frames")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/66f148d83eb9f0970b9abbccc85d1b61244e54ad.camel@sipsolutions.net/
Link: https://lore.kernel.org/all/20260708195911.84365-8-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/20260723011013.76968-1-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/20260723202257.688-1-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/anuWyiPQja6_5vly@google.com/
Assisted-by: Codex:gpt-5
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260825112523.95774-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/util.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -335,10 +335,16 @@ mwifiex_parse_mgmt_packet(struct mwifiex
 
 	switch (stype) {
 	case IEEE80211_STYPE_ACTION:
-		category = *(payload + sizeof(struct ieee80211_hdr));
+		if (len < sizeof(*ieee_hdr) + 1)
+			return -1;
+
+		category = *(payload + sizeof(*ieee_hdr));
 		switch (category) {
 		case WLAN_CATEGORY_PUBLIC:
-			action_code = *(payload + sizeof(struct ieee80211_hdr)
+			if (len < sizeof(*ieee_hdr) + 2)
+				return -1;
+
+			action_code = *(payload + sizeof(*ieee_hdr)
 					+ 1);
 			if (action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
 				addr2 = ieee_hdr->addr2;


