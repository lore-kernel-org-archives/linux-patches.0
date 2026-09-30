Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A586E30BF70;
	Wed, 30 Sep 2026 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786181; cv=none; b=eawFXKSl0YU4xFc7FjKlz7YBSJa0t0Iq06+oHg6ciPFCGW6hYeCTuk80WSW+8fFldTzOaxg9v7zBjMvF+v1hkoVtSk5YaLXnQLI2QoEkOSSIvdpbpK7wGxUNnW5fnXCGmEvPgKe2Uk7RFB8wonYgB/1eLO3hdk/K34HjH0t7oCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786181; c=relaxed/simple;
	bh=Y7CwTZ2Qd6LOt2Mgh1nK0dvn4JVin3/mXD8QuzjVFIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t72Vj6fIyZq0rAh4oY21xwafdTO4ELwLI/geNNluBDxNrE4zopHKb4J/SBcz82NSYTCY4RkBBlYjlFuwGzhhtjk/eUhyhe1IjvXt5tKsN8r8LTWSAMQNlK5oqb8b3GzTwDHEXwbNPHPmhFrP0RycWhfMMwfvL9fuKaT3DVYiKis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXipfF+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXipfF+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3D01F00893;
	Wed, 30 Sep 2026 16:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786180;
	bh=oJ3CiukYWFOnGsG3DvXaeiVBU3tmUE5/qR20XeQ1N+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXipfF+EFYM3f7Zw7s8PtQQKFQUY4JnWxBbgPbE4pwjK7aLoCK/qB/5wj2w+zHKej
	 Ma1XZoHkrJI7HHI79u9Y42FiYQl6PEmsROAVnWZByONrIom/HPUCAHGwRUtW+mMU0o
	 BbXxCFznhaTtB2SQAArb4Isfcj/vi8b1ukVTQOUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Brian Norris <briannorris@chromium.org>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 770/982] wifi: mwifiex: validate action frame fixed fields
Date: Wed, 30 Sep 2026 17:25:06 +0200
Message-ID: <20260930152433.293521816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


