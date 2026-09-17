Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFA3A0E99;
	Thu, 17 Sep 2026 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660016; cv=none; b=cyQTOILrsk/XQ50dcrQUMDc3ZUbsQ6BfzDZIpMmhaKsBZHe6XK6H0StpkYFp29Q/pYmrZjNiTREkVOU+Mrutc3tU34oV9KoXCzt8nhPhOXYVUxvlCunIv3OuUjTbfG7DeoN11FJG/bGB/YQY0rIHKj+S2wCyNVdBJl/tqagOXl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660016; c=relaxed/simple;
	bh=O8L3HGI62ute0PDjRd7egJ5pq5pYkoXbu8czcvY5Rxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+6efkRzG/CYU8W1cP5fYzBg6pg3+d0ZN8cC2F5KkBi7+hxKF5JxKTtJKYxBtXpVMm5fBX5CfR8tbJzr5TL7ljLgnbSNxktfn9ojOk+dJOaCwom/0Xb90Nva0+HDPGpOcGu8nDgLtOUwU25Mb5T5081hhFqRofVjGbGNnDqvTxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xx68Vfb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xx68Vfb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681F21F0089A;
	Thu, 17 Sep 2026 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660009;
	bh=7UBD/yfX9FEKhAYvF4R6vPpvtwyPF5SMHAj6SsLQTaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xx68Vfb/hDFgHCQV1bP/uC1X03w+OMtVI5HmcmGqj03+2TKci0RU71yzJ7J4ICE71
	 Ae3r7LRhc7OSiKXwfJipcnlSZsO4+WdrQnMJNRw7246vSQ2+CD3mbpzSfcVJMpwSqf
	 vXX7f5LHykjKSXqx8J32te3SsEC7Yl+10ucd0DGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 447/733] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Thu, 17 Sep 2026 16:12:35 +0100
Message-ID: <20260917151403.030157155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit d5869dae5080e976d4b03cc33eb7ceb527f242bf ]

When a LUN_RESET aborts a WRITE command that is in the
TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and
waits for the frontend to finish processing.

If the initiator subsequently sends the remaining dataout PDUs,
__iscsit_check_dataout_hdr() catches the payload, stops the dataout
timer if the sequence is final and finally dumps the data.  However, the
iSCSI target doesn't trigger the completion process for these aborted
commands. Because of this, the abort path hangs indefinitely in
target_put_cmd_and_wait(), leading to a deadlocked target worker thread.

Fix this by explicitly calling target_complete_cmd() when the final
dataout PDU is received for an aborted WRITE command.
target_complete_cmd() detects the CMD_T_ABORTED flag and cleanly routes
the command into target_abort_work, allowing the abort completion to
successfully unblock.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20260717143828.76291-2-mlombard@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 62ada3a52210e..124ff269b8e75 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1533,8 +1533,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
+			    --cmd->outstanding_r2ts < 1) {
 				iscsit_stop_dataout_timer(cmd);
+				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
+			}
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
-- 
2.53.0



