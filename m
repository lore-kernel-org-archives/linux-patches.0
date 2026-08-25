Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EA425A655;
	Tue, 25 Aug 2026 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665585; cv=none; b=iZCKAEfgzMt9RBogSw6756OedVTu131xNODfxByVYeKozz0yGsCAyHCj0DHvyqbHynUXRMNFxIo+fp5rMUEIrZ/sUJuvLXZmX6dS+1oi0aazNdduvo4pIu/FqTv5ePDZLG2of3m7snEtOA44+Nz/dLehGZBuXVkTwVSxdBnyN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665585; c=relaxed/simple;
	bh=b+pmmyRiZKD+UHTPHsNj5gT2oTYuN3Mo681JvSpyghg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgwHpiB30Lk26WxE6ia4TrZsQdsrQbrgRK8ctS9sGf46/ptdIQSaj4u0qigxl36glORDUs9IukqPeyKFuDRRn9Um4vikqjE7Om19Yq8lnuxiG24ZDtxHPNZ3PpTsmikqD3Ql/Bdnh0C/BOAQrLkz8aaIxhCzzyZcTtX+Ax+NbEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIcDeTmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIcDeTmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9767E1F000E9;
	Tue, 25 Aug 2026 13:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665584;
	bh=1KHjPNiOC548GFCeUPg0KEuq8j2pp5fmMEXs1YDWyLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIcDeTmcCzgUxN4fw7G+UxRwNCi71ibu0SH0FU5VOuyBrlz1l9W2DlK61DyJ7STLt
	 2E9m9unqXOqLy6kONNo7wyPEqFq6OvNYhNEr4vcp2TXxXmupJSy1p2RJXSHnw4EGjX
	 nSRi8dVucZ5O6rg4NmpIXdVHIW78UHxcDb7S+8AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 75/77] Bluetooth: hci_event: validate LE Set CIG Parameters response
Date: Tue, 25 Aug 2026 15:26:37 +0200
Message-ID: <20260825132544.450801187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit 0acd4eeb4b225b9bebbf9ef96cc10cdd79b94899 upstream.

The Command Complete dispatch validates only the fixed part of the LE Set
CIG Parameters response. After that part is pulled from the skb,
hci_cc_le_set_cig_params() trusts num_handles and reads each entry in the
trailing handle array.

Matching num_handles against the command's num_cis does not guarantee
that the response contains the advertised handles. A truncated response
from a malfunctioning controller can therefore make the handler read
beyond the skb data.

Validate that the remaining skb data contains all advertised handles.
Include this in the existing response validation so malformed responses
also follow the established CIG failure handling.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3800,8 +3800,10 @@ static u8 hci_cc_le_set_cig_params(struc
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
 	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_CIG_PARAMS);
-	if (!rp->status && (!cp || rp->num_handles != cp->num_cis ||
-			    rp->cig_id != cp->cig_id)) {
+	if (!rp->status &&
+	    (!cp || rp->num_handles != cp->num_cis ||
+	     rp->cig_id != cp->cig_id ||
+	     skb->len < array_size(rp->num_handles, sizeof(*rp->handle)))) {
 		bt_dev_err(hdev, "unexpected Set CIG Parameters response data");
 		status = HCI_ERROR_UNSPECIFIED;
 	}


