Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B7023EA92;
	Mon, 27 Oct 2025 19:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592413; cv=none; b=k9ZNU7gqzA4itLfJP9Ip5HA7Z+JyPmyXJFwuZuORMPA8OhYwlYEHyxDkeeJubKi2hVBKSKMGvplrT4Gr7al+/c6fet8zQVby5GpMo4vaFYN4+zrFP2ssWEKIePwpjKzoiF4nNvZM2nzdgdWbn8QThrkaFd7+olOUhuR7Bhv7KDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592413; c=relaxed/simple;
	bh=0c/RF5nPYb30xrWBi6l9CC8FLdFNLp28wt0fN4Arrd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3yJ3j3dORa3oBBG94F8DT+YxUoIox/TAIVtvQEod7EW2W3RpTIc99SbJiO6IEBDHeR7m5i4kbm59cpdR3J3D2AZB90/duTT5dtH57GjSUschMPNQxlPYUNUELUUkSBiqTkK8+Z/3X1/0ysW1GXCn0PY/wT+P0WK8SAyDNUVA78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh2mHee+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh2mHee+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC82C4CEF1;
	Mon, 27 Oct 2025 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592413;
	bh=0c/RF5nPYb30xrWBi6l9CC8FLdFNLp28wt0fN4Arrd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh2mHee+yL+axF/XU04XH57P+Tqii3KatXItdIRaVKmcvZ/50O+dAQFeKw7NRikv/
	 Iy3QGjZr1lU6lDhcXchJ1gtQfCWn3srz0k0V8puiUvlmt+zou9KhdOxrpq5/t8mnhB
	 Hnm5l5ZOQAHSHocJqgTKWZonncSqL+44VGHv2Vw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f6c3c066162d2c43a66c@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.1 110/157] comedi: fix divide-by-zero in comedi_buf_munge()
Date: Mon, 27 Oct 2025 19:36:11 +0100
Message-ID: <20251027183504.202704598@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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


