Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8186450B8B1;
	Wed, 30 Sep 2026 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783332; cv=none; b=rOLetGHb8USdeFsaLmPsTgQ/yndfTTjoCkGfkikHkPBDOpVTEgVIJMiwa1NYdhiey0PSiplwd8A4XQYIUAotg+3l6O3drcfCuG7XfpUQCJG87jdDX8JQS0hU7aVoJDGtc8kCVKp/4h8uzNq/BrZkWB7AmiyYWfXlQTGcp43PNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783332; c=relaxed/simple;
	bh=BQ1UphbrQWbfhI9RWvsh+aw3e9zfnxZcNVgdQV0Jwjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gt18BjReqamYQ+nMIZLzbzwth0ICL7Ndel9mDjc8pEyEHKZYcPkZF/gaawFLVglqmi1A/xxfGVbY1yXTAM5EeywxJcpJjEE67Y5hZHVieuuc2AUfWBEKgr6g8d7a4eZIlTLICZSqv3ju0iP1mE2kCaAkFF+4a4QHHVCA1/fyJFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhwsTA7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhwsTA7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084AE1F00893;
	Wed, 30 Sep 2026 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783327;
	bh=GnozS9ibdy7+aWE8UoPlqK3Nfaj/KH6n5P+sfWNp+0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhwsTA7Y06tPHndYauEsunrjopLC+r3HipxELwmXYETH/n/NeNX31+dFRcpekWmgt
	 vOWTnSO+KmXcvwUeflsVssuibCNjFJ9tT4m4jnlFrM6E9wbC2Dahud9D1zg4fbz2rr
	 dXBxJn1JYLLYN9RdPtqds+RT9WOtK5mNQktx5zi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/595] scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_close_session()
Date: Wed, 30 Sep 2026 17:24:14 +0200
Message-ID: <20260930152355.442247587@linuxfoundation.org>
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

[ Upstream commit 433675486af4635416f8ece70b92b020a5b91005 ]

iscsit_close_session() uses in_interrupt() to decide if it needs to check
the return value of iscsit_check_session_usage_count() if it was not able
to sleep.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

iscsit_close_session() has two callers:

 - iscsit_handle_time2retain_timeout()
   A timer_list callback.

 - iscsit_close_connection()
   Runs in preemptible context, acquires a mutex.

Add an argument to iscsit_close_session() indicating if sleeping is
possible.

Link: https://lore.kernel.org/r/20201220203638.43615-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: a8fe3dfce8c0 ("IB/isert: wait for deferred control PDU completions before releasing the connection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c      | 10 +++++-----
 drivers/target/iscsi/iscsi_target.h      |  2 +-
 drivers/target/iscsi/iscsi_target_erl0.c |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e2ba02c27b5e5..76c2b6b97dd9a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4343,7 +4343,7 @@ int iscsit_close_connection(
 	     atomic_read(&sess->session_fall_back_to_erl0)) {
 		spin_unlock_bh(&sess->conn_lock);
 		complete_all(&sess->session_wait_comp);
-		iscsit_close_session(sess);
+		iscsit_close_session(sess, true);
 
 		return 0;
 	} else if (atomic_read(&sess->session_logout)) {
@@ -4353,7 +4353,7 @@ int iscsit_close_connection(
 		if (atomic_read(&sess->session_close)) {
 			spin_unlock_bh(&sess->conn_lock);
 			complete_all(&sess->session_wait_comp);
-			iscsit_close_session(sess);
+			iscsit_close_session(sess, true);
 		} else {
 			spin_unlock_bh(&sess->conn_lock);
 		}
@@ -4369,7 +4369,7 @@ int iscsit_close_connection(
 		if (atomic_read(&sess->session_close)) {
 			spin_unlock_bh(&sess->conn_lock);
 			complete_all(&sess->session_wait_comp);
-			iscsit_close_session(sess);
+			iscsit_close_session(sess, true);
 		} else {
 			spin_unlock_bh(&sess->conn_lock);
 		}
@@ -4382,7 +4382,7 @@ int iscsit_close_connection(
  * If the iSCSI Session for the iSCSI Initiator Node exists,
  * forcefully shutdown the iSCSI NEXUS.
  */
-int iscsit_close_session(struct iscsi_session *sess)
+int iscsit_close_session(struct iscsi_session *sess, bool can_sleep)
 {
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
@@ -4418,7 +4418,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	 * time2retain handler) and contain and active session usage count we
 	 * restart the timer and exit.
 	 */
-	if (!in_interrupt()) {
+	if (can_sleep) {
 		iscsit_check_session_usage_count(sess);
 	} else {
 		if (iscsit_check_session_usage_count(sess) == 2) {
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index 7409ce2a66078..b35a96ded9c19 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -41,7 +41,7 @@ extern void iscsit_thread_get_cpumask(struct iscsi_conn *);
 extern int iscsi_target_tx_thread(void *);
 extern int iscsi_target_rx_thread(void *);
 extern int iscsit_close_connection(struct iscsi_conn *);
-extern int iscsit_close_session(struct iscsi_session *);
+extern int iscsit_close_session(struct iscsi_session *, bool can_sleep);
 extern void iscsit_fail_session(struct iscsi_session *);
 extern void iscsit_stop_session(struct iscsi_session *, int, int);
 extern int iscsit_release_sessions_for_tpg(struct iscsi_portal_group *, int);
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index b4abd7b68e6da..102c9cbf59f38 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -765,7 +765,7 @@ void iscsit_handle_time2retain_timeout(struct timer_list *t)
 
 	iscsit_fill_cxn_timeout_err_stats(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
-	iscsit_close_session(sess);
+	iscsit_close_session(sess, false);
 }
 
 void iscsit_start_time2retain_handler(struct iscsi_session *sess)
-- 
2.53.0



