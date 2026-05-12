Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325B3EDE71;
	Tue, 12 May 2026 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608992; cv=none; b=V1ojEBPHLC/d/0EeKowq03OXjIgUiSF3GX/v96O4ReeoLVz3hPNVVRnVmRkYuI4Zi//LBqDgP//paCWrusnBSLg7eB4C4imUs6ilk4oBISL2yvOTB+toU9M/M9dk+3T2mK6XtESdCvlWLaf0gk+dmEaOl0TywUX8lPYcjCGZ2oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608992; c=relaxed/simple;
	bh=pD4XhbTm+mVs9dBSi5Q6qIH0QISQ641b/2rKAFnFU2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wm2T5o4LhvvlqN2VAoGsUYXKV1FILFhxJS8JHeFkGNiJx2soxkQ3r+lieWU1hLvwH8mvyKPy4QYmaEpB006ivmg3xb3cGLjuG4Og1NmVma+RAcgxXo0rwIEuQ84jjss0WRGJyXJR8YcZ76BUnOnejifWI6Yr12XPbiEICuRTbz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3yN7h52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3yN7h52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0465C2BCB0;
	Tue, 12 May 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608992;
	bh=pD4XhbTm+mVs9dBSi5Q6qIH0QISQ641b/2rKAFnFU2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3yN7h52Vli/G6GJ1++LSRlwkyUrx77Kp/VEInnqGMH3Lrkbk9UuDngicMv+COl9k
	 e1mWatI+O7NeAfWkmDcZNfc/0CMYV2xNipE/0FnuBOAYwDC1VZZx1v/YD8OPtBMOw5
	 vt/t6hD233uE4+VeGhZO4jLkmVWA/DiN2yh7sFF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.0 003/307] ipmi: Check event message buffer response for bad data
Date: Tue, 12 May 2026 19:36:38 +0200
Message-ID: <20260512173940.192328446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -641,7 +641,13 @@ static void handle_transaction_done(stru
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
 


