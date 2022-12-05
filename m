Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042BC15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C06FC433C1;
	Mon,  5 Dec 2022 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268927;
	bh=52Bc2JxXNk+QeR4QZLLWuzP0mRRvZ3TjFmWbYT1LnD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVoFgQewavSnAnrgh9WprjZumD0phGUk31MPs52HJv/squKaBs9gF1BsySHZSlSGX
	 hEIqHoTuTvXr1gXpA0idlwJIYg5u3XBzwwn0jQwv7ZiYwLpTZiX1DDMnoB9GdQ6TdH
	 rf/ZvVt3NqOftmSVX5uGrj0Euh6Z3dNAtYSiqFF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>
Subject: [PATCH 5.15 045/120] wifi: cfg80211: fix buffer overflow in elem comparison
Date: Mon,  5 Dec 2022 20:09:45 +0100
Message-Id: <20221205190807.902109531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9f16b5c82a025cd4c864737409234ddc44fb166a ]

For vendor elements, the code here assumes that 5 octets
are present without checking. Since the element itself is
already checked to fit, we only need to check the length.

Reported-and-tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 0b8fb8235be8 ("cfg80211: Parsing of Multiple BSSID information in scanning")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2477d28c2dab..937ec4c2a3bf 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -330,7 +330,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 			 * determine if they are the same ie.
 			 */
 			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
-				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+				if (tmp_old[1] >= 5 && tmp[1] >= 5 &&
+				    !memcmp(tmp_old + 2, tmp + 2, 5)) {
 					/* same vendor ie, copy from
 					 * subelement
 					 */
-- 
2.35.1



