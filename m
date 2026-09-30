Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7085850E5B3;
	Wed, 30 Sep 2026 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783340; cv=none; b=ofEOn/XufXUbMwaAgNrT6mqGAZu/YfeUo41TvoLqtEmYbTZOfpyEvXdYGr0IHntXi6fz7RZyEY4Pmms7n7ttg2tNziDcmBCtEH4TUibItitX2XV34wbIAB9WPSVMciFjM805ZyxPLzlDO0Qye8vMp8giyTfQby7FL3SyptQHM9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783340; c=relaxed/simple;
	bh=v4kij9fiAlfrRqWsD4PgnwH39lKp1nZy/7lKCuAlsbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz3NxERZOBH2qJIhZ3Spix50Q6LFBT/Eu4mH/MORNe64/t+39P32Mq2pspdR04fVOcExRnZ1rgzHAv/+vcCJ4pEYA8BROLYsWnxO6sXqq6dOE2uq8JR6kDAJFmWOob2WwgfJpCGqFVoLgZeEOo2OZsxCBD/h5wO7CDVCkZELmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsDA2vP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsDA2vP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986FD1F000FF;
	Wed, 30 Sep 2026 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783333;
	bh=4smq1zLce7QJ3RldQe3H6FcUMcapxRPyL07nFi0msfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsDA2vP6z3oIdtztlc5K6adYMxKbEEGCRfFbIkwAbjCaI549QL1+7K/JEx0LclUbx
	 u+NviE/KYLcCmtmU3MRo3OMiINDJxayiQO1CUsX609Ukjy0jwCKeSsaTu7ws566Rh/
	 qJhairnlXPWtecVncOsu/lnpNSnjV7usDkN+mpbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/595] scsi: target: iscsi: Redo iscsit_check_session_usage_count() return code
Date: Wed, 30 Sep 2026 17:24:16 +0200
Message-ID: <20260930152355.482735772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f88a10f80da9ed1ab1ba7496b70e9a0cdd8f7cf8 ]

The return value of iscsit_check_session_usage_count() is only checked if
it was not allowed to sleep. If it returns `2' then a timer is prepared. If
it returns something else or if it was allowed to sleep then it is ignored.

Let iscsit_check_session_usage_count() return true if it needs to arm the
timer - otherwise false. This simplifies the code flow of the only caller.

Link: https://lore.kernel.org/r/20201220203638.43615-4-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: a8fe3dfce8c0 ("IB/isert: wait for deferred control PDU completions before releasing the connection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c      | 12 ++++--------
 drivers/target/iscsi/iscsi_target_util.c |  9 +++++----
 drivers/target/iscsi/iscsi_target_util.h |  2 +-
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9db86c956ea2d..9ec19a50dc88c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4418,14 +4418,10 @@ int iscsit_close_session(struct iscsi_session *sess, bool can_sleep)
 	 * time2retain handler) and contain and active session usage count we
 	 * restart the timer and exit.
 	 */
-	if (can_sleep) {
-		iscsit_check_session_usage_count(sess, can_sleep);
-	} else {
-		if (iscsit_check_session_usage_count(sess, can_sleep) == 2) {
-			atomic_set(&sess->session_logout, 0);
-			iscsit_start_time2retain_handler(sess);
-			return 0;
-		}
+	if (iscsit_check_session_usage_count(sess, can_sleep)) {
+		atomic_set(&sess->session_logout, 0);
+		iscsit_start_time2retain_handler(sess);
+		return 0;
 	}
 
 	transport_deregister_session(sess->se_sess);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 338cf861f1b16..8ba70afa212e1 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -779,21 +779,22 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 }
 EXPORT_SYMBOL(iscsit_free_cmd);
 
-int iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_sleep)
+bool iscsit_check_session_usage_count(struct iscsi_session *sess,
+				      bool can_sleep)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	if (sess->session_usage_count != 0) {
 		sess->session_waiting_on_uc = 1;
 		spin_unlock_bh(&sess->session_usage_lock);
 		if (!can_sleep)
-			return 2;
+			return true;
 
 		wait_for_completion(&sess->session_waiting_on_uc_comp);
-		return 1;
+		return false;
 	}
 	spin_unlock_bh(&sess->session_usage_lock);
 
-	return 0;
+	return false;
 }
 
 void iscsit_dec_session_usage_count(struct iscsi_session *sess)
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index a2c2401f29452..8ee1c133a9b7b 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -40,7 +40,7 @@ extern void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
 extern void __iscsit_free_cmd(struct iscsi_cmd *, bool);
 extern void iscsit_free_cmd(struct iscsi_cmd *, bool);
-extern int iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_sleep);
+extern bool iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_sleep);
 extern void iscsit_dec_session_usage_count(struct iscsi_session *);
 extern void iscsit_inc_session_usage_count(struct iscsi_session *);
 extern struct iscsi_conn *iscsit_get_conn_from_cid(struct iscsi_session *, u16);
-- 
2.53.0



