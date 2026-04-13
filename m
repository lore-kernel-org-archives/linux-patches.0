Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0898632FA18;
	Mon, 13 Apr 2026 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099463; cv=none; b=V9A0yqR2C6CLQzg32uRfqXtbxpNxermQlwlj+BhGZupC9qMpOJ5QSYJxTBQ9keYg8DVeer5CEgizW/sZnj0BFsBRCB5/AQGShXYljUz0hKNEmVQKTpCS9xOKApgUsTYBNCI18ZV6TxeC9BbcJLoTJiDR2UYj8sIDTYpVePunq4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099463; c=relaxed/simple;
	bh=uY75nx5pZFSk2pFMsT5oXmTIehRA3nnfL9jZuNEThkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bsQtdlEg7c4DB7819kYjbqf4gmvbQLoVCi43cb5WZ6d+lMpc1yAJw29h5KkW69dIx09DgZnk6wCUR96qyizYfgZgXXCBdkJGJhYtt7BLRrth+c35Rct5L+P2feOhZNuz8QVvHRsMMpqihifkqCUsTeM5BZUQ097BGMt4B7RTCrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRANYfA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRANYfA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F98C2BCAF;
	Mon, 13 Apr 2026 16:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099462;
	bh=uY75nx5pZFSk2pFMsT5oXmTIehRA3nnfL9jZuNEThkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRANYfA6LChtO1uNRLrt56S7C0CURuzMmj5VsNBdX+rhN8D9eBHheg2H5BLEVQJGR
	 cbIOYgOQsVqdmwe7HaUAZgqaVQh0J5pIGEc+fntTeZioUC9YdLREZl7+B9SH8o+5F5
	 4rRJHmcqAb7ra5JhtPbpifAHOKm8qfJ7B8XmHNB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/491] HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq
Date: Mon, 13 Apr 2026 17:59:22 +0200
Message-ID: <20260413155830.910817765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit 2f1763f62909ccb6386ac50350fa0abbf5bb16a9 ]

The wacom_intuos_bt_irq() function processes Bluetooth HID reports
without sufficient bounds checking. A maliciously crafted short report
can trigger an out-of-bounds read when copying data into the wacom
structure.

Specifically, report 0x03 requires at least 22 bytes to safely read
the processed data and battery status, while report 0x04 (which
falls through to 0x03) requires 32 bytes.

Add explicit length checks for these report IDs and log a warning if
a short report is received.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 2a7cd5be87444..12d70983ed407 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1251,10 +1251,20 @@ static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 
 	switch (data[0]) {
 	case 0x04:
+		if (len < 32) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Report 0x04 too short: %zu bytes\n", len);
+			break;
+		}
 		wacom_intuos_bt_process_data(wacom, data + i);
 		i += 10;
 		fallthrough;
 	case 0x03:
+		if (i == 1 && len < 22) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Report 0x03 too short: %zu bytes\n", len);
+			break;
+		}
 		wacom_intuos_bt_process_data(wacom, data + i);
 		i += 10;
 		wacom_intuos_bt_process_data(wacom, data + i);
-- 
2.53.0



