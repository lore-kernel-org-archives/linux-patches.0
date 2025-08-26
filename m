Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C7A1DE8BE;
	Tue, 26 Aug 2025 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217089; cv=none; b=eCpb/mjZsCa5JgivL70lrWbNJB/Z06/feFvZsfxvbaVmoF+1xNu03PwcJJuzf2FCjOGl9Ldibd2pWcZoSkqPxVnzqiRbGuSU72utF0R728D+EehMQIztKtT6h0WjJPsRzMAXWgPFu2KKbrQvpLY94ikRBAgipzVIzSQ7pgVebHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217089; c=relaxed/simple;
	bh=JxmDFLHm1JEbo3OsWLQuR2gjd1vCECNsM1fKbcx8pdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xmr5ZdCPuAqgUacrX9G7pZo7mkqdcauBBr29ys7GRoyum9YcVn1gFBKCTQ2hMVbB7DXJlrTlvRYkuaSIAzTkNH4P7BWR5bSsV4ELktMCw8dxm8X6FMkOKZ0sNgfn4gNNnYtGvn/6xnSFnIlAeZshwPO+lAWrvzEFIyMeduZBZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZ+SXf+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZ+SXf+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72354C4CEF1;
	Tue, 26 Aug 2025 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217088;
	bh=JxmDFLHm1JEbo3OsWLQuR2gjd1vCECNsM1fKbcx8pdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZ+SXf+7wSuZ34zf+V1DjltqscsqcIQhc5NYArEqUuJ4YkbaVoOWigorWrsWJOjEK
	 bhljbwWK7DVG7eVqIubfEhQr/KgPlhk7U/I3YHBEyUji2wT+71uG2y3IwOJISDvdqA
	 Krsrx+C0Nb6VZUs17GWkufHeuiDnDCmQrHfXmpug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 012/523] HID: core: do not bypass hid_hw_raw_request
Date: Tue, 26 Aug 2025 13:03:42 +0200
Message-ID: <20250826110924.886094389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit c2ca42f190b6714d6c481dfd3d9b62ea091c946b upstream.

hid_hw_raw_request() is actually useful to ensure the provided buffer
and length are valid. Directly calling in the low level transport driver
function bypassed those checks and allowed invalid paramto be used.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Closes: https://lore.kernel.org/linux-input/c75433e0-9b47-4072-bbe8-b1d14ea97b13@rowland.harvard.edu/
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250710-report-size-null-v2-3-ccf922b7c4e5@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1750,8 +1750,7 @@ int __hid_request(struct hid_device *hid
 	if (reqtype == HID_REQ_SET_REPORT)
 		hid_output_report(report, data_buf);
 
-	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
-					  report->type, reqtype);
+	ret = hid_hw_raw_request(hid, report->id, buf, len, report->type, reqtype);
 	if (ret < 0) {
 		dbg_hid("unable to complete request: %d\n", ret);
 		goto out;


