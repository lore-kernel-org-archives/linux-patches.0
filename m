Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39423DB92
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trSYVebc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F38C433C9;
	Wed, 15 Nov 2023 19:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076841;
	bh=j4vKVH82JoWSqYZ0pI2Y+svHhnDCEpd7YyRefZ+b60M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trSYVebcidAkFrvbklg2m3WHv0NBGSJHK/TVL/kisHqAEL8xFl82Umdcyqy+WuAwP
	 LPU+L6rPuRYB276MMlgHRC0NYyf5Q6NVwRD4oxDYTXebkpCjvrAlHsdrWmjz7dBT19
	 H20DmXD3o7fUR28l2itfUlrGuk2wD62INTn3MvEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/603] wifi: cfg80211: fix off-by-one in element defrag
Date: Wed, 15 Nov 2023 14:09:48 -0500
Message-ID: <20231115191616.141289227@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 43125539fc69c6aa63d34b516939431391bddeac ]

If a fragment is the last element, it's erroneously not
accepted. Fix that.

Fixes: f837a653a097 ("wifi: cfg80211: add element defragmentation helper")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230827135854.adca9fbd3317.I6b2df45eb71513f3e48efd196ae3cddec362dc1c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8210a6090ac16..e4cc6209c7b9b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2358,8 +2358,8 @@ ssize_t cfg80211_defragment_element(const struct element *elem, const u8 *ies,
 
 	/* elem might be invalid after the memmove */
 	next = (void *)(elem->data + elem->datalen);
-
 	elem_datalen = elem->datalen;
+
 	if (elem->id == WLAN_EID_EXTENSION) {
 		copied = elem->datalen - 1;
 		if (copied > data_len)
@@ -2380,7 +2380,7 @@ ssize_t cfg80211_defragment_element(const struct element *elem, const u8 *ies,
 
 	for (elem = next;
 	     elem->data < ies + ieslen &&
-		elem->data + elem->datalen < ies + ieslen;
+		elem->data + elem->datalen <= ies + ieslen;
 	     elem = next) {
 		/* elem might be invalid after the memmove */
 		next = (void *)(elem->data + elem->datalen);
-- 
2.42.0



