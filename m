Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D291E2045B5;
	Tue,  8 Jul 2025 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993210; cv=none; b=U9oy4QSybER+ahHUXBM/3813fpp6+uY+rFArIIYQZlic6zfe8anM8AxMSK7JDeElLRAD/jeOUQczyQGNOF2fOym1nTC4GV4QZBbKtFMpvWIUYq9/DUKSpsqwsbEegGuXpVUiv/NoYBPG5kxBIkIQE1RqbeEImg+HxqVNneIcsHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993210; c=relaxed/simple;
	bh=ZIJb+cxDvh8qDrlzakQ3CqZCl9WDYLqy2evE1tgIUWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPm/pX/jjX1wANAvpunlhnWbqYe7iqztTmLc7S76i3Qlvlrl4ooAzCBXIIp3EvDhO75wrNNnuU6ecabYS6ZLLZWYcgZAc/DzOrzR0nBVwwWwXbq7RP4PqpCvYFsh+/JLRzv0KQSBzdyYXsKQucmr63VrlnF5+kVqDaFvQanY9RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCNj9On5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCNj9On5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF06C4CEED;
	Tue,  8 Jul 2025 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993210;
	bh=ZIJb+cxDvh8qDrlzakQ3CqZCl9WDYLqy2evE1tgIUWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCNj9On5BPqk17POyUqAv4X2WS+Jju+v6OjXnUg0M7tc8oaWH03Lj3GDuS409lr70
	 cjhEkAVZskrrddWCVydj8NRhRZ6IY6CaOUdDERFs9d7zGbGqceNFx8AE1ZjSzdupFq
	 I9/HpqJT/5PmKRnibiY0q7iSRreZjsSAvsDFmPdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 224/232] usb: typec: displayport: Fix potential deadlock
Date: Tue,  8 Jul 2025 18:23:40 +0200
Message-ID: <20250708162247.291842449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -394,8 +394,7 @@ static int dp_altmode_vdm(struct typec_a
 	case CMDT_RSP_NAK:
 		switch (cmd) {
 		case DP_CMD_STATUS_UPDATE:
-			if (typec_altmode_exit(alt))
-				dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+			dp->state = DP_STATE_EXIT;
 			break;
 		case DP_CMD_CONFIGURE:
 			dp->data.conf = 0;


