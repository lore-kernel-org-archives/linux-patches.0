Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD8526ED5D;
	Sun,  7 Jun 2026 10:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828325; cv=none; b=Cz4ny4Sb4fxUhTnLV4gytN9/lmsUQAJroBYb+NUNlnnpqv6qfIv2JnvSceXi+NX453jWyLHWbUhHv0/x0JRAk6Iz/oztUm6rN9MUYxDMfeGtYrYDnt2Q4TlXcq6lqWCf2lAjsxT8Xf/8ePgAm0plL5vq521GZVU0ix3f2J8SSlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828325; c=relaxed/simple;
	bh=j9j2ajs18YjDWNhLW+2mlo1kPoQwylr9usKUCYIMxFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nByHARaElWWl5Qhy88fuZKOGCF46AR3gOBElhPiGTdEajwIHcBm4UJ6/EVBIc8Zgs0vRA1wncH/7JcwhFGbe5u4ZUKHZYRVz6WmLXwNxBm62ZE0kuuhFRUigekIBQxxcBzGyP1Uk7Ft+Pl43WzLkhg/cDWQV3vMsx3xs4m7C7O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNHBOLhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNHBOLhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB0B1F00893;
	Sun,  7 Jun 2026 10:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828323;
	bh=oOVyDCMBJJ0g3LJKR1No7K6y1EWpVotb84CvTbWmdV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNHBOLhOfZ4yiRXTTSRjF6NvDCC5AWt0Wp8QHuy7U7zBO0RYZ/SBBmWjdY4M5RhHP
	 bNxzEuwnLLrgJPI02NI1izzcaCvVzb/8XqtE72P7sE60JO8XEZk1Brx8AHr29Dost4
	 EMYSkmEdNvINq3YUqTPJvzIf6z2CRPJdIm++BmeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 129/307] usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()
Date: Sun,  7 Jun 2026 11:58:46 +0200
Message-ID: <20260607095732.491993574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 3389c149c68c3fea61910ad5d34f7bf3bff44e32 upstream.

svdm_consume_modes() checks pmdata->altmodes against the array size once
before the loop over the count, but forgot to check the bound at every
point in the loop.

In the well-behaved SVDM discovery flow this is harmless because each of
at most SVID_DISCOVERY_MAX SVIDs contributes at most MODE_DISCOVERY_MAX
modes, exactly filling altmode_desc[ALTMODE_DISCOVERY_MAX].  But the
CMDT_RSP_ACK handler in tcpm_pd_svdm() does not correlate an incoming
ACK with any request the port actually sent.  Once port->partner is set,
an unsolicited Discover Modes ACK is consumed unconditionally.  A broken
or malicious port partner can therefore drive altmodes to
ALTMODE_DISCOVERY_MAX - 1 via the normal flow, and then send one extra
Discover Modes ACK with seven VDOs.  Because the pre-loop check passes,
the loop could then writes up to five entries past altmode_desc[].  For
mode_data_prime the next field in struct tcpm_port is the
partner_altmode[] pointer array, which then receives partner-chosen
SVID/VDO bytes.

Move the bound check inside the loop so the array can never be indexed
past ALTMODE_DISCOVERY_MAX regardless of how many VDOs the partner
supplies or how the function was reached.

Assisted-by: gkh_clanker_t1000
Cc: Badhri Jagan Sridharan <badhri@google.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/2026051351-reshuffle-skillful-90af@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1776,23 +1776,19 @@ static void svdm_consume_modes(struct tc
 	switch (rx_sop_type) {
 	case TCPC_TX_SOP_PRIME:
 		pmdata = &port->mode_data_prime;
-		if (pmdata->altmodes >= ARRAY_SIZE(port->plug_prime_altmode)) {
-			/* Already logged in svdm_consume_svids() */
-			return;
-		}
 		break;
 	case TCPC_TX_SOP:
 		pmdata = &port->mode_data;
-		if (pmdata->altmodes >= ARRAY_SIZE(port->partner_altmode)) {
-			/* Already logged in svdm_consume_svids() */
-			return;
-		}
 		break;
 	default:
 		return;
 	}
 
 	for (i = 1; i < cnt; i++) {
+		if (pmdata->altmodes >= ALTMODE_DISCOVERY_MAX) {
+			/* Already logged in svdm_consume_svids() */
+			return;
+		}
 		paltmode = &pmdata->altmode_desc[pmdata->altmodes];
 		memset(paltmode, 0, sizeof(*paltmode));
 


