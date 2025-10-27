Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC75218EB1;
	Mon, 27 Oct 2025 19:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591705; cv=none; b=ZOYWOw4sblyD3aYkpTmJFJnXDceMkU6skJLsrlQRp8i5rIJJdpuCg4Wu15lIkYc8ERDjC6h0X218pQanjZKjd8cD3KLWJ7QgFiasQQtuhxAA10zeqzeNl57jWiiqP7LefA5U6ExlQLbMCTa1nZVxKLi95RB8p9of6uqhvPV4TF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591705; c=relaxed/simple;
	bh=DwAWr/bUNEo5J9s6hBCoE1ujNSc0vycXhlsaiGEAiDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DApCbGfs3+nZdEv0uYiuRZOb5695poxzt3d+sKkLw/5t9FGI+rvs5X3JcwAI2M+Mq1x/noPOAx2yOdfRqh4V1amxm6dq2lSnHMVtclV5kHQZ8t5Wjlr9n4Sti5uGHPL2tZdnurhqGDMnGKDxR8ozPuTIaQr7CZlZoskQLw22ZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxRQETk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxRQETk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D416EC4CEF1;
	Mon, 27 Oct 2025 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591705;
	bh=DwAWr/bUNEo5J9s6hBCoE1ujNSc0vycXhlsaiGEAiDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxRQETk478sxid4C/l7rQ4bYd+XJfaEYom6uAuC7nCHO5eb1DDl0sKRTZ6C5Lc0KY
	 5wOkB9iMEz4Oeg9RUtdd6GdiOGWQd+5WftOGT1m3ANfMwUjA54PbzSAdDcslNahmUN
	 GTSrag7Ki4ORvNv+gcyfozNzw1DuCK/BNFeVCGc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6c3c066162d2c43a66c@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 298/332] comedi: fix divide-by-zero in comedi_buf_munge()
Date: Mon, 27 Oct 2025 19:35:51 +0100
Message-ID: <20251027183532.720936237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
 drivers/staging/comedi/comedi_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -369,7 +369,7 @@ static unsigned int comedi_buf_munge(str
 	unsigned int count = 0;
 	const unsigned int num_sample_bytes = comedi_bytes_per_sample(s);
 
-	if (!s->munge || (async->cmd.flags & CMDF_RAWDATA)) {
+	if (!s->munge || (async->cmd.flags & CMDF_RAWDATA) || async->cmd.chanlist_len == 0) {
 		async->munge_count += num_bytes;
 		count = num_bytes;
 	} else {


