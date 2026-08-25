Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD23429039;
	Tue, 25 Aug 2026 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664764; cv=none; b=HG50K0jYKtqpI4bzDxoe8bNxvQ6v4JbReG0vZG+ds7kHhJ+5l7NjVtEInv2HFM9qT94ZwGRJf7VCWIqIHE+bX6BdkdsNLy4L91B3P5lYUANp9zvycGgJYIchGgEucgG+42yu+GkyWexZ8BDDPBo5KXIJlzm8Vi7Rkfxzg19yr7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664764; c=relaxed/simple;
	bh=YojsfnKmkjrxAht69DWOJrgREH7ssg5bRIcbCbH6IZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utkUdCYnvmXCMkW1ZGIZWxIsWkeoVws2BN5aiUWSK9b4xmFnhPH0gJ/1oqQ8gSWJqEMQqw6KLFha6ymzEyL+AH1zCAQEQ8rv2lGO0XI0huVqVAapjQenZg1gDjHr4LdV/G2JaRLJ47fnC5KtgsiBdtky42JqoWoxyyv/kX1PCRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHUTTt31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHUTTt31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ECC1F000E9;
	Tue, 25 Aug 2026 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664763;
	bh=B1vaLnMI0YHE+7MQx0m3OYrWhMqISyrIEpgalDk+NuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XHUTTt31PUzEHBHz5mhu+Bq1333YOtSjW/lif1rf+FpKIVBAkLorCrfi2J8oXcdLT
	 HKrdwq/zxRzhUChyFakqda0GV435dCUkAjaBxJ6TJl35QQsFlyqRVmW+1T0YqXbb4V
	 FzESmsz9SWr8wkFhFU/k437EjAC4vpupJGFGG3pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 77/82] Bluetooth: hci_event: validate LE Set CIG Parameters response
Date: Tue, 25 Aug 2026 15:26:04 +0200
Message-ID: <20260825132544.507406950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3829,8 +3829,10 @@ static u8 hci_cc_le_set_cig_params(struc
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


