Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2563A22DFA7;
	Tue, 26 Aug 2025 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217153; cv=none; b=SEXbUZDTHe0NPa2zo9c++RyniTPj2t/hz27AtkMInq7Fa42cJMv62witEbIu756yaxiVYVnyhhiwDU41FYYsIdkRvT7RERk2Xj0dIHD09Zc0V6UpIoGNAYG0gG9XEpEE4NbPTmWEp6vWVl+eky0oy3GXQhBnjw8mDxkO0Tmnut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217153; c=relaxed/simple;
	bh=tnoxT/UjLfWKQ1og+KhiQZTeQeRU6IxUGlMRtt+mt4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrPl8kdWpEGzUJS0MjVzUXyZ2+KFWS+N570fzdhs9q8ave589dtBe/zQ35Kgo6yMhIDYNRQf/4DVvE4LSBKqrRT5yiLFml6m4E+z7TQcFpSxZJz7d+igX0kVPnWEimRaj3eWE1eqQvR6js9x/nqiANUpPi+2WLxlU82tiex4in4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUFgYrPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUFgYrPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8692C4CEF1;
	Tue, 26 Aug 2025 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217153;
	bh=tnoxT/UjLfWKQ1og+KhiQZTeQeRU6IxUGlMRtt+mt4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUFgYrPePHg+lfdswCCJQG99tGa2859btASPyFSV19Ri/6hSHrvoLdnpDFADqNQdl
	 RdyJLyUY9Sq4KT+AcgKykzNLFqqgu+RPdnjKLplaT61//yzimFUrIC+W+qaCADj09V
	 EH3YnmPXofzkMfZ/XMhGFSOtW9x0mce+GTP805Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 010/523] HID: core: ensure the allocated report buffer can contain the reserved report ID
Date: Tue, 26 Aug 2025 13:03:40 +0200
Message-ID: <20250826110924.834196417@linuxfoundation.org>
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
@@ -1662,9 +1662,12 @@ u8 *hid_alloc_report_buf(struct hid_repo
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


