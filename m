Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2312343D63;
	Tue, 26 Aug 2025 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218530; cv=none; b=RaBVCbPFtuMmSg9/nTu0d/4qgrbz1Zagxb8qeWrYzAZFI0tkrSQ43f5ihK3+jeUj9LCfY7TPpjvt6fGMKka4o87d4yavt7egLNwrj1Vi2X7lv5/dhaTTBZ295qpM+I32mq0GdobKmOZUkA+Qyi+OX+L3IVbC93kDGgwtP01O+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218530; c=relaxed/simple;
	bh=T2lMROflOuoj+i6/ohrq+vcDgrwzxIMvLkRxShkIsLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ3SejdGu1mR/Pp49AZ5h4klIhIAn3esA+IXLHLwwP163JpslMn80A8iV9OIUfUI/zUyChDzjKyzrMp5PtLRhFILGtLq5F1BDC0kfddzmdSClD8lBAgmyizAo8UBx0Un3Mbb/tuNwMsLplfrIqjrNE7w7YtijAuW6NCAQAr7hX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMlLeVe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMlLeVe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AE6C4CEF1;
	Tue, 26 Aug 2025 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218530;
	bh=T2lMROflOuoj+i6/ohrq+vcDgrwzxIMvLkRxShkIsLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMlLeVe74mZ+DuJcC01rri26dJz0Hu/sqVEo9Y4vE2PjeufRaJwCe/JxwFn+eZaM3
	 Ya9SvKG/kafyS/jG5IxAXcsNn4Iq5J+RmQ6Ze6nihYXjMI3ZzUCpq6gz5vC30+Khdo
	 h8OLhD3A36vLl5ad1HSGXmIGWbuuzVidGJyA71tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/403] Bluetooth: SMP: If an unallowed command is received consider it a failure
Date: Tue, 26 Aug 2025 13:06:01 +0200
Message-ID: <20250826110906.785636410@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit fe4840df0bdf341f376885271b7680764fe6b34e ]

If a command is received while a bonding is ongoing consider it a
pairing failure so the session is cleanup properly and the device is
disconnected immediately instead of continuing with other commands that
may result in the session to get stuck without ever completing such as
the case bellow:

> ACL Data RX: Handle 2048 flags 0x02 dlen 21
      SMP: Identity Information (0x08) len 16
        Identity resolving key[16]: d7e08edef97d3e62cd2331f82d8073b0
> ACL Data RX: Handle 2048 flags 0x02 dlen 21
      SMP: Signing Information (0x0a) len 16
        Signature key[16]: 1716c536f94e843a9aea8b13ffde477d
Bluetooth: hci0: unexpected SMP command 0x0a from XX:XX:XX:XX:XX:XX
> ACL Data RX: Handle 2048 flags 0x02 dlen 12
      SMP: Identity Address Information (0x09) len 7
        Address: XX:XX:XX:XX:XX:XX (Intel Corporate)

While accourding to core spec 6.1 the expected order is always BD_ADDR
first first then CSRK:

When using LE legacy pairing, the keys shall be distributed in the
following order:

    LTK by the Peripheral

    EDIV and Rand by the Peripheral

    IRK by the Peripheral

    BD_ADDR by the Peripheral

    CSRK by the Peripheral

    LTK by the Central

    EDIV and Rand by the Central

    IRK by the Central

    BD_ADDR by the Central

    CSRK by the Central

When using LE Secure Connections, the keys shall be distributed in the
following order:

    IRK by the Peripheral

    BD_ADDR by the Peripheral

    CSRK by the Peripheral

    IRK by the Central

    BD_ADDR by the Central

    CSRK by the Central

According to the Core 6.1 for commands used for key distribution "Key
Rejected" can be used:

  '3.6.1. Key distribution and generation

  A device may reject a distributed key by sending the Pairing Failed command
  with the reason set to "Key Rejected".

Fixes: b28b4943660f ("Bluetooth: Add strict checks for allowed SMP PDUs")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 19 ++++++++++++++++++-
 net/bluetooth/smp.h |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 4d5ba9778885d..3227956eb7417 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2908,8 +2908,25 @@ static int smp_sig_channel(struct l2cap_chan *chan, struct sk_buff *skb)
 	if (code > SMP_CMD_MAX)
 		goto drop;
 
-	if (smp && !test_and_clear_bit(code, &smp->allow_cmd))
+	if (smp && !test_and_clear_bit(code, &smp->allow_cmd)) {
+		/* If there is a context and the command is not allowed consider
+		 * it a failure so the session is cleanup properly.
+		 */
+		switch (code) {
+		case SMP_CMD_IDENT_INFO:
+		case SMP_CMD_IDENT_ADDR_INFO:
+		case SMP_CMD_SIGN_INFO:
+			/* 3.6.1. Key distribution and generation
+			 *
+			 * A device may reject a distributed key by sending the
+			 * Pairing Failed command with the reason set to
+			 * "Key Rejected".
+			 */
+			smp_failure(conn, SMP_KEY_REJECTED);
+			break;
+		}
 		goto drop;
+	}
 
 	/* If we don't have a context the only allowed commands are
 	 * pairing request and security request.
diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
index 121edadd5f8da..f17de3d9778d0 100644
--- a/net/bluetooth/smp.h
+++ b/net/bluetooth/smp.h
@@ -138,6 +138,7 @@ struct smp_cmd_keypress_notify {
 #define SMP_NUMERIC_COMP_FAILED		0x0c
 #define SMP_BREDR_PAIRING_IN_PROGRESS	0x0d
 #define SMP_CROSS_TRANSP_NOT_ALLOWED	0x0e
+#define SMP_KEY_REJECTED		0x0f
 
 #define SMP_MIN_ENC_KEY_SIZE		7
 #define SMP_MAX_ENC_KEY_SIZE		16
-- 
2.39.5



