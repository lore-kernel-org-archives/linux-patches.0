Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC69314B6D;
	Fri,  7 Aug 2026 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116174; cv=none; b=APQeVk2wIrQ3zpuJstzcq11yaz0gEp+zfSh2g1XlLcbLuRC5OiM9eKl81xWI38g8YVMvZjakxcddn325TA/ATafkoaU/A+BLWR/2eH0XXa+WOhgsyiWOk77Ya+BFjuGKZGabjys4rrYdqUOtrVdUGZ1KTXyuVYjsH5MqNUyM6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116174; c=relaxed/simple;
	bh=Ai6cfgCK0gC//W5Gm4zjAKpefqcDDppefsFloJ8CJfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg1uPnOxfj3tCq6ee5ZZh2ooC7R2njvGNaNhQitPL76IrTOM7s2ONuuAn+ntnNgUUX/jewq6zRHKQ85lm90WWHKp9lk+u0qOzzIJL265MYeMhJpJmmX6GVBHSQDX7ZxyqLGEXG/HZtFD7QTO+LNPVmFfTV0CBzzxshhHIANRUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzQMAFci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzQMAFci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BAA1F000E9;
	Fri,  7 Aug 2026 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116172;
	bh=1ljTEAt41lDWE/8IWLQKn6fIrUE6F9m8Gx5KUdtnEjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzQMAFciKYQMACMUZvJgg4aePJ6X2PpuSpGo05JphloEyg/WokDZS0iSBBShYgMWF
	 rLRmzV+TKNiVumHwvzE2dtc1sw36AZeSl+aNjI33RIfxyMiR6ZWfPGo5ASuCpCz0hx
	 OMb/WSFkCoYJYFLL6SbFz0U2HjxN5BTa//utWUBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 138/261] ublk: reset kernel-owned dev_info fields in ublk_ctrl_add_dev()
Date: Fri,  7 Aug 2026 16:38:15 +0200
Message-ID: <20260807143418.343056354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Ming Lei <tom.leiming@gmail.com>

commit e65848e4ce352bac9e3465099354c8b8f845391f upstream.

ublk_ctrl_add_dev() memcpy()s the userspace ublksrv_ctrl_dev_info into
ub->dev_info and then fixes up the fields the driver owns, but misses
->state and ->ublksrv_pid.

A device added with ->state = UBLK_S_DEV_LIVE passes the
"->state != UBLK_S_DEV_DEAD" test that ublk_stop_dev_unlocked() uses as its
proxy for "a disk is attached", while ->ub_disk is still NULL, so DEL_DEV
right after ADD_DEV oopses in del_gendisk().  UBLK_S_DEV_QUIESCED plus
UBLK_F_USER_RECOVERY dies one step earlier, in ublk_force_abort_dev().  A
poisoned ->state also gets START_USER_RECOVERY and the char device
read/write path onto a device that was never started, and wedges START_DEV
at -EEXIST.  A poisoned ->ublksrv_pid just makes GET_DEV_INFO report an
unrelated task as the ublk server.

Reset both after the memcpy(), as ublk_detach_disk() does.  Userspace only
ever reads these back, so correcting them silently breaks nothing.

ADD_DEV has copied ->state in unsanitized since ublk was merged, but back
then it was harmless: the gendisk was allocated during ADD_DEV, and both
teardown and the START_DEV -EEXIST check keyed off disk_live() rather than
->state.  The oops became reachable once the disk allocation moved to
START_DEV and those checks switched to ->state.

Fixes: 6d9e6dfdf3b2 ("ublk: defer disk allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://patch.msgid.link/20260726145025.1507383-1-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2438,6 +2438,15 @@ static int ublk_ctrl_add_dev(struct io_u
 	ub->dev_info.dev_id = ub->ub_number;
 
 	/*
+	 * ->state and ->ublksrv_pid are owned by the driver and only read back
+	 * by userspace, but they come from the copied-in dev_info, so reset
+	 * them. Otherwise a device added with ->state != DEAD looks live while
+	 * ->ub_disk is still NULL.
+	 */
+	ub->dev_info.state = UBLK_S_DEV_DEAD;
+	ub->dev_info.ublksrv_pid = -1;
+
+	/*
 	 * 64bit flags will be copied back to userspace as feature
 	 * negotiation result, so have to clear flags which driver
 	 * doesn't support yet, then userspace can get correct flags


