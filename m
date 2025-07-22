Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47EC23B614;
	Tue, 22 Jul 2025 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192083; cv=none; b=moYigE4+I5RH5xKPmWmK78HygJR9wHHqay2jtQHGpUYmuRgkXgaljn2xvLXvuCUyBM0FVYBD3H5DBXU6uVs6ebIGwAeC3dp2V4glQyv2cZAA8nNBKYtV2q6n0cjZ+LP1xdidwPsqtOC9A3Wqoyh8Ei90V/qxuv0lM8CmlLOnjAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192083; c=relaxed/simple;
	bh=zgcLAnbgM3nvdFLJDNnPMeTod4P+y3UzAWJ7Iw2DvUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVqM00oC5/nwUGa1ahgwZUjaOXCj+eKoodwUGVMzaSCpzso621iUs1hnqExVljYf9Copq6sFi0al9QqOMoPG2SD6GVF3dyjovRMM9LDCaAFXKWBy7p/Spp0PtIYoFQFDy5GeA2l5W8aj0orOiSun7RNyylLLVsZh32dts3stLJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQE+dfGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQE+dfGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121C6C4CEEB;
	Tue, 22 Jul 2025 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192083;
	bh=zgcLAnbgM3nvdFLJDNnPMeTod4P+y3UzAWJ7Iw2DvUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQE+dfGPI1O37NUfGmVyApejF/cXezIZgC9saD4rTlclp/ly2UDVt4k8ml3JrRGRj
	 inIwvhFxExdayMVXFv9Kdp1mwhra6p1EvxnnMoBgiqqtqUvbV34IoaANz3wXqIS8vn
	 Vq/8/SCKTzgZ5pi78YHEg7bRUvVMg64KVcxWRI6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 12/79] HID: core: do not bypass hid_hw_raw_request
Date: Tue, 22 Jul 2025 15:44:08 +0200
Message-ID: <20250722134328.835739940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1964,8 +1964,7 @@ int __hid_request(struct hid_device *hid
 	if (reqtype == HID_REQ_SET_REPORT)
 		hid_output_report(report, data_buf);
 
-	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
-					  report->type, reqtype);
+	ret = hid_hw_raw_request(hid, report->id, buf, len, report->type, reqtype);
 	if (ret < 0) {
 		dbg_hid("unable to complete request: %d\n", ret);
 		goto out;


