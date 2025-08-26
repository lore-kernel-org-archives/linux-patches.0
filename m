Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB39622DFA7;
	Tue, 26 Aug 2025 13:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215286; cv=none; b=A0ufK3DVjZdjaCmyA6oYGLFgUy80+ZYuPm5rPqB7ybS9ksBmSqTJpBUDSJv87uvMGLq2fNdRMtit9D2lxlttejLQdsKdw0w/oSYdyJahf/KWPfCL0Xt+g9cDB5Mk/TiYqgV7fkqZq9bC0XW0Y3vaJ9+LCLFz9niqIeSdH8uKUPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215286; c=relaxed/simple;
	bh=XUiNpvcKyB24DvKtEtWeodRIdjz3XuyjRQFaYmbNF6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlGlAwHxZ0tlNPRmJ5FVTwxNKw5gUrpN3V9lVmFiIFamkO+qXMqm6NTZSQmDKGrIN+2JErlSYG77nMt7WbArrTWJEPJv2cuaACWlcoqcLGBKTMqH/QyNTaGPnuFuXaWUQNeIyVC1F/iK2qX4nbIDFC7LUaYrt5eG7XFU+Qr+EdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+fcMTFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+fcMTFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557A9C4CEF1;
	Tue, 26 Aug 2025 13:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215286;
	bh=XUiNpvcKyB24DvKtEtWeodRIdjz3XuyjRQFaYmbNF6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+fcMTFlbQWr53PnD5d6wTKoeHSVExHSBk45Ne+V026nHpiw0mY/fDr9YxnuWe6Dm
	 vXiPEPxmKIdaGnZR2M6zYSp0W4ivO4Qkblxzd7LOjKeO1YtatqJkn0kEcdbqN/KlIg
	 0NeDiuUcPyR967GGPoDForYa0o0rYAGPMz+bUBZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a5e45f768aab5892da5d@syzkaller.appspotmail.com,
	syzbot+fb4362a104d45ab09cf9@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 416/482] comedi: Fix use of uninitialized memory in do_insn_ioctl() and do_insnlist_ioctl()
Date: Tue, 26 Aug 2025 13:11:09 +0200
Message-ID: <20250826110941.105961194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 3cd212e895ca2d58963fdc6422502b10dd3966bb upstream.

syzbot reports a KMSAN kernel-infoleak in `do_insn_ioctl()`.  A kernel
buffer is allocated to hold `insn->n` samples (each of which is an
`unsigned int`).  For some instruction types, `insn->n` samples are
copied back to user-space, unless an error code is being returned.  The
problem is that not all the instruction handlers that need to return
data to userspace fill in the whole `insn->n` samples, so that there is
an information leak.  There is a similar syzbot report for
`do_insnlist_ioctl()`, although it does not have a reproducer for it at
the time of writing.

One culprit is `insn_rw_emulate_bits()` which is used as the handler for
`INSN_READ` or `INSN_WRITE` instructions for subdevices that do not have
a specific handler for that instruction, but do have an `INSN_BITS`
handler.  For `INSN_READ` it only fills in at most 1 sample, so if
`insn->n` is greater than 1, the remaining `insn->n - 1` samples copied
to userspace will be uninitialized kernel data.

Another culprit is `vm80xx_ai_insn_read()` in the "vm80xx" driver.  It
never returns an error, even if it fails to fill the buffer.

Fix it in `do_insn_ioctl()` and `do_insnlist_ioctl()` by making sure
that uninitialized parts of the allocated buffer are zeroed before
handling each instruction.

Thanks to Arnaud Lecomte for their fix to `do_insn_ioctl()`.  That fix
replaced the call to `kmalloc_array()` with `kcalloc()`, but it is not
always necessary to clear the whole buffer.

Fixes: ed9eccbe8970 ("Staging: add comedi core")
Reported-by: syzbot+a5e45f768aab5892da5d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a5e45f768aab5892da5d
Reported-by: syzbot+fb4362a104d45ab09cf9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fb4362a104d45ab09cf9
Cc: stable <stable@kernel.org> # 5.13+
Cc: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250725125324.80276-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -1582,6 +1582,9 @@ static int do_insnlist_ioctl(struct come
 				memset(&data[n], 0, (MIN_SAMPLES - n) *
 						    sizeof(unsigned int));
 			}
+		} else {
+			memset(data, 0, max_t(unsigned int, n, MIN_SAMPLES) *
+					sizeof(unsigned int));
 		}
 		ret = parse_insn(dev, insns + i, data, file);
 		if (ret < 0)
@@ -1665,6 +1668,8 @@ static int do_insn_ioctl(struct comedi_d
 			memset(&data[insn->n], 0,
 			       (MIN_SAMPLES - insn->n) * sizeof(unsigned int));
 		}
+	} else {
+		memset(data, 0, n_data * sizeof(unsigned int));
 	}
 	ret = parse_insn(dev, insn, data, file);
 	if (ret < 0)


