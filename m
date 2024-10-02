Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259821D096B;
	Wed,  2 Oct 2024 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877318; cv=none; b=OganWS/WnoRKkw2roOO3pGMp4b6aA+GAx/Ue2XG3ntyL6A61ezBlkLX3YcZHLlPb/iosP6KYNblCI3cMl0Bap5vwPRleIHCec63aeaMx1eyUV+zGfdOzCSGp5ECUOida0rED5nEs4ZqwQAYt/Ze7Q7nZRSzscR5aLQQgWwYwUvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877318; c=relaxed/simple;
	bh=FRIxKg1k2H6MdATd/Kv60dK3c4FgtV1bBeR3fqPPunU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZaxwrlXuETjnU95d9PIca8Urkve2EQSay+ruUlzRhka66t5OcXk3U/y9qDeKoXdhjf2bBM9+kZQEAI6bv6jhZ/lrOkqQsyX8iWEEd/AuiWI8Mq/biR681yI128GQ3mE5OUERoS77I0WKoc4xD9uOtyZQnIb8eFRlMlMk92TLTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YZW3Zeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YZW3Zeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E364C4DDE2;
	Wed,  2 Oct 2024 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877317;
	bh=FRIxKg1k2H6MdATd/Kv60dK3c4FgtV1bBeR3fqPPunU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YZW3Zeov/8W7sfwa5cL/UQIeXUWrmyyD49oZh4RZhafVk+iqyJrARTNFKxB7+dnt
	 EWJSLmwlFWNVDh4igSf7pWdoWQ6bBqf+9fUcbX5AfCUrEHHiKoXCZEnf1n5Ory6jxB
	 FQalVPi8rG3vxpLqydKlzTz9fLOTYxfluEwtVs+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hhorace <hhoracehsu@gmail.com>,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 041/634] wifi: cfg80211: fix bug of mapping AF3x to incorrect User Priority
Date: Wed,  2 Oct 2024 14:52:21 +0200
Message-ID: <20241002125812.721996675@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hhorace <hhoracehsu@gmail.com>

[ Upstream commit a68b22e2905b04f376e2fa116be5e48b948f81c8 ]

According to RFC8325 4.3, Multimedia Streaming: AF31(011010, 26),
AF32(011100, 28), AF33(011110, 30) maps to User Priority = 4
and AC_VI (Video).

However, the original code remain the default three Most Significant
Bits (MSBs) of the DSCP, which makes AF3x map to User Priority = 3
and AC_BE (Best Effort).

Fixes: 6fdb8b8781d5 ("wifi: cfg80211: Update the default DSCP-to-UP mapping")
Signed-off-by: hhorace <hhoracehsu@gmail.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20240807082205.1369-1-hhoracehsu@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index af6ec719567fc..f1193aca79bae 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -998,10 +998,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 	 * Diffserv Service Classes no update is needed:
 	 * - Standard: DF
 	 * - Low Priority Data: CS1
-	 * - Multimedia Streaming: AF31, AF32, AF33
 	 * - Multimedia Conferencing: AF41, AF42, AF43
 	 * - Network Control Traffic: CS7
 	 * - Real-Time Interactive: CS4
+	 * - Signaling: CS5
 	 */
 	switch (dscp >> 2) {
 	case 10:
@@ -1026,9 +1026,11 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 		/* Broadcasting video: CS3 */
 		ret = 4;
 		break;
-	case 40:
-		/* Signaling: CS5 */
-		ret = 5;
+	case 26:
+	case 28:
+	case 30:
+		/* Multimedia Streaming: AF31, AF32, AF33 */
+		ret = 4;
 		break;
 	case 44:
 		/* Voice Admit: VA */
-- 
2.43.0



