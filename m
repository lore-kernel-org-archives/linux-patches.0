Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC441C173C;
	Mon, 12 May 2025 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072104; cv=none; b=GOg7aC9bHTKXs4oZ1jyXj9lcuCrKyJGpYqwaNbDNuhzYP+tRmzCO9hTqutTiUBEoXiNeeVKJ0yomzUhTxuhRvU5806dZXCJ9zIW/T4xcXaSmMx2uWY2j+ZU5RMt0YoBRiaR3fmNf0T2F/yz7dfs/17cz+lWMePXHdVF39VpgIWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072104; c=relaxed/simple;
	bh=yLh8Gc2btk292SddYGsluK8I86I7KNklLerUBX2YbQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U89r6s8Czc+Ovu4oT9CSek2jlslILv71xBTTxsPyoglo8xS6Z7kectra1QPtKcfGAYxxWzYWMhuzI1jCXuxY7o0fd9lzxOUf2Ui5yPbrltRRAW0bC9JW7DNnMe3l/5ni8dZmt1tCM1J8Mjo3FhhrnZOBOjdG4gX5MEdgXSV4c0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIlo2aRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIlo2aRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B9DC4CEE7;
	Mon, 12 May 2025 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072104;
	bh=yLh8Gc2btk292SddYGsluK8I86I7KNklLerUBX2YbQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIlo2aRLU1lH0mHYSYk0/54pdt2hrTVhoyk2frPJLfPbontGzu4rdozE8aJvcCw/o
	 XivDO6n9io44E9rdxvCXJuY581vBOkUl0tVzuoDUECxKF736aHf1AmRHhC8AIDVWQK
	 2dv3et363JrsLFcK5fEzTQ4obe58IPECL9QEuD2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.14 142/197] usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition
Date: Mon, 12 May 2025 19:39:52 +0200
Message-ID: <20250512172050.178619253@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5965,7 +5965,7 @@ static void _tcpm_cc_change(struct tcpm_
 	case SNK_TRY_WAIT_DEBOUNCE:
 		if (!tcpm_port_is_sink(port)) {
 			port->max_wait = 0;
-			tcpm_set_state(port, SRC_TRYWAIT, 0);
+			tcpm_set_state(port, SRC_TRYWAIT, PD_T_PD_DEBOUNCE);
 		}
 		break;
 	case SRC_TRY_WAIT:


