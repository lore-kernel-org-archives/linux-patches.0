Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CD022A804;
	Mon,  2 Jun 2025 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875235; cv=none; b=gVusLeong4jR3MIaSjL6tEA+HmgCB9NTLlAyt7V+FJ9wmyJqrSAFk6LZRCVmXkaOfEccvpsFan8DvO/vvyhGqIEXXoPImq/5lZGPwtD3p9veS9C3hthLX4/+xHxuYe6V68VBykF2fq5I2U9/EpI566N+zZQlNqHZlEMzV7KCPZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875235; c=relaxed/simple;
	bh=yZig6I1mcChph2ANgZFhiUOsDN/2L45hIiv5IuwNrxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9QZCLGyXKcBCVAXVbne7OOP44Sxjcnj5r4563ryI9wkHPM2crtg4/92yV8VSF/JbpbbSmc/ioR4MXjKh3SyhYcXMXexzPnwb7D6Mui4/yNSJgHLtVxg+lAZVELnT+toLdMqm/zOOrgAyp6KgUAwP3qOzhVYYlPaKaoQyYftNC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gszlKLL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gszlKLL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F397C4CEEB;
	Mon,  2 Jun 2025 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875235;
	bh=yZig6I1mcChph2ANgZFhiUOsDN/2L45hIiv5IuwNrxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gszlKLL+SH7U86yR/z7ungd/p8pW9NOKCE9xH/O8hwlkzBQ8xNlbXFq6Xx5dnzNTw
	 cqYMoTEwjyQ8mAoBhI0WLtta3TrrL1o/3rmHd5TUsnpnAskZSHztEl/KGdMIpNKS3b
	 6Kb0azU79l/GCA18Iy2aX0ksc1K3n1ScgZ5fuLPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 071/270] usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition
Date: Mon,  2 Jun 2025 15:45:56 +0200
Message-ID: <20250602134310.088016635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: RD Babiera <rdbabiera@google.com>

commit e918d3959b5ae0e793b8f815ce62240e10ba03a4 upstream.

This patch fixes Type-C Compliance Test TD 4.7.6 - Try.SNK DRP Connect
SNKAS.

The compliance tester moves into SNK_UNATTACHED during toggling and
expects the PUT to apply Rp after tPDDebounce of detection. If the port
is in SNK_TRY_WAIT_DEBOUNCE, it will move into SRC_TRYWAIT immediately
and apply Rp. This violates TD 4.7.5.V.3, where the tester confirms that
the PUT attaches Rp after the transitions to Unattached.SNK for
tPDDebounce.

Change the tcpm_set_state delay between SNK_TRY_WAIT_DEBOUNCE and
SRC_TRYWAIT to tPDDebounce.

Fixes: a0a3e04e6b2c ("staging: typec: tcpm: Check for Rp for tPDDebounce")
Cc: stable <stable@kernel.org>
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250429234703.3748506-2-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4019,7 +4019,7 @@ static void _tcpm_cc_change(struct tcpm_
 	case SNK_TRY_WAIT_DEBOUNCE:
 		if (!tcpm_port_is_sink(port)) {
 			port->max_wait = 0;
-			tcpm_set_state(port, SRC_TRYWAIT, 0);
+			tcpm_set_state(port, SRC_TRYWAIT, PD_T_PD_DEBOUNCE);
 		}
 		break;
 	case SRC_TRY_WAIT:


