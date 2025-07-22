Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC9623B614;
	Tue, 22 Jul 2025 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192010; cv=none; b=ah8VakyJqjVAoxI/lliNqRNZ2j0NN35+zVXVtNDIXhTclx2MCMJsgeaN/YbVQpbJM0KsjfkvTt+8H7vYXsxKInsPdsv2FySFYaoWR/dKlYY2wISR5ynBEwlSMCy8XcezN6i3RQ2rYbJqkKIdoeBazXtQ8aPudkZZAlM1ZnOo6cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192010; c=relaxed/simple;
	bh=nB/yGCfgwSP8WrdgB2GPoAaZvGmtQn9brToKBq95AFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS0MA6C0ePiKh6CMAgUeKDNMxFQBvMF39Lw+F8ysTLk/m5/poFJOtnfZDIsDyhQlYNwtCOdlY6NfYDMQ88by8JfVwzqOZ4TPWxc/h9VTNrGwn4yKpclwv7AQzeAwZMraUhULgDK0UxlGn9pI0xX7k1zZVICkt073dKBdeXvCKSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2OAffYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2OAffYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E54C4CEEB;
	Tue, 22 Jul 2025 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192010;
	bh=nB/yGCfgwSP8WrdgB2GPoAaZvGmtQn9brToKBq95AFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2OAffYED0VLWbAo5P12mwdXMpgs3OeSF/xQiEXtMB/b22h63HTzobXpmwapQea6J
	 J8W47b7y4hfODpylpKoLizKn+SAcx+nFBFGfL9ce97TrzDHDCack0Mm7JwllNfbWn8
	 8mvWc20BKKHiiHM+zTqoWyFcTyC+kUIWkXgL5ro0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 10/79] HID: core: ensure the allocated report buffer can contain the reserved report ID
Date: Tue, 22 Jul 2025 15:44:06 +0200
Message-ID: <20250722134328.764136168@linuxfoundation.org>
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

commit 4f15ee98304b96e164ff2340e1dfd6181c3f42aa upstream.

When the report ID is not used, the low level transport drivers expect
the first byte to be 0. However, currently the allocated buffer not
account for that extra byte, meaning that instead of having 8 guaranteed
bytes for implement to be working, we only have 7.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Closes: https://lore.kernel.org/linux-input/c75433e0-9b47-4072-bbe8-b1d14ea97b13@rowland.harvard.edu/
Cc: stable@vger.kernel.org
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20250710-report-size-null-v2-1-ccf922b7c4e5@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1876,9 +1876,12 @@ u8 *hid_alloc_report_buf(struct hid_repo
 	/*
 	 * 7 extra bytes are necessary to achieve proper functionality
 	 * of implement() working on 8 byte chunks
+	 * 1 extra byte for the report ID if it is null (not used) so
+	 * we can reserve that extra byte in the first position of the buffer
+	 * when sending it to .raw_request()
 	 */
 
-	u32 len = hid_report_len(report) + 7;
+	u32 len = hid_report_len(report) + 7 + (report->id == 0);
 
 	return kzalloc(len, flags);
 }


