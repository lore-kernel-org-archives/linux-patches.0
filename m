Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF8450C2B4;
	Wed, 30 Sep 2026 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783336; cv=none; b=UWl8xc48UA52KwW0awxDsygaQH/MAzsotr/5/tdFAEroDydcy0HHtFOxYRtfwbCmN+ej2z9SGCKGEV0HFKJQJEq/FApaflDrvG3r4AyHkeEcj0qaYr5zcf4w3VPQ3VvM+i3cYpxzjWHKGfhyUamtW73uLp49PLC/ZRX4ldVk7g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783336; c=relaxed/simple;
	bh=OssBN9uLEInCrtJfkG6N+d5TwDYO4/IPSJNas13dOBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTzDi1+2sRL27vZGDsIazLttUPr4AVPE9GwfMqCFqeFQkzapEYtR621/JFrmBd54r1EiZsJhfG/ijgQtpKkwUp3L3YrowewFBCepIWsYUBPZGu46SVCnBGKmMbMRli8nNd5wraQ1vXPTErO1vfCXyv2fkY2k5fmczuVoIi9coIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScCz5VF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScCz5VF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE05A1F0089E;
	Wed, 30 Sep 2026 15:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783330;
	bh=/sotIPbtfE/Dj7+oAo7lxQ84Jc9oD15n1uc+rwWAsHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScCz5VF0glOJGVAzwwBGdSGe2TDlfxNb7BkNZzFTMH4Ao41nutIT0hnimgjY74Ggy
	 Hh4hzCk/8laAa074CWGhAO7BC/AIPwSacrAfPK1bfjfJwXDxocpdMCHABdVmsugQOD
	 EnvWn0RO7Xbmes1/WuLqB4KLGqJItQm7263TYL0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/595] scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_check_session_usage_count()
Date: Wed, 30 Sep 2026 17:24:15 +0200
Message-ID: <20260930152355.462540147@linuxfoundation.org>
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

[ Upstream commit efc9d73063c15f1aba8920b9f9ceaba4f3fb8ed9 ]

iscsit_check_session_usage_count() uses in_interrupt() to find out if it is
safe to invoke wait_for_completion().

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

There is only one caller of iscsit_check_session_usage_count() which
already has an argument indicating if it is safe to sleep.

Extend iscsit_check_session_usage_count() by an argument indicating if it
may sleep.

Link: https://lore.kernel.org/r/20201220203638.43615-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: a8fe3dfce8c0 ("IB/isert: wait for deferred control PDU completions before releasing the connection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c      | 4 ++--
 drivers/target/iscsi/iscsi_target_util.c | 4 ++--
 drivers/target/iscsi/iscsi_target_util.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 76c2b6b97dd9a..9db86c956ea2d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4419,9 +4419,9 @@ int iscsit_close_session(struct iscsi_session *sess, bool can_sleep)
 	 * restart the timer and exit.
 	 */
 	if (can_sleep) {
-		iscsit_check_session_usage_count(sess);
+		iscsit_check_session_usage_count(sess, can_sleep);
 	} else {
-		if (iscsit_check_session_usage_count(sess) == 2) {
+		if (iscsit_check_session_usage_count(sess, can_sleep) == 2) {
 			atomic_set(&sess->session_logout, 0);
 			iscsit_start_time2retain_handler(sess);
 			return 0;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index f81cbfe760fa5..338cf861f1b16 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -779,13 +779,13 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 }
 EXPORT_SYMBOL(iscsit_free_cmd);
 
-int iscsit_check_session_usage_count(struct iscsi_session *sess)
+int iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_sleep)
 {
 	spin_lock_bh(&sess->session_usage_lock);
 	if (sess->session_usage_count != 0) {
 		sess->session_waiting_on_uc = 1;
 		spin_unlock_bh(&sess->session_usage_lock);
-		if (in_interrupt())
+		if (!can_sleep)
 			return 2;
 
 		wait_for_completion(&sess->session_waiting_on_uc_comp);
diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
index 68e84803b0a1a..a2c2401f29452 100644
--- a/drivers/target/iscsi/iscsi_target_util.h
+++ b/drivers/target/iscsi/iscsi_target_util.h
@@ -40,7 +40,7 @@ extern void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *);
 extern void iscsit_release_cmd(struct iscsi_cmd *);
 extern void __iscsit_free_cmd(struct iscsi_cmd *, bool);
 extern void iscsit_free_cmd(struct iscsi_cmd *, bool);
-extern int iscsit_check_session_usage_count(struct iscsi_session *);
+extern int iscsit_check_session_usage_count(struct iscsi_session *sess, bool can_sleep);
 extern void iscsit_dec_session_usage_count(struct iscsi_session *);
 extern void iscsit_inc_session_usage_count(struct iscsi_session *);
 extern struct iscsi_conn *iscsit_get_conn_from_cid(struct iscsi_session *, u16);
-- 
2.53.0



