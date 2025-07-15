Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9142F2E3391;
	Tue, 15 Jul 2025 13:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586859; cv=none; b=cp+HBkasQD16aKlFTlMGF5BcGqxY94rrEF5Tt4073VwRnd7KlKH6Aiv6X0/mo6gkhG2SQjINmaBdHA4kS9umNih4vxjbErdtITChvWlpl4zBfQVQxV2biVjALLfr8pZl86PFOVaReMzwVEJug1SKv2p/F2TlawfYchB+6mPG8+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586859; c=relaxed/simple;
	bh=JzvCaWveh4m/rGV8oGUdMp0T4xbertVw5KyTm8QB0ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5zU8lKfVlv1WyGmmsb/+Qwkk9WcxDv2BLLtyTdIM1PVzs000y09CXfpFd3ZbuyU3stPUb27qnA9dk3pVIXiCUalMZv8QZ9FPzoeU1jCnXV1EppqyhCyAbKV9Rf1H8beXrze1BOJjHtDry/s4wXs/xiV3ifzoWOZQfvUltQt7jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWRDwsxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWRDwsxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A34C4CEE3;
	Tue, 15 Jul 2025 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586859;
	bh=JzvCaWveh4m/rGV8oGUdMp0T4xbertVw5KyTm8QB0ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWRDwsxWAknNAkbj88p4X52ZxWYvehMVVywjnZTGbj+gDEMr6nii/vobOWhv4q7qv
	 9be8LCoUXRlaaMLy/eOvF7r1GLsgehp1vHjHNK9d1QPu39O8yqRB8OecGrG2JsT4t2
	 hPZZQeP22GYq6hcoVN3mFf7yUXoViIgVTz+GML5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.15 075/192] wifi: prevent A-MSDU attacks in mesh networks
Date: Tue, 15 Jul 2025 15:12:50 +0200
Message-ID: <20250715130817.940290624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>

commit 737bb912ebbe4571195c56eba557c4d7315b26fb upstream.

This patch is a mitigation to prevent the A-MSDU spoofing vulnerability
for mesh networks. The initial update to the IEEE 802.11 standard, in
response to the FragAttacks, missed this case (CVE-2025-27558). It can
be considered a variant of CVE-2020-24588 but for mesh networks.

This patch tries to detect if a standard MSDU was turned into an A-MSDU
by an adversary. This is done by parsing a received A-MSDU as a standard
MSDU, calculating the length of the Mesh Control header, and seeing if
the 6 bytes after this header equal the start of an rfc1042 header. If
equal, this is a strong indication of an ongoing attack attempt.

This defense was tested with mac80211_hwsim against a mesh network that
uses an empty Mesh Address Extension field, i.e., when four addresses
are used, and when using a 12-byte Mesh Address Extension field, i.e.,
when six addresses are used. Functionality of normal MSDUs and A-MSDUs
was also tested, and confirmed working, when using both an empty and
12-byte Mesh Address Extension field.

It was also tested with mac80211_hwsim that A-MSDU attacks in non-mesh
networks keep being detected and prevented.

Note that the vulnerability being patched, and the defense being
implemented, was also discussed in the following paper and in the
following IEEE 802.11 presentation:

https://papers.mathyvanhoef.com/wisec2025.pdf
https://mentor.ieee.org/802.11/dcn/25/11-25-0949-00-000m-a-msdu-mesh-spoof-protection.docx

Cc: stable@vger.kernel.org
Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Link: https://patch.msgid.link/20250616004635.224344-1-Mathy.Vanhoef@kuleuven.be
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -820,6 +820,52 @@ bool ieee80211_is_valid_amsdu(struct sk_
 }
 EXPORT_SYMBOL(ieee80211_is_valid_amsdu);
 
+
+/*
+ * Detects if an MSDU frame was maliciously converted into an A-MSDU
+ * frame by an adversary. This is done by parsing the received frame
+ * as if it were a regular MSDU, even though the A-MSDU flag is set.
+ *
+ * For non-mesh interfaces, detection involves checking whether the
+ * payload, when interpreted as an MSDU, begins with a valid RFC1042
+ * header. This is done by comparing the A-MSDU subheader's destination
+ * address to the start of the RFC1042 header.
+ *
+ * For mesh interfaces, the MSDU includes a 6-byte Mesh Control field
+ * and an optional variable-length Mesh Address Extension field before
+ * the RFC1042 header. The position of the RFC1042 header must therefore
+ * be calculated based on the mesh header length.
+ *
+ * Since this function intentionally parses an A-MSDU frame as an MSDU,
+ * it only assumes that the A-MSDU subframe header is present, and
+ * beyond this it performs its own bounds checks under the assumption
+ * that the frame is instead parsed as a non-aggregated MSDU.
+ */
+static bool
+is_amsdu_aggregation_attack(struct ethhdr *eth, struct sk_buff *skb,
+			    enum nl80211_iftype iftype)
+{
+	int offset;
+
+	/* Non-mesh case can be directly compared */
+	if (iftype != NL80211_IFTYPE_MESH_POINT)
+		return ether_addr_equal(eth->h_dest, rfc1042_header);
+
+	offset = __ieee80211_get_mesh_hdrlen(eth->h_dest[0]);
+	if (offset == 6) {
+		/* Mesh case with empty address extension field */
+		return ether_addr_equal(eth->h_source, rfc1042_header);
+	} else if (offset + ETH_ALEN <= skb->len) {
+		/* Mesh case with non-empty address extension field */
+		u8 temp[ETH_ALEN];
+
+		skb_copy_bits(skb, offset, temp, ETH_ALEN);
+		return ether_addr_equal(temp, rfc1042_header);
+	}
+
+	return false;
+}
+
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
 			      const unsigned int extra_headroom,
@@ -861,8 +907,10 @@ void ieee80211_amsdu_to_8023s(struct sk_
 		/* the last MSDU has no padding */
 		if (subframe_len > remaining)
 			goto purge;
-		/* mitigate A-MSDU aggregation injection attacks */
-		if (ether_addr_equal(hdr.eth.h_dest, rfc1042_header))
+		/* mitigate A-MSDU aggregation injection attacks, to be
+		 * checked when processing first subframe (offset == 0).
+		 */
+		if (offset == 0 && is_amsdu_aggregation_attack(&hdr.eth, skb, iftype))
 			goto purge;
 
 		offset += sizeof(struct ethhdr);


