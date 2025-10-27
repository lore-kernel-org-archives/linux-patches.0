Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2312F25F1;
	Mon, 27 Oct 2025 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593033; cv=none; b=LDf2oKm3UJ5m/wOafRk/NmcVMCUIuwvNv1o0H80VHzoFAQzrUJO+CcGMqheFSzPqOTLmeePE2PJNJeCV40Igj3SZbpFe77cp4j8b07C4TsrkwUauBdlfpnLmrgPabJsnpQrlQGyNbMXpVvg+ES4/szxLbTPLCMDpf7h9V2DSogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593033; c=relaxed/simple;
	bh=o8XaPq5qDjaNYUnrZFQErK4xW2F6KoO3jbPh6BZkH54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzRhVWr8boRoq1YNxawM31J95bTMugiYJE77NX3uCkQsxnnS+bxbsSnAqzf96kddA5de2I6qGHWsVaSC00ztiVjvUJSJM4ys4WBX8e1xJKfOSlgnq38MPzDhBUi63X8eM20wtzKW45aLPgDESiq43IljDA91LTr/A9OU6Gt0rPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoglarWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoglarWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B86C4CEF1;
	Mon, 27 Oct 2025 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593033;
	bh=o8XaPq5qDjaNYUnrZFQErK4xW2F6KoO3jbPh6BZkH54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoglarWDYJuJtyYFgvMaxdwOD0N4knEKI+tBAqqqVV05RIRyl/uXYeevS6N+fZqBJ
	 OvDxcccTcyg78suPP3t3/3CTDaWL90HCanUyXWsIg2b2WEkDmQf3KH6VP3W1HBTRJn
	 461SFk0cDMrIaolF3FIAPIU3JxOH22WU2C/e09FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6c3c066162d2c43a66c@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 103/117] comedi: fix divide-by-zero in comedi_buf_munge()
Date: Mon, 27 Oct 2025 19:37:09 +0100
Message-ID: <20251027183456.807622715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 87b318ba81dda2ee7b603f4f6c55e78ec3e95974 upstream.

The comedi_buf_munge() function performs a modulo operation
`async->munge_chan %= async->cmd.chanlist_len` without first
checking if chanlist_len is zero. If a user program submits a command with
chanlist_len set to zero, this causes a divide-by-zero error when the device
processes data in the interrupt handler path.

Add a check for zero chanlist_len at the beginning of the
function, similar to the existing checks for !map and
CMDF_RAWDATA flag. When chanlist_len is zero, update
munge_count and return early, indicating the data was
handled without munging.

This prevents potential kernel panics from malformed user commands.

Reported-by: syzbot+f6c3c066162d2c43a66c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6c3c066162d2c43a66c
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20250924102639.1256191-1-kartikey406@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/comedi_buf.c
+++ b/drivers/comedi/comedi_buf.c
@@ -368,7 +368,7 @@ static unsigned int comedi_buf_munge(str
 	unsigned int count = 0;
 	const unsigned int num_sample_bytes = comedi_bytes_per_sample(s);
 
-	if (!s->munge || (async->cmd.flags & CMDF_RAWDATA)) {
+	if (!s->munge || (async->cmd.flags & CMDF_RAWDATA) || async->cmd.chanlist_len == 0) {
 		async->munge_count += num_bytes;
 		return num_bytes;
 	}


