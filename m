Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067FA3546C0;
	Tue, 25 Aug 2026 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665342; cv=none; b=g8zJpHEiL0jfNopAwkeDogiKnVn1qk7cUF/z1t1osI5w9MIQXb+iuwhGlnk1ltPKWj5AbPE2JuAtfOHWDMV2ycTepbyZ1GInt8e+3VyFtDYSoRfKOYyaElmMnhj5N7CXD2VYS/MJIyQkze+x8FXe7GHTbRZ3Rnaq2pgJ9dw+wcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665342; c=relaxed/simple;
	bh=wom9kPwQhtXw5I+xAV1aiBgWbIx4I8cvU6mgMTeOE9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE9F5hwc8P9J/y9dmqCk8KaXLaJUXI8Q2n3zJ1B7htCcoI+VnSL+TtRXe8+2WfUyMEqRJmlLXPyfx0eZXKVUTYUXQAmbi5r7CcXbcfcJJuFlqSKoCzxHvyWRTYQIXewmtG8d+eMM6a4TFspIeoyNgfiHbNu+SEscRft2BV1NtBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2QNS0rr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2QNS0rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3AE1F000E9;
	Tue, 25 Aug 2026 13:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665340;
	bh=slSu7ZaSsagR6sF+DDW8INVQPF/M7wCFYfZFx0JR3YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2QNS0rr18kXsHhtcAyEV/1jD0MZuAjzmE6H4CDw90s9sGJQkl/R48phkETsSuybc
	 2pIgOzQ78byg9ZeoUge6QFzLYTltAbr8/rYoG9W0tGZpHgtlRaym3E/0zrS+gWEK+S
	 vOhbI9aJuBZ3cizcIpRVxhFTDcRSvBJSuGBRMKOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 89/94] Bluetooth: hci_event: validate LE Set CIG Parameters response
Date: Tue, 25 Aug 2026 15:26:25 +0200
Message-ID: <20260825132545.255486010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3817,8 +3817,10 @@ static u8 hci_cc_le_set_cig_params(struc
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


