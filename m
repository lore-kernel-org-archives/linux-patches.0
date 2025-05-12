Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDCF29A9EB;
	Mon, 12 May 2025 18:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073434; cv=none; b=Lo18n/E195jAoxoaa2IE0FPGtXGOtBuLM4ptwbt97G8FcAaxTb6QxF82FSbBSXIzpqRKm08mqEfq8qZVrOuQ5OjbwK8yH3IYDvAF5/7lPNLdbB2OCoa1y3z0wL28gsu+3H9BeUfjfsLHaiKCjtQgHNANFvxw66cjss+eDrfI3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073434; c=relaxed/simple;
	bh=cp4N3UexlNR895+Jylunj+wUyUcHLuVAZmNzkmR9thg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRN06+eGhjDlPex4m3DE3G5ELgSqEbjaQ3qs2Wiho1HTRMW/XgdUYyISfXWhTBd6JEGmvmv4XI4R4vkzTBLkNETqMDEMUBqMitE7NpdJNK8vYp0hglORuSj2GFR1AW9bnm9mHfvFPuRKGkMjVNkrhBYWZQkgrzYfJLW+QemXjmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WriwNcE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WriwNcE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0738C4CEE7;
	Mon, 12 May 2025 18:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073434;
	bh=cp4N3UexlNR895+Jylunj+wUyUcHLuVAZmNzkmR9thg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WriwNcE9s2FEWbkbd40q9SYYsFw5G9U/m9kY4c2k2fekbj8GoFsudY/oRahB96Mjb
	 Jz2DNinTIvatDxQJFQySA8p7a9G8Xnm4ou9qjAVEyE6TYXyE7hWuydg1ONGqAwYtTV
	 YdioijLrwaDQWvOtB4zjg6/amfoF+r4iN+2bePmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 073/113] usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition
Date: Mon, 12 May 2025 19:46:02 +0200
Message-ID: <20250512172030.647724753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5102,7 +5102,7 @@ static void _tcpm_cc_change(struct tcpm_
 	case SNK_TRY_WAIT_DEBOUNCE:
 		if (!tcpm_port_is_sink(port)) {
 			port->max_wait = 0;
-			tcpm_set_state(port, SRC_TRYWAIT, 0);
+			tcpm_set_state(port, SRC_TRYWAIT, PD_T_PD_DEBOUNCE);
 		}
 		break;
 	case SRC_TRY_WAIT:


