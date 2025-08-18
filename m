Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92725322DA8;
	Mon, 18 Aug 2025 13:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523772; cv=none; b=o+uh+l9l4MTVSGGr0qOlU02ONpfbVP12pcE/VwSdXaUwWPnMQfk4rV1B6fJHcwrhbTGq5qXcuBRBmvzma0JVCLB020+a8hA+Pryh9nBpQZvxDS+LBw8zbmu+PAaku2Ukb07xJnpj0ZUNspc/pxs4oXZ0qRjjSvIBnmakF3Rgess=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523772; c=relaxed/simple;
	bh=uo3WRt/Id1ccnArK++SwDiJlTfM7nt5OVZ2/2gD82n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpyPL87g/Z4vZoGenp2aaX4KaMkkG9XMWp1gEI6J7qOA5G5Lk5IZOQlWv1DkBUpixMsMfVCnHpNJgsGK+DKAQGGhBXJIEHsI805WfX9KZftmk/CvWAO6tL4QUvlst+RA4ZLRlPd94CAKOeCp7A2u84e+Ba+Vq1ky+kFg7lfTz2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQN+StgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQN+StgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C91C4CEEB;
	Mon, 18 Aug 2025 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523772;
	bh=uo3WRt/Id1ccnArK++SwDiJlTfM7nt5OVZ2/2gD82n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQN+StgSQ+d8EwG/QlgoHf3K1/KRwHZd82dyyKllAP5Nbxsc07VABCbzhdopDDOPq
	 utfnb2AQDYGXpT1DbBap1LlueAiC2pLCaJ+NK6y2vxibbwe5rvKsx6J+AoWHzaPeIX
	 uYT48tLTxySpIn/FJQ41uVF56L67IJvr6E4eSw0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RubenKelevra <rubenkelevra@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 269/515] net: ieee8021q: fix insufficient table-size assertion
Date: Mon, 18 Aug 2025 14:44:15 +0200
Message-ID: <20250818124508.777106523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: RubenKelevra <rubenkelevra@gmail.com>

[ Upstream commit 21deb2d966920f0d4dd098ca6c3a55efbc0b2f23 ]

_Static_assert(ARRAY_SIZE(map) != IEEE8021Q_TT_MAX - 1) rejects only a
length of 7 and allows any other mismatch. Replace it with a strict
equality test via a helper macro so that every mapping table must have
exactly IEEE8021Q_TT_MAX (8) entries.

Signed-off-by: RubenKelevra <rubenkelevra@gmail.com>
Link: https://patch.msgid.link/20250626205907.1566384-1-rubenkelevra@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/ieee8021q_helpers.c | 44 +++++++++++-------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/net/core/ieee8021q_helpers.c b/net/core/ieee8021q_helpers.c
index 759a9b9f3f89..669b357b73b2 100644
--- a/net/core/ieee8021q_helpers.c
+++ b/net/core/ieee8021q_helpers.c
@@ -7,6 +7,11 @@
 #include <net/dscp.h>
 #include <net/ieee8021q.h>
 
+/* verify that table covers all 8 traffic types */
+#define TT_MAP_SIZE_OK(tbl)                                 \
+	compiletime_assert(ARRAY_SIZE(tbl) == IEEE8021Q_TT_MAX, \
+			   #tbl " size mismatch")
+
 /* The following arrays map Traffic Types (TT) to traffic classes (TC) for
  * different number of queues as shown in the example provided by
  * IEEE 802.1Q-2022 in Annex I "I.3 Traffic type to traffic class mapping" and
@@ -101,51 +106,28 @@ int ieee8021q_tt_to_tc(enum ieee8021q_traffic_type tt, unsigned int num_queues)
 
 	switch (num_queues) {
 	case 8:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_8queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_8queue_tt_tc_map != max - 1");
+		TT_MAP_SIZE_OK(ieee8021q_8queue_tt_tc_map);
 		return ieee8021q_8queue_tt_tc_map[tt];
 	case 7:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_7queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_7queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_7queue_tt_tc_map);
 		return ieee8021q_7queue_tt_tc_map[tt];
 	case 6:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_6queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_6queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_6queue_tt_tc_map);
 		return ieee8021q_6queue_tt_tc_map[tt];
 	case 5:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_5queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_5queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_5queue_tt_tc_map);
 		return ieee8021q_5queue_tt_tc_map[tt];
 	case 4:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_4queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_4queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_4queue_tt_tc_map);
 		return ieee8021q_4queue_tt_tc_map[tt];
 	case 3:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_3queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_3queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_3queue_tt_tc_map);
 		return ieee8021q_3queue_tt_tc_map[tt];
 	case 2:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_2queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_2queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_2queue_tt_tc_map);
 		return ieee8021q_2queue_tt_tc_map[tt];
 	case 1:
-		compiletime_assert(ARRAY_SIZE(ieee8021q_1queue_tt_tc_map) !=
-				   IEEE8021Q_TT_MAX - 1,
-				   "ieee8021q_1queue_tt_tc_map != max - 1");
-
+		TT_MAP_SIZE_OK(ieee8021q_1queue_tt_tc_map);
 		return ieee8021q_1queue_tt_tc_map[tt];
 	}
 
-- 
2.39.5



