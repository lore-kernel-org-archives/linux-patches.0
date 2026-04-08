Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902743AD52A;
	Wed,  8 Apr 2026 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674840; cv=none; b=iOFc6IJ149gSGNiHemt2w3XBiIfuDb/epyoQY25gR7BgDVdl2Joq6wrEl3q6/sgQI/tZA86GrffHQbfvWYrY2gCg/JD2kqnu6UuEDB3mxm33jZFd+wNZeC8F7ytH4of9RhESoFRq86jr9oYDn5au9xL7ncDeavsdJ//kNnaewac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674840; c=relaxed/simple;
	bh=UVbfGFqAdlC9EhrEgYhgd7yzbKHR57L5SXd1p7wb9Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwOPhIbGqBHWrMfKJISnN2mvwjBtFqfz93yWCDhhgEiFVwuNzISpsTdnYTfVvmblICPRSbBWuxmb2+yzq76DyoRlzbxjMS0jC3+5A/ecuDipkXGYbdveIcUsLvODyA/xeTV9o6Y5/+h4b5zcpQo3fa/O4cBCuWM6SrsGc8wldTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCPO4RdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCPO4RdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24675C19421;
	Wed,  8 Apr 2026 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674840;
	bh=UVbfGFqAdlC9EhrEgYhgd7yzbKHR57L5SXd1p7wb9Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCPO4RdXQVJSx0Ne1TuNycouw2ZTlMUh5fEFdrPGMhMTMos5GwqEObDJVfYT2uIDE
	 HQeC9ft5+71CcN4gI6DSa+U/Iohg/DKKEj5pYbUY3Zmw1avXDo/VdlA6V6e9b4O3aj
	 2EDwh4/P6kA7o3ZyfEo8syL1YADggSjs88W4ucy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f238baf6ded841b5a82e@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 254/311] comedi: runflags cannot determine whether to reclaim chanlist
Date: Wed,  8 Apr 2026 20:04:14 +0200
Message-ID: <20260408175948.872427477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 29f644f14b89e6c4965e3c89251929e451190a66 upstream.

syzbot reported a memory leak [1], because commit 4e1da516debb ("comedi:
Add reference counting for Comedi command handling") did not consider
the exceptional exit case in do_cmd_ioctl() where runflags is not set.
This caused chanlist not to be properly freed by do_become_nonbusy(),
as it only frees chanlist when runflags is correctly set.

Added a check in do_become_nonbusy() for the case where runflags is not
set, to properly free the chanlist memory.

[1]
BUG: memory leak
  backtrace (crc 844a0efa):
    __comedi_get_user_chanlist drivers/comedi/comedi_fops.c:1815 [inline]
    do_cmd_ioctl.part.0+0x112/0x350 drivers/comedi/comedi_fops.c:1890
    do_cmd_ioctl drivers/comedi/comedi_fops.c:1858 [inline]

Fixes: 4e1da516debb ("comedi: Add reference counting for Comedi command handling")
Reported-by: syzbot+f238baf6ded841b5a82e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f238baf6ded841b5a82e
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Cc: stable <stable@kernel.org> # 6.19
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260310111104.70959-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index 48a8a607a84c..0df9f4636fb6 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -793,13 +793,15 @@ static void do_become_nonbusy(struct comedi_device *dev,
 	__comedi_clear_subdevice_runflags(s, COMEDI_SRF_RUNNING |
 					     COMEDI_SRF_BUSY);
 	spin_unlock_irqrestore(&s->spin_lock, flags);
-	if (comedi_is_runflags_busy(runflags)) {
+	if (async) {
 		/*
 		 * "Run active" counter was set to 1 when setting up the
 		 * command.  Decrement it and wait for it to become 0.
 		 */
-		comedi_put_is_subdevice_running(s);
-		wait_for_completion(&async->run_complete);
+		if (comedi_is_runflags_busy(runflags)) {
+			comedi_put_is_subdevice_running(s);
+			wait_for_completion(&async->run_complete);
+		}
 		comedi_buf_reset(s);
 		async->inttrig = NULL;
 		kfree(async->cmd.chanlist);
-- 
2.53.0



