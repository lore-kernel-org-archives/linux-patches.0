Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3118B2BE7CD;
	Fri,  9 Oct 2026 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555998; cv=none; b=Bns59RoD8YbYfqluKnSc+L+8HkJkcOvVuFywYCd7d0altL4H0s8ugg4MLXayK00s5ZF1DtC/SP4t4FgPI7JQ6O4tVB7Pa1tE4GVrHO9d+BYsO/s/esjKYCaAFfLijVDXXEmwr0M+ytyFmxpxQonBmocDgdckhJxvXAe6egkJU1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555998; c=relaxed/simple;
	bh=SSA/r8HT3XVGNLFWw7XWzt5holxw5QnuaMMpUmyF/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOOwoZRvtVT4L2yUVY7GY/Lh9BFeB4coATwHrEiGXB0JmR6jKkGqNF2VZEn3EiCt4/9q4br/Au18IWqdE3IV8eurC90uvQUfE7PPK3vzDm6m7VeEH2X3yD1Kc48FHbjnmLE/X51kSteb/HbKDpY4f5D8ZyfGvQMCmqRdUaA16ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dek7+iG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dek7+iG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA861F000FF;
	Fri,  9 Oct 2026 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555997;
	bh=I6+/MaFUwfLZ3VAv5Z6TlMkzDrOmbaxmf5KodJIWC58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dek7+iGw4k9GbVjhQD/P7HKDxbQS0NwJQd4pGMeWqQ/dBEndObKBdHoTe7lBa5Q5
	 zYvcwPA9o+7VQOHOGZY67S2UNzwMZ54knH68/RiPt/CkfRJj0PPES/C/F3U43EW+T8
	 r8WeEdyUGDyuNETc9GL1szyJqoPzZ/2uN4ucOwOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hui Peng <benquike@gmail.com>
Subject: [PATCH 7.2 059/428] vt: selection: Fix unsigned underflow and slab-out-of-bounds read in paste_selection()
Date: Fri,  9 Oct 2026 16:06:36 +0200
Message-ID: <20261009140947.435897471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit 39495ef5d6f8019e62d65807f217a7ca8232727a upstream.

In paste_selection(), the loop copies min_t(unsigned int,
vc_sel.buf_len - pasted,tty->receive_room) bytes per iteration into
tty_ldisc_receive_buf() and increments pasted += count.

Because the selection mutex (vc_sel.lock) is dropped inside the loop
Whenever the line discipline buffer fills up and paste_selection()
sleeps on tty->write_wait, a concurrent TIOCLINUX (TIOCL_SETSEL) ioctl
can replace vc_sel.buffer with a shorter selection and reduce
vc_sel.buf_len below pasted.

When paste_selection() resumes, vc_sel.buf_len - pasted underflows as an
unsigned integer to a large positive value, causing
tty_ldisc_receive_buf(ld, vc_sel.buffer + pasted, NULL, count) to read
up to 4094 bytes out-of-bounds past the newly allocated vc_sel.buffer.

Fix this by terminating the loop when pasted >= vc_sel.buf_len.

Kernel stack trace (Linux 7.3.0-rc3):
 ==================================================================
 BUG: KASAN: slab-out-of-bounds in n_tty_receive_buf_common+0xa01/0x1650
 Read of size 4094 at addr ffff888101c58010 by task kworker/u17:1/65
 Workqueue: events_unbound flush_to_ldisc
 Call Trace:
  <TASK>
  dump_stack_lvl+0x70/0xa0
  print_report+0x153/0x4c6
  kasan_report+0xf1/0x120
  kasan_check_range+0x11c/0x200
  __asan_memcpy+0x29/0x70
  n_tty_receive_buf_common+0xa01/0x1650
  tty_ldisc_receive_buf+0x66/0x110
  tty_port_default_receive_buf+0x6b/0xb0
  flush_to_ldisc+0x1b4/0x410
  process_one_work+0x6ff/0x1110
  worker_thread+0x4a8/0xb70
  kthread+0x307/0x3e0
  ret_from_fork+0x3ed/0x680
  </TASK>
 ==================================================================

Fixes: e8c75a30a23c ("vt: selection, push sel_lock up")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
Link: https://patch.msgid.link/20260919110041.3763078-1-benquike@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/selection.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -434,8 +434,8 @@ int paste_selection(struct tty_struct *t
 			bps = NULL;
 		}
 
-		count = vc_sel.buf_len - pasted;
-		if (count) {
+		if (vc_sel.buf_len > pasted) {
+			count = vc_sel.buf_len - pasted;
 			pasted += tty_ldisc_receive_buf(ld, vc_sel.buffer + pasted,
 							NULL, count);
 			if (vc_sel.buf_len > pasted)


