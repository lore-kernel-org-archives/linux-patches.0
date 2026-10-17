Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F1038F233;
	Sat, 17 Oct 2026 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258906; cv=none; b=sapBxr9yMHtPeSyg+1HpJrjoPlzPYmOs06KI4pbnA+8Sx3yhHu5E+WNUHcS7b/9/xHouXy7THt4AFZvepKRMTDp2R7XzI/PPGLRBIz47miSDu0kRxGz2LZqKg16dXiel6EV7YRKVEpwE9079LLaFo92uxANaBrnvKqUiFBvT+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258906; c=relaxed/simple;
	bh=Leb1ZPHcZE0p4s3bfxHQS6xeyEXwlzOtuKfQoiPcWkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4ghLrR9MDMFsj2pDXXYJuQ/xY0w4XlwYgP0b7B9tneMkRAPOzejAdi6fGg2kJd7lLt4L5KMnd+NPO8F5BM0dKOxspKckaC3/VK+ES4xqM0G2rj1zBPy80pUeaKDYfihW8bkjyoVWrpw39zNhiZeOpD9HLpOiGY4KcizD5rnCV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MieopYAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MieopYAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF681F000C4;
	Sat, 17 Oct 2026 17:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258905;
	bh=p9JaHK/nerB6mmEgI6HCiaUfJp9hILF3ny6k035+Pxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MieopYAt/WVs3yxUjiPE/ey7in8GV0g2cGmNcqXDkOkZyJ3FsVsUHAAZ+QUm9Eec3
	 jw6PfOePuD2cHfMEn4p6IiKwYBcGz4C4snrs+3MIbOdD/zlS305xAd0uCGuMo400/6
	 WNHYJUc7rC7gsVUVWSuOdXmAi+0/bhqQYs4EcOi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1038/1674] usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()
Date: Sat, 17 Oct 2026 17:55:10 +0200
Message-ID: <20261017160457.777257069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 3389c149c68c3fea61910ad5d34f7bf3bff44e32 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 3c4bdd9695b60..d93393aeb2f49 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1553,17 +1553,16 @@ static void svdm_consume_modes(struct tcpm_port *port, const u32 *p, int cnt)
 	struct typec_altmode_desc *paltmode;
 	int i;
 
-	if (pmdata->altmodes >= ARRAY_SIZE(port->partner_altmode)) {
-		/* Already logged in svdm_consume_svids() */
-		return;
-	}
-
 	if (pmdata->svid_index < 0 || pmdata->svid_index >= pmdata->nsvids) {
 		tcpm_log(port, "Invalid SVID index %d", pmdata->svid_index);
 		return;
 	}
 
 	for (i = 1; i < cnt; i++) {
+		if (pmdata->altmodes >= ALTMODE_DISCOVERY_MAX) {
+			/* Already logged in svdm_consume_svids() */
+			return;
+		}
 		paltmode = &pmdata->altmode_desc[pmdata->altmodes];
 		memset(paltmode, 0, sizeof(*paltmode));
 
-- 
2.53.0



