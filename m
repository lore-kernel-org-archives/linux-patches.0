Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F3E2EA490;
	Tue, 22 Jul 2025 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192281; cv=none; b=UrjE6NPHCbmhK0muMZVr37VtDPxZmDOXf1qahmnsdHuMrQ9Z4DeEW+3C1ihJmjOFfWidph1wdAR0rOsYZNQNtx1dIpFDA43c+5pFv3bIn+0FnT7Crbhd3YkpmZzfAEbqFbEwRJMVuCOM2br2EDDsy+E5so5f7bek2Q0cku46mT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192281; c=relaxed/simple;
	bh=XDtAxKkTKrTiQsyhY3m1eRwEeNF1Emni6+fFwiqalUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCdT0WWxSsITXs8VBwlS54iyFtjYvAo9nJkWmpEQK/UsdEziFQyk8RenXIeFvlpYv7I5+oDhKnCODRJDncvAoRvibK5nMC8UNJjqSHTiWvyJdQ9Jp/LveD+Ng+FS2DxhVAH/kcbgABJ5rpeIM1L9SGmKd+HC0GfdKxIg5BgU1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faX6bvB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faX6bvB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42A3C4CEEB;
	Tue, 22 Jul 2025 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192281;
	bh=XDtAxKkTKrTiQsyhY3m1eRwEeNF1Emni6+fFwiqalUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faX6bvB3/TpqOSAL7HyZ0rjJ+VkYOB0EsSbWTAoOEJDwLvDkq+7GMSnELOYhcuu4S
	 4VrCeE+zS8esYkh/K4JN58SxlRygmaA7u+rD9+5IQYvz22RCr1Ko20LYyQFcYkOABp
	 NM6JsF5jCimPxzGY1iOQdGfNfQb6pQmJ/Tq05zn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 019/111] HID: core: do not bypass hid_hw_raw_request
Date: Tue, 22 Jul 2025 15:43:54 +0200
Message-ID: <20250722134334.111118090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1961,8 +1961,7 @@ int __hid_request(struct hid_device *hid
 	if (reqtype == HID_REQ_SET_REPORT)
 		hid_output_report(report, data_buf);
 
-	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
-					  report->type, reqtype);
+	ret = hid_hw_raw_request(hid, report->id, buf, len, report->type, reqtype);
 	if (ret < 0) {
 		dbg_hid("unable to complete request: %d\n", ret);
 		goto out;


