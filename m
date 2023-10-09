Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E53617998
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSfh+N+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C58BC433C7;
	Mon,  9 Oct 2023 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857002;
	bh=9ndXYrCyP123GQ4fUv5MPwRXJJGQvhW1tO6Hn3yp50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSfh+N+lRksGkF4lY5PhFpeNu7znFClyTKOLv128LjEHquzf8jXDTy1ujEB1ijddR
	 cfbJe4ttc49uLeWkn1fGZIhlqtlDFHmByxjDvkyG8gA+gH3xPSBSNpw9f2ZimuqJBc
	 SJnth2ZOKZeNe5ssaggC7PHRgK4ZNY/zBss9JNrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.5 036/163] wifi: brcmfmac: Replace 1-element arrays with flexible arrays
Date: Mon,  9 Oct 2023 15:00:00 +0200
Message-ID: <20231009130124.998919832@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juerg Haefliger <juerg.haefliger@canonical.com>

commit 4fed494abcd4fde5c24de19160e93814f912fdb3 upstream.

Since commit 2d47c6956ab3 ("ubsan: Tighten UBSAN_BOUNDS on GCC"),
UBSAN_BOUNDS no longer pretends 1-element arrays are unbounded. Walking
'element' and 'channel_list' will trigger warnings, so make them proper
flexible arrays.

False positive warnings were:

  UBSAN: array-index-out-of-bounds in drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:6984:20
  index 1 is out of range for type '__le32 [1]'

  UBSAN: array-index-out-of-bounds in drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1126:27
  index 1 is out of range for type '__le16 [1]'

for these lines of code:

  6884  ch.chspec = (u16)le32_to_cpu(list->element[i]);

  1126  params_le->channel_list[i] = cpu_to_le16(chanspec);

Cc: stable@vger.kernel.org # 6.5+
Signed-off-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230914070227.12028-1-juerg.haefliger@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/fwil_types.h    | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index bece26741d3a..611d1a6aabb9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -442,7 +442,12 @@ struct brcmf_scan_params_v2_le {
 				 * fixed parameter portion is assumed, otherwise
 				 * ssid in the fixed portion is ignored
 				 */
-	__le16 channel_list[1];	/* list of chanspecs */
+	union {
+		__le16 padding;	/* Reserve space for at least 1 entry for abort
+				 * which uses an on stack brcmf_scan_params_v2_le
+				 */
+		DECLARE_FLEX_ARRAY(__le16, channel_list);	/* chanspecs */
+	};
 };
 
 struct brcmf_scan_results {
@@ -702,7 +707,7 @@ struct brcmf_sta_info_le {
 
 struct brcmf_chanspec_list {
 	__le32	count;		/* # of entries */
-	__le32	element[1];	/* variable length uint32 list */
+	__le32  element[];	/* variable length uint32 list */
 };
 
 /*
-- 
2.42.0



