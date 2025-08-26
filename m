Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330583570BC;
	Tue, 26 Aug 2025 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218515; cv=none; b=h7cjAJPCx5ykWeTnNW11l6ynLE9fKXoMvj/ccmmviXapFuDxiaXQvMU3+iXhHYiEni9vbrTpT4hvMyae8EdinmAPeHxssdDl1mP88IAvTnv44Z306Z0PqXF8zSgwBpqHzuwmhM58fSVz+hxVss05XEX1Lvj1gMsQ/FdkliDjkx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218515; c=relaxed/simple;
	bh=wyJAhkYzfVsE/BOip8vnFc5s9mtRak2C69NQTNeRvlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjGyGTHZUtcPFO9rjpsb4h03PE1S9/x5wp2s7tOTyWVyx9Sr9wv88W335LdEytb1cjrMJNrcq8HUw6FRHJbfdXY8+Owyi76GPcFFyDRcooCAuu8s/J8Wlqx1TcgVXGd4L6xTPFGra7JPuzPGHmghOuoW29oMQcimr6bs23c651k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2rnXuvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2rnXuvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5E8C4CEF1;
	Tue, 26 Aug 2025 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218515;
	bh=wyJAhkYzfVsE/BOip8vnFc5s9mtRak2C69NQTNeRvlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2rnXuvBayEYV28g8nCK7nyjZ5Pc83F/ov9Bh4f6VWshh4ecEe4GlOt4U/ehCwhiT
	 pk/NY9kwcIf0rbhVJfnz/28V8l4Jme8Wf7OVWGP2uiiJ9Rzg3ywMQNu6OGY1xD/2o8
	 HngVega8VdNGgJQaRupgnU6ZcHhEAgMbaLhA02h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cb96ec476fb4914445c9@syzkaller.appspotmail.com,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 030/403] comedi: Fix use of uninitialized data in insn_rw_emulate_bits()
Date: Tue, 26 Aug 2025 13:05:56 +0200
Message-ID: <20250826110906.642861559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e9cb26291d009243a4478a7ffb37b3a9175bfce9 upstream.

For Comedi `INSN_READ` and `INSN_WRITE` instructions on "digital"
subdevices (subdevice types `COMEDI_SUBD_DI`, `COMEDI_SUBD_DO`, and
`COMEDI_SUBD_DIO`), it is common for the subdevice driver not to have
`insn_read` and `insn_write` handler functions, but to have an
`insn_bits` handler function for handling Comedi `INSN_BITS`
instructions.  In that case, the subdevice's `insn_read` and/or
`insn_write` function handler pointers are set to point to the
`insn_rw_emulate_bits()` function by `__comedi_device_postconfig()`.

For `INSN_WRITE`, `insn_rw_emulate_bits()` currently assumes that the
supplied `data[0]` value is a valid copy from user memory.  It will at
least exist because `do_insnlist_ioctl()` and `do_insn_ioctl()` in
"comedi_fops.c" ensure at lease `MIN_SAMPLES` (16) elements are
allocated.  However, if `insn->n` is 0 (which is allowable for
`INSN_READ` and `INSN_WRITE` instructions, then `data[0]` may contain
uninitialized data, and certainly contains invalid data, possibly from a
different instruction in the array of instructions handled by
`do_insnlist_ioctl()`.  This will result in an incorrect value being
written to the digital output channel (or to the digital input/output
channel if configured as an output), and may be reflected in the
internal saved state of the channel.

Fix it by returning 0 early if `insn->n` is 0, before reaching the code
that accesses `data[0]`.  Previously, the function always returned 1 on
success, but it is supposed to be the number of data samples actually
read or written up to `insn->n`, which is 0 in this case.

Reported-by: syzbot+cb96ec476fb4914445c9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cb96ec476fb4914445c9
Fixes: ed9eccbe8970 ("Staging: add comedi core")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250707153355.82474-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -615,6 +615,9 @@ static int insn_rw_emulate_bits(struct c
 	unsigned int _data[2];
 	int ret;
 
+	if (insn->n == 0)
+		return 0;
+
 	memset(_data, 0, sizeof(_data));
 	memset(&_insn, 0, sizeof(_insn));
 	_insn.insn = INSN_BITS;


