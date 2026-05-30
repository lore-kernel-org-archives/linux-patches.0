Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39C13242BA;
	Sat, 30 May 2026 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165874; cv=none; b=BQ2WrclCph4/SoDWjB9chJUowcwonSol+q3LMKr34UwauK2p0UUo9oCYWC4nAhIjsnI36jXnPicWXDbltnLy5r41xBe8bxvj2u8rgPQJJS00RQH7480U8JdLT4YuQLP6Oaez3fPrLHx/SAAZ+wCWw0SL166UbtcqYdByp3mJ3ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165874; c=relaxed/simple;
	bh=BOuUqagMj51506S4AzcyONHkFdkvohsr+9gCP4xb6h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I21x7jAaMaPTJtDx76WkwsTiqTqlTggDc0lB1aOZRIivuj4n65UMCW/E6DNes7+VgHRcHe+3vOAxn3x1WAuOyK+SiBewMpcEpsKCYcT+GiQHS7QJkjMA8wQOOBRZ8roVucz0LynZW4FvD0vSuaqpDeC1kf2FBJc7F+/1F+M61Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfoVmkvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfoVmkvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9EE1F00893;
	Sat, 30 May 2026 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165873;
	bh=ZzRlr/7OtsbeQiH3TCNR90Qyb7AbXBDKBDWy1VxOZ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfoVmkvbACVKQk7YIvE4ux6TEQEJQPdFQggDsl+NW0zq6I2UDFlzUbXSGVyRcN6ga
	 0mBCHoa6bZgpPHR9wkh3zyH9z4ubLGe+iuN7J/+JgrNPxfYlOpcLsHjkOVNSfkxnyR
	 HtfJGyjlGH/fL5B84uJtsYNeXIzEe9sOEgJu3Edk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 5.10 206/589] ipmi: Check event message buffer response for bad data
Date: Sat, 30 May 2026 18:01:27 +0200
Message-ID: <20260530160230.362466423@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -623,7 +623,13 @@ static void handle_transaction_done(stru
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
 


