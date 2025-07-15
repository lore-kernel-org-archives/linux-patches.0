Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AFE2E8DF8;
	Tue, 15 Jul 2025 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586640; cv=none; b=a8qklLzuaLArMomtaYbXDOLxdcd8wwvaOi8ENLqweQs8Co1FzOYoDvD/DBltZZwAcAM/7KvEjuoWIl9HSo6qMiijfDF/FDax6qPkuODymx9+P3pKNaBHWQ9cSNcgm9ucLfxTCtT4Nr7V5tPWWKmwWgGIYVk6vgQ6YSTtNex9o0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586640; c=relaxed/simple;
	bh=IMRiQIpYF7wMMgz5aNQSrVE9bdhpaYFvBANroQOlgUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4CncXw4oTyJHk/bfCqn43LaaAvVBx7cohWKCSmi5Nef9w71ypZg0afMac3BIbR69tPMNjO44ku7qR3w5q46iw6M0VQBCdJWJySVdLLaRZODFrtliW3kaC/5RszYGFRyKrbk+MBF4/F4k7WrVgFJRSvSY6e9gHveaCAh+u8jomQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0evRp3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0evRp3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53744C4CEF1;
	Tue, 15 Jul 2025 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586639;
	bh=IMRiQIpYF7wMMgz5aNQSrVE9bdhpaYFvBANroQOlgUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0evRp3PzyY55W+gS+5Vz56APDl0q6m8iq7c93TJ3uIM8xuLsYL6Im5+HXTt7IZz2
	 KQdsibbNJ+1YISb74+EdMiuE79kmqphTHftBIiYtUdK2jCI+ACHdG7lgAHc64eAMLr
	 JvYaPCIi+F0blHwKd6ps6XHsvl7ydUMZfz46U3gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.4 100/148] usb: typec: displayport: Fix potential deadlock
Date: Tue, 15 Jul 2025 15:13:42 +0200
Message-ID: <20250715130804.318577998@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -289,8 +289,7 @@ static int dp_altmode_vdm(struct typec_a
 	case CMDT_RSP_NAK:
 		switch (cmd) {
 		case DP_CMD_STATUS_UPDATE:
-			if (typec_altmode_exit(alt))
-				dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+			dp->state = DP_STATE_EXIT;
 			break;
 		case DP_CMD_CONFIGURE:
 			dp->data.conf = 0;


