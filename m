Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8FB32BF24;
	Sat, 30 May 2026 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160228; cv=none; b=nZa8RYZBET/zrVP0AL6fes+X1mlIsgBdExY3ZkAem49nfi/CFPAf0atA+VTIeXLAN5Ts3YW+38W7PaYod42VFgGAxE1Eoq+CXO2Ubu17ozekaCOQKbfsL6zuERzZddlbHy4qWH+7/bXp4HAnp9AZ+n4X4ifGxGXRyB2zNtPs6go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160228; c=relaxed/simple;
	bh=0O6DABNiT4JjYfnL/ipKss5UtZCvj2JlQu1y2ocCnwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4HueKNT6wMBMqtddfsZcIHMCY9osFT7kdxFBWOYpRHgeiMBPf6pKUuUVC/2WyF/nybPY1LGa5RD06yNb8nZYnic/vHiSG5Utcice4ic6BtAlICs4j/CadB2/wzQfWF7d4sbgc4oeVvuuiN0pMfln6o+mQq1qByYsjB/UgVvXNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqtdjc1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqtdjc1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B331F00893;
	Sat, 30 May 2026 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160227;
	bh=cLVdB4zD0M9wJh+j/KEIVoaPqHd2swoLoXHsf07cF50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqtdjc1BVU0Nm5Dttjctp1iypT2MKNEiLGZ1OFhvUOeoJHDyfpZHCskc13Ow9uW3f
	 x3jTegkDIvBppRyIJkI1eWEWX1qkB8NgWauzcoaqbQDFEvY1fuEj46Zqsj80j7Qdrz
	 BCp1Jlw9OtLDXPACODOTXbfoOTtqRC8aQ34DrLQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.1 281/969] ipmi: Check event message buffer response for bad data
Date: Sat, 30 May 2026 17:56:45 +0200
Message-ID: <20260530160308.231296481@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
 


