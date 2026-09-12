Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982F83F20E8;
	Sat, 12 Sep 2026 10:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207619; cv=none; b=sjm5L0kQP3tG0ybJUnFKmVDcRE+oKMj7CrgeZFQAx+0hRM8SExajnMdzGcUbmcW8/0bcnjZ03zyxWmly8E9wivFH7ZhrPnfbGM26Xn4Ob50CFLzDYmcz+0QKwP4VaDF9fxnNWxxvVbh0AyCUSS94Uc5sRacchpHOiWiE2UG7HzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207619; c=relaxed/simple;
	bh=X3Z9qLUi41fekDWX6uMjaUPZw3Ppx7JbVi0UjYoGNOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxSdH+ITlbNgmE/01oZw1AQLMvU5gMv4qBGT4DEX8adFLzmigvI0xU97WEs8DEqhi2L+Etz2cTdLoVdKzwHVGB++8GfMHubijs5wUHuqP44aRGO6uIEDKyzJuYeyAUw3tpSnaUEyeyl8xO+A4EJtDG+l3QmpFbFWfUNUxNHGa50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYI0UbXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYI0UbXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7E71F000FF;
	Sat, 12 Sep 2026 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207617;
	bh=JQwEEcchfRcuZtOFCRv0wnt++KDZxzAFGNrVJ10hWfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYI0UbXwxIvBi3kD/2ByPbI8E/Um8x+1JIhuoSMknpWRJsFtTXiiR/JLa4xF1230U
	 ieA9TRrN6xDHdD8vcHyRRp2rNn/7dUCwKUm5Im4xgZHCkooZxYm5ds32wWANZs+smB
	 KxsGU6z4j7MTdv0JAy1L4wdbN1DC0TAc/gsKKOzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0448/1518] gpib: Move stuck SRQ update under lock
Date: Sat, 12 Sep 2026 08:43:37 +0200
Message-ID: <20260912065633.584618828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 7ddb521ab097413fbdff483b53b4a8c73a0e2b40 ]

Move the stuck SRQ state update into autopoll_all_devices() and keep it
under big_gpib_mutex. Except for initialization, keep the stuck_srq users
under this mutex.

autopoll_all_devices() is only called by autospoll_thread(), so there is
no need to return to autospoll_thread() and set this state after dropping
big_gpib_mutex.

Without the mutex, a newly opened device can clear stuck_srq and have
that clear overwritten by the previous autospoll result:

  autospoll: serial_poll_all() returns 0 and unlocks big_gpib_mutex
  open_dev_ioctl: open new device and clear stuck_srq
                  with big_gpib_mutex held
  autospoll: set stuck_srq

That leaves the board marked stuck again after the new device is opened.
autospoll_wait_should_wake_up() then refuses to poll while stuck_srq is
set, so later SRQ handling can be mistakenly suppressed.

Without the mutex, atomic_set() and set_bit() only make individual
updates atomic. They do not order the two updates or make stuck_srq and
status visible as a consistent pair. Taking big_gpib_mutex serializes the
state transition with the other runtime users.

Keep the existing wakeup behavior unchanged and only move the stuck SRQ
state update under the mutex.

Fixes: 9dde4559e939 ("staging: gpib: Add GPIB common core driver")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260522073447.4117690-1-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/gpib_os.c | 21 +++++++++++----------
 drivers/staging/gpib/common/iblib.c   |  3 ---
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/gpib/common/gpib_os.c b/drivers/staging/gpib/common/gpib_os.c
index a2bed6bd757a0..b223bd23a8422 100644
--- a/drivers/staging/gpib/common/gpib_os.c
+++ b/drivers/staging/gpib/common/gpib_os.c
@@ -289,18 +289,19 @@ int autopoll_all_devices(struct gpib_board *board)
 	dev_dbg(board->gpib_dev, "autopoll has board lock\n");
 
 	retval = serial_poll_all(board, serial_timeout);
-	if (retval < 0)	{
-		mutex_unlock(&board->big_gpib_mutex);
-		mutex_unlock(&board->user_mutex);
-		return retval;
+	if (retval >= 0) {
+		dev_dbg(board->gpib_dev, "complete\n");
+		/*
+		 * need to wake wait queue in case someone is
+		 * waiting on RQS
+		 */
+		wake_up_interruptible(&board->wait);
 	}
 
-	dev_dbg(board->gpib_dev, "complete\n");
-	/*
-	 * need to wake wait queue in case someone is
-	 * waiting on RQS
-	 */
-	wake_up_interruptible(&board->wait);
+	if (retval <= 0) {
+		atomic_set(&board->stuck_srq, 1);
+		set_bit(SRQI_NUM, &board->status);
+	}
 	mutex_unlock(&board->big_gpib_mutex);
 	mutex_unlock(&board->user_mutex);
 
diff --git a/drivers/staging/gpib/common/iblib.c b/drivers/staging/gpib/common/iblib.c
index b672dd6aad25f..511e1d61c1fb2 100644
--- a/drivers/staging/gpib/common/iblib.c
+++ b/drivers/staging/gpib/common/iblib.c
@@ -193,9 +193,6 @@ static int autospoll_thread(void *board_void)
 		}
 		if (retval <= 0) {
 			dev_err(board->gpib_dev, "stuck SRQ\n");
-
-			atomic_set(&board->stuck_srq, 1);	// XXX could be better
-			set_bit(SRQI_NUM, &board->status);
 		}
 	}
 	return retval;
-- 
2.53.0



