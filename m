Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04D754706B;
	Thu, 17 Sep 2026 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670936; cv=none; b=HwCf/UW19SMX0db2rQf6lWJZ9lSVhJRWtmWyOWSUMSqUvjerEAEniE1CgyGLYvRuwS0ee+9EY3oVHAV3Gk6e+YpKa5ut8nwW/011iy1IvqAmbCTRGpPRO5jf+NEEqjJZQUg8EBnXwSUnJwJYwD5dOWyxK8IdBP0xcKvZujvuPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670936; c=relaxed/simple;
	bh=CM63sEQwL+DL+5gdoQZEuDK1+AyspMU1SrKkOK22iUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+tOPnYDXpk5q22CQP+BDMu7PWE/q/G0WQFnGeGtbN+pw3RSHuf+U44WAzmzJpM87Yx79X3RxLi7XRrYUsrUvfpV5uvHr+rCVV9c4t7KZoX6BvU9Yc+qy9X7SWDWqCPAVWIH1hUw3d1DuDqPrruY4Ak3+2WtWv5RvEziCYmJ2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVtjIJAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVtjIJAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3581F000FF;
	Thu, 17 Sep 2026 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670935;
	bh=8hcQ4qF+o87CB4l/M5m/klNrKF+RQ97AFC4jYXKMM9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVtjIJAt9DnoDnJrlyYsWiEY30qQ6RdICrC0ulf3i+cUGJTzmxI+aai6NnF7FPuI5
	 aCXSxEZciCa3neJ8qtTwNKFGn6WoGUfrZHtF6izanh3ZGNY2+I4mPGcJ8vncjZr3jN
	 cl2LNHwxLCZJuuPHh9y0uH7gxpneuD3bbxk3vYVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0800/1102] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Thu, 17 Sep 2026 16:12:23 +0100
Message-ID: <20260917151600.559414302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 8a7d308da991b..a23553a3d279b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1561,8 +1561,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
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



