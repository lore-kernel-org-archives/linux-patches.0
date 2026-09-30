Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFC450AC0E;
	Wed, 30 Sep 2026 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788851; cv=none; b=UprF2KBeStvK9Q9ov6a6zfBfbU+dvx7ygtJbgzApv4JyZPIYPZ4Ywra1I17/vE6Y/SU+rcGIVfkVoC4KiK/wri1XW1V2tfOZnfmMpY0VnpVPClnW4V2LeEVFtKXOtO0V+qLHu9yvp6+k7j8Nw6es576O/a8dRj54U5q0/7ivEts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788851; c=relaxed/simple;
	bh=i3g3zVerHrJVitP1CKefP0KV8qYYrPUA5gFE0+old7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2p2PIUWabCuWXpVgEDrB17eLtEMsQvpN+XyWr6CJxn5Pb3nCsnGr641aKxfHR8nwaMKOiP+95OllyyKHF7KLcz8ZmFWvuzMnEDA5Nf9selJ8PJoiRxpKwQ6IOMeVkR7DkQzFgD7bD38xWJJLBXeerVSzsUgKN+r7uGsga2LzKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNZnDvpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNZnDvpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6011F000FF;
	Wed, 30 Sep 2026 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788849;
	bh=LFLzrJ8n1xVbYuNLufr43L+NSUi7NFh7uzIMQ0QMm+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNZnDvpdlzK/5jW5keqPRjh1pBkjlMVvsQjikSIV4dpm/Tzlhu4jTWIqwc/G7lrWC
	 HAXbIRr+EH1AQLsv1F1Q8MAyfXVnZzvkDN+56Ik6Eg6CE78QNpDpWyG8xM14MVmtrc
	 kCcAaiY8Y4/Kev9AU0BpenzsEMjkJCgQzAZbepdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Brian Norris <briannorris@chromium.org>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 271/877] wifi: mwifiex: validate action frame fixed fields
Date: Wed, 30 Sep 2026 17:19:42 +0200
Message-ID: <20260930152420.571328373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


