Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12CF2E36E8;
	Tue, 22 Jul 2025 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192675; cv=none; b=hgbFUcczr79ikYlmOloNbY7qUZ40l8t6pa5FAb3fcD3QxTsDtuNij6Q2ZaIjFB+VQTUfcPTESqwoShsEpYBbX50FNxK4AKT1bxPAdvX1jBIEMFnTNhPz4lGhVfmPc+AR8eXiu+GofyuFUX2X8xC20HYJWxcosSpFi4sUGniZpKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192675; c=relaxed/simple;
	bh=7MhXFvdyDPiclDhg8Aa5Uqm+SSBiOFgu2owUb2Mdg60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYa3UtAsjQRkr7FVeQ+f2Lst4jtFYtDbLlyHZayCdojcHkYd09EbSyt4vMY52I7iCmVG0ayZw9Q/OXG5M7eYeip44DyzC5uP+EL7PRKwj0Rhp9Ndt0Vhn8edQU7wOPQR2myWsSuMrdIq5T1zkRwd373Ca5eplGoKVmCQ7ATINFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puaK0ND7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puaK0ND7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2BAC4CEEB;
	Tue, 22 Jul 2025 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192675;
	bh=7MhXFvdyDPiclDhg8Aa5Uqm+SSBiOFgu2owUb2Mdg60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puaK0ND7w5kCB+fISCWZyzcuEJsqkNchDkRxzTM0BWoFXxMGl1JsCIWlOglr6cXTX
	 /zsQrkpGtQqlDlas7PU+lu9doDB39g6iPJbcOre6huxMZ2VRGRHotVgaMipoOH1zKo
	 MNQCRmymPF9GChbmaTjnghNZK9wbaTrBjwK2eXuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 024/158] HID: core: do not bypass hid_hw_raw_request
Date: Tue, 22 Jul 2025 15:43:28 +0200
Message-ID: <20250722134341.637922093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1986,8 +1986,7 @@ int __hid_request(struct hid_device *hid
 	if (reqtype == HID_REQ_SET_REPORT)
 		hid_output_report(report, data_buf);
 
-	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
-					  report->type, reqtype);
+	ret = hid_hw_raw_request(hid, report->id, buf, len, report->type, reqtype);
 	if (ret < 0) {
 		dbg_hid("unable to complete request: %d\n", ret);
 		goto out;


