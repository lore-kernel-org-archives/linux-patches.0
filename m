Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF3455626;
	Sat, 12 Sep 2026 12:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216727; cv=none; b=NCziwxmpwphQWCOO6qPi8FLKC7PGWV4y0M6DY+FTfIGMDJbyJZh6ucMfqanAzuzWB9uf7NdLhEJ7oe3Yt9KeFO8c0sm97yMajxAm6UgP1z3KM5+6fAwjsNg9UxrEjuvRKeaLyMlQhkVJEA5O02Gvd+FAxMoQHJG6AS0+EiaA2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216727; c=relaxed/simple;
	bh=WlLjT0IRpEchTEzX/Xj4IJaMn8awrPW5sTVRv0vCCuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axJ08FpgJK0W3vMfmVc03B3Sq+sCuZgzz3J6372kzMy0sRw5QMkdfVXPQxiJdvWbFdkhPc2GEr8WiNYMbGakypJVp8V1AbnGoWUIqvuNcu6dtlp+F5YW0iJ+o8JJacm1qXSadX1wMWUyKl0FNmpmUzURSe9O5H59k1yux8IeVd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hCKi6c4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hCKi6c4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35BC1F000FF;
	Sat, 12 Sep 2026 12:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216725;
	bh=EpGfHFsK4AWcVOttOH6DhHiIlwyruummvadQ1Uj2vrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hCKi6c4UcgiE3JS5pCNeLHy8vvrgDWyAg4XXaDrRK6jN4HZ+nNqDGh67ubcfULX7
	 R9hU+nMV32XeGalyRqDwvm2/NK5nLPogO0sz4Z/Vqp8O5FPwzqtc2FB1TKgkdPAgwL
	 ttkmWKejdvqYdBXJu5+O+4YXoBvEZwoNI2Mn67RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0788/1376] i3c: dw: avoid shift-out-of-bounds when DAA assigns no devices
Date: Sat, 12 Sep 2026 08:53:34 +0200
Message-ID: <20260912065625.100416501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 038cf48b3170af26a70bf2dee4f8c3ac910f5176 ]

On an empty bus ENTDAA assigns nothing, so cmd->rx_len (the count
of addresses left unassigned) equals master->maxdevs.

The GENMASK() index master->maxdevs - cmd->rx_len - 1 then becomes -1,
which trips up UBSAN. This happens every time on boot on a Gigabyte/AMD
server:

    UBSAN: shift-out-of-bounds in drivers/i3c/master/dw-i3c-master.c:905:12
    shift exponent 64 is too large for 64-bit type 'long unsigned int'
    CPU: 7 UID: 0 PID: 963 Comm: (udev-worker) Not tainted 7.0.11-200.fc44.x86_64 #1 PREEMPT(lazy)
    Hardware name: Giga Computing E163-Z34-AAH1-000/MZ33-DC1-000, BIOS R32_F45 04/01/2026
    Call Trace:
     <TASK>
     dump_stack_lvl+0x5d/0x80
     ubsan_epilogue+0x5/0x2b
     __ubsan_handle_shift_out_of_bounds.cold+0xd7/0x1ab
     dw_i3c_master_daa.cold+0x1b/0x96 [dw_i3c_master]
     i3c_master_do_daa_ext.part.0+0x3e/0xf0 [i3c]

Skip the mask when no new device was assigned.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260630172904.2662160-1-kuba@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index a60eb86bddba8..c68637ddd05e9 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -889,7 +889,15 @@ static int dw_i3c_master_daa(struct i3c_master_controller *m)
 	if (!wait_for_completion_timeout(&xfer->comp, XFER_TIMEOUT))
 		dw_i3c_master_dequeue_xfer(master, xfer);
 
-	newdevs = GENMASK(master->maxdevs - cmd->rx_len - 1, 0);
+	/*
+	 * cmd->rx_len holds the number of addresses ENTDAA left unassigned.
+	 * On an empty bus rx_len == maxdevs, so avoid GENMASK(-1, 0).
+	 */
+	if (cmd->rx_len >= master->maxdevs)
+		newdevs = 0;
+	else
+		newdevs = GENMASK(master->maxdevs - cmd->rx_len - 1, 0);
+
 	newdevs &= ~olddevs;
 
 	for (pos = 0; pos < master->maxdevs; pos++) {
-- 
2.53.0



