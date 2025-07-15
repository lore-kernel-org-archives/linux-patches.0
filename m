Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D972ECE9A;
	Tue, 15 Jul 2025 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587748; cv=none; b=B22jjTBmrN+wbHK1Lx07ode2BKzHEf5wSsvJytJ9ebaDOWvHv2kSbmmRQEJLWfZ0n7HyN9h4j7bsa3wFHEEuIDrkkZAzoMc9t8MoyY+FwbvNQuu7U17aEJody5m+MQ5KllxyhjTpBpIMyOtPbHhPK/qbG1fuz4mtrAVYAOey/No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587748; c=relaxed/simple;
	bh=rYLujJI18M4ryX9FVQ9Zcfn7ES5Y/YtD9D3QyU8t/hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnGghnSXdF/9OShWVyuXI3lwnGcr+lqcO9B6LJ3xqkZY8elF6l3aTYb2RadlBfyUSxP20iauve94lf3a8cwJcjRH4aH0VdfOV6WSW11XwdrG/4lhh0xcL71dwkyj2aLfMT2M7Xx82YhM3DiWAJ3yqad4Gnxt0HhOFuQdlxN3T7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xyy+NR/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xyy+NR/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1C5C4CEE3;
	Tue, 15 Jul 2025 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587748;
	bh=rYLujJI18M4ryX9FVQ9Zcfn7ES5Y/YtD9D3QyU8t/hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xyy+NR/hisz8/YGHNKSMm+o6l5JdGugACo/m73Nzl1S4fOqe8F1f/JC4/bzncSoGh
	 6pHWuRZi9VwwvhpzheYQM7AZD0bDWRRHVBDzHe62eI3NmFvyDzX/UpNhk7x2PrstHy
	 SrXpJR+NWDoeTdo/UghGNO7zadVj5k6tsAQHgr+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 127/208] usb: typec: displayport: Fix potential deadlock
Date: Tue, 15 Jul 2025 15:13:56 +0200
Message-ID: <20250715130816.030126812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 099cf1fbb8afc3771f408109f62bdec66f85160e upstream.

The deadlock can occur due to a recursive lock acquisition of
`cros_typec_altmode_data::mutex`.
The call chain is as follows:
1. cros_typec_altmode_work() acquires the mutex
2. typec_altmode_vdm() -> dp_altmode_vdm() ->
3. typec_altmode_exit() -> cros_typec_altmode_exit()
4. cros_typec_altmode_exit() attempts to acquire the mutex again

To prevent this, defer the `typec_altmode_exit()` call by scheduling
it rather than calling it directly from within the mutex-protected
context.

Cc: stable <stable@kernel.org>
Fixes: b4b38ffb38c9 ("usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250624133246.3936737-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -305,8 +305,7 @@ static int dp_altmode_vdm(struct typec_a
 	case CMDT_RSP_NAK:
 		switch (cmd) {
 		case DP_CMD_STATUS_UPDATE:
-			if (typec_altmode_exit(alt))
-				dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+			dp->state = DP_STATE_EXIT;
 			break;
 		case DP_CMD_CONFIGURE:
 			dp->data.conf = 0;


