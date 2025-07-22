Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566A92EB5BB;
	Tue, 22 Jul 2025 14:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193221; cv=none; b=j8mygfovE0VdeLo64PvdrFWP0WelVQehFJnweZo0lhdIoqvR15sr7LvOgi0tBYxuhbSXG7fmj07MFdP5uSJqtgCPIYA4HHMWBzm2h1ek7CiP33TFP0idiT4BdXyQuVMRgz5mzxuO43hlk9nErUN+SfA87Cto2PxJj/b53ZhxGvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193221; c=relaxed/simple;
	bh=L8Hl+jZTtEgmWCtXeHG0iuQzlqmf1K3HzbI/1KMvmwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nhws7WuvCO914dzCwi90fvpCC3Csbgc0XaXwyXfUcn65VQzMBuaio3SV6kWaKbbyXd9iraejJuR2h9MF7tNZNumk/VHfrzgT4YNVRvuRMANVjJmFz+xYCPFFHzbiYvekLnwtkj54NuGleK4rBnzSC4EWwKRF1HBJRFeHGotWci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cI309SwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI309SwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8DEC4AF09;
	Tue, 22 Jul 2025 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193220;
	bh=L8Hl+jZTtEgmWCtXeHG0iuQzlqmf1K3HzbI/1KMvmwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cI309SwBJexZDkmjaXsNiVKsd/ogs0IuvhPRkn2lWajfEKPv3XHYJ/zK2Rg5fra/u
	 OyaEdJrdRDf7U6KSclr4qIM4m5lFC3H5CAVErdXs+tMzcF4zAgnGgydGQfviUIRO3+
	 tKHYsRuadyNRY+gAsH/cMeWYLilrl9qTN53Zc5Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.15 027/187] HID: core: do not bypass hid_hw_raw_request
Date: Tue, 22 Jul 2025 15:43:17 +0200
Message-ID: <20250722134346.775618514@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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
@@ -1996,8 +1996,7 @@ int __hid_request(struct hid_device *hid
 	if (reqtype == HID_REQ_SET_REPORT)
 		hid_output_report(report, data_buf);
 
-	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
-					  report->type, reqtype);
+	ret = hid_hw_raw_request(hid, report->id, buf, len, report->type, reqtype);
 	if (ret < 0) {
 		dbg_hid("unable to complete request: %d\n", ret);
 		goto out;


