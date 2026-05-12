Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BB73DC862;
	Tue, 12 May 2026 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607723; cv=none; b=KM7S0Ib2idpUasFg4nhunyW1qk8XpU7bW981EWW87U+iiQoEKb7ZfK5QFtSNiWH4uEld/2jwwDiO4UMk53cV5QmrkRJo1Dizq4RoWFBmRFB6VxNZIFL8szbWlolBeGM+fkDkN4BEJ9OoHFi7dDF+QYfvWRHLDudANfgcSS4lDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607723; c=relaxed/simple;
	bh=JUCpPlPDY7eWMkdCxPVh5I4bNDFuaq8mf074bnm/aoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUX1GFUOWSwki+ce57Gf+fbf/iIhpstTU6GMJYXIt+Ddg6kj9KrD77soS3MqGPNvNI1DCOLK4NbNoHY8EAXr9wdd6jV7dPcVmd1W61tsipn4niDZ3fK5NKNt4PLmCTFsTeeR8ZTUDqqhq4NVJuqCudPNLDxaaOJfKo0iT+5BaFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVNzOCSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVNzOCSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DFCC2BCC7;
	Tue, 12 May 2026 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607722;
	bh=JUCpPlPDY7eWMkdCxPVh5I4bNDFuaq8mf074bnm/aoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVNzOCScrCttTOu/btfTB51VIyP/gFIShceoNX8CL1AQlsB/UA6/S05E+iUxfZlia
	 xCywLceQqfFXYXdxDTAoHo4hWY7MjmjcvPgBBcrcE52MtqWsJ1fQjw0pzWnpk9bakd
	 zFCvI1guJuDIiDfadjwOPhbTpKe43HhpAZmm4m8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.12 003/206] ipmi: Check event message buffer response for bad data
Date: Tue, 12 May 2026 19:37:35 +0200
Message-ID: <20260512173932.888190614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 36920f30e78e69df01f9691c470b6f3ba8aebf98 upstream.

The event message buffer response data size got checked later when
processing, but check it right after the response comes back.  It
appears some BMCs may return an empty message instead of an error
when fetching events.

There are apparently some new BMCs that make this error, so we need to
compensate.

Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/lkml/20260415115930.3428942-1-matt@readmodwrite.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -625,7 +625,13 @@ static void handle_transaction_done(stru
 		 */
 		msg = smi_info->curr_msg;
 		smi_info->curr_msg = NULL;
-		if (msg->rsp[2] != 0) {
+		/*
+		 * It appears some BMCs, with no event data, return no
+		 * data in the message and not a 0x80 error as the
+		 * spec says they should.  Shut down processing if
+		 * the data is not the right length.
+		 */
+		if (msg->rsp[2] != 0 || msg->rsp_size != 19) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
 


