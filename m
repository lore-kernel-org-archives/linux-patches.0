Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C30E30568A;
	Fri, 15 May 2026 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860965; cv=none; b=Z7ZsifkAXGa0WMmiKvXqEiGXjMfc+A8N6V8GYCMgwo85tb1o9f+PXPiY+fC4JAVA7hZOSK9eGnByNy8SL/CRNu8OuwW2YC9bEtTBXkzu1KRJXZJeTyBgLXcn6WyBK7VPnZt2ADdzLhn+ovQgphT+OIOGCLjnH/kkzovimV4pwXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860965; c=relaxed/simple;
	bh=BQZ5A8HbSIxQvWrkSr6kJVj/YHnwEWdIsZNQAcecOBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqIYFJXK0Iwfj8xdFQ9k6h0eHvz+ks/rlLKcQ/DWyndki0r8P6spLf4arLIXXTD5HkXFKe1x7uDDbOP6iaEsw+TpK+nnb15YU9AQ3TyS+MTCpyxnq47oSmIGxAWvymKjK4zdNC2qzKecD+M55xTFn2JMoDcdZSnvtx2HP25IuBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaPtVycv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaPtVycv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D0BC2BCB0;
	Fri, 15 May 2026 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860965;
	bh=BQZ5A8HbSIxQvWrkSr6kJVj/YHnwEWdIsZNQAcecOBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YaPtVycvcjHTvWAS4rsTxr2QylDVW63BtIa3XWNKUlVwbdjjWTI0LluGpT3REqvif
	 gdg49BAyOukpIrUHPNdelygUFFFj2ES0zVu55cNsybSfevg+YH2w9QS3k3qkSafqrz
	 pNiuCNLogtOZKpbEylSYmTpNjK6gOQdGnaXTAD+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 146/474] ipmi: Check event message buffer response for bad data
Date: Fri, 15 May 2026 17:44:15 +0200
Message-ID: <20260515154718.187457053@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


