Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FEF44AB91;
	Tue, 21 Jul 2026 21:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669763; cv=none; b=TVJF2uNjADDKOYGJSW468szMQ2mTZW2Sp60y5PW6yM8rG5wVBAkRxs5JJKBOCeqnq5dGwx1yk7LFWVEToNOBVqdikSGbjGCdPu7MfOQRTyc33DulLHH32nKRRUXfiGyOLb9z95fZHNDtWOV4fjWmYuHOirXa5Bm+Yfu7GQiivBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669763; c=relaxed/simple;
	bh=laGiSM45aBSL0irIISo0YdPyrf7So2GW0kjYF+mnIxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0T4+mPhgaRJ2Ta/avMUwLV6/1Fz2zZ4lLCAHSfpjjvCgpTtfHJwE1OpLbFtDmflJjhDSvQbEvWtt0VRBRL5yxg3LUSPAslGk/I+hjSu/Hsp+HOTq6p4JqhnLeBIeAKKgY6j9VLW6vBjZLJrxIj/idw/KS72LUKUIujwYFHUhnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rsp/ghdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rsp/ghdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B31F000E9;
	Tue, 21 Jul 2026 21:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669761;
	bh=8i57nUNMr/YdPDLZXIleF7o5rQj79hLD+1xTGQVPsls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rsp/ghdbCXCMpFBX3dY1bnZW1iGUC80InR99YIOTNHQo6pGayPfcVSmWHnMY3OTG6
	 QZJGyIK6iMnnOtTHgvcuXLMdPDmcnNwlS1/B+rJHK/cMk61j2axQGAdWIzz9P9bxoB
	 BwF48hCiilHynq6fjeDYx6lp7DQHw5GM1g0Ix/BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0677/1067] HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wait()
Date: Tue, 21 Jul 2026 17:21:18 +0200
Message-ID: <20260721152439.742544153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgiy Osokin <g.osokin@auroraos.dev>

[ Upstream commit 0021eb09041f021c079be1022934a280f7f176c0 ]

In picolcd_send_and_wait(), an integer overflow of the signed loop counter
'k' can theoretically lead to a NULL pointer dereference of 'raw_data'.
If the loop executes more than INT_MAX times, 'k' becomes negative,
making the condition 'k < size' true even when 'size' is 0.

Change the type of 'k' to 'unsigned int' to prevent the overflow and
eliminate the out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

[jkosina@suse.com: extended hash length]
Fixes: fabdbf2fd22fa17 ("HID: picoLCD: split driver code")
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-picolcd_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index bbda231a7ce303..ee0977a8e42e0d 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -72,7 +72,8 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 	struct picolcd_pending *work;
 	struct hid_report *report = picolcd_out_report(report_id, hdev);
 	unsigned long flags;
-	int i, j, k;
+	int i, j;
+	unsigned int k;
 
 	if (!report || !data)
 		return NULL;
-- 
2.53.0



