Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E7D15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A7DC433C1;
	Mon,  5 Dec 2022 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268142;
	bh=1DJzPskboBtUXsdqAbjIvUURMyDvMycn7q27aKEbEQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQJxHuEtn5qsDEwslvsHKwE9NSqymDHJ7ix/ZvL7rG96XcfOwTAUxr+7ZC0b6r7Pg
	 PM6f2wWpGDrYXb9zaQEaDR4F1blOrSXqswnS/R/dOwm/bNUcSkQHCWi5f2ITOhfWmE
	 Kv4zx/Pn+pwbSkVshZl5OphP9yGDxaOyUU5vhEkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tam=C3=A1s=20Koczka?= <poprdi@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>
Subject: [PATCH 4.19 102/105] Bluetooth: L2CAP: Fix accepting connection request for invalid SPSM
Date: Mon,  5 Dec 2022 20:10:14 +0100
Message-Id: <20221205190806.546064260@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 711f8c3fb3db61897080468586b970c87c61d9e4 upstream.

The Bluetooth spec states that the valid range for SPSM is from
0x0001-0x00ff so it is invalid to accept values outside of this range:

  BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
  page 1059:
  Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges

CVE: CVE-2022-42896
CC: stable@vger.kernel.org
Reported-by: Tamás Koczka <poprdi@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5553,6 +5553,19 @@ static int l2cap_le_connect_req(struct l
 	BT_DBG("psm 0x%2.2x scid 0x%4.4x mtu %u mps %u", __le16_to_cpu(psm),
 	       scid, mtu, mps);
 
+	/* BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 3, Part A
+	 * page 1059:
+	 *
+	 * Valid range: 0x0001-0x00ff
+	 *
+	 * Table 4.15: L2CAP_LE_CREDIT_BASED_CONNECTION_REQ SPSM ranges
+	 */
+	if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {
+		result = L2CAP_CR_BAD_PSM;
+		chan = NULL;
+		goto response;
+	}
+
 	/* Check if we have socket listening on psm */
 	pchan = l2cap_global_chan_by_psm(BT_LISTEN, psm, &conn->hcon->src,
 					 &conn->hcon->dst, LE_LINK);


