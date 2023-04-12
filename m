Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8E92F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE865C433D2;
	Wed, 12 Apr 2023 08:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289355;
	bh=4JGRkfaABeW2vM6Pg0ybjR4+395wKaZDSbKQnDp9WZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQil6CF3qYF7xZ1OrsAiVD6wsYu89Gyflnl/ndBpkeSrFFdXDxbAdwnQshzK2uKKe
	 O4Xrs2PwOLpPu5WTgv9pMRRoxUn+lSkOo65ShDCq8tKIMvb4F+Q6gN3J41DdiAhQv9
	 OGPgPliKtH8Gq1vV3GhVsXtyg5nCdXiYFQ60xm1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RD Babiera <rdbabiera@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.2 068/173] usb: typec: altmodes/displayport: Fix configure initial pin assignment
Date: Wed, 12 Apr 2023 10:33:14 +0200
Message-Id: <20230412082840.817073866@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: RD Babiera <rdbabiera@google.com>

commit eddebe39602efe631b83ff8d03f26eba12cfd760 upstream.

While determining the initial pin assignment to be sent in the configure
message, using the DP_PIN_ASSIGN_DP_ONLY_MASK mask causes the DFP_U to
send both Pin Assignment C and E when both are supported by the DFP_U and
UFP_U. The spec (Table 5-7 DFP_U Pin Assignment Selection Mandates,
VESA DisplayPort Alt Mode Standard v2.0) indicates that the DFP_U never
selects Pin Assignment E when Pin Assignment C is offered.

Update the DP_PIN_ASSIGN_DP_ONLY_MASK conditional to intially select only
Pin Assignment C if it is available.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230329215159.2046932-1-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -112,8 +112,12 @@ static int dp_altmode_configure(struct d
 		if (dp->data.status & DP_STATUS_PREFER_MULTI_FUNC &&
 		    pin_assign & DP_PIN_ASSIGN_MULTI_FUNC_MASK)
 			pin_assign &= DP_PIN_ASSIGN_MULTI_FUNC_MASK;
-		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK)
+		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK) {
 			pin_assign &= DP_PIN_ASSIGN_DP_ONLY_MASK;
+			/* Default to pin assign C if available */
+			if (pin_assign & BIT(DP_PIN_ASSIGN_C))
+				pin_assign = BIT(DP_PIN_ASSIGN_C);
+		}
 
 		if (!pin_assign)
 			return -EINVAL;


