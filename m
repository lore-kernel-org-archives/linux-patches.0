Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC88F393DF2;
	Tue, 26 Aug 2025 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215480; cv=none; b=U++k+qICwcPJj/HlOeCiOom1AfWun3fx4BDRI0CVoZ88/mo68jA+5EkOVP6C6dTAIYvVmyUfogJaTGIxENJiYEbAG3tm29gQZM3aXSnLzpmxAStceVFSzpJ0wyeW7gTfRbvZgvXengFVWveNxGU520lCOP514qw0JXvB8MxML/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215480; c=relaxed/simple;
	bh=34lEjL9qBn3Okz7fdZ27pDyabSAwhaOJXr272cZRVng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKeNMPI6snwrUd6ryfKhjte2T2UcEyrPSpj2FuxO9WIR+yGtXOErVZlR7FRyQ9zgIjUNsQBxzDh8/q8Er1sN6YdaJBuK1gH10V7K7PfmmfLxai9d3BLVrjdj7Kn6wuleL3aMVqydGWQdNxW3wMMK6uFa9+5HgR6pB1j770N1SuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRwjvhGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRwjvhGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E804C4CEF1;
	Tue, 26 Aug 2025 13:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215480;
	bh=34lEjL9qBn3Okz7fdZ27pDyabSAwhaOJXr272cZRVng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRwjvhGAxxNsm2w4AggyEWa9BGQ8wX1lvR2RvnyxRiD76NEk0WN7i70nuf6hXqdcD
	 mQty3TxfiNv+vLsI3yQ9eFM+hXmhQS3MmB70L1thVk5qgXDSn1sfSm+atHFCuLIxKs
	 Yvy0J+YqhSYsF2kUTKo2DASTH0ba6cyxG7U5Wd4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/644] Bluetooth: SMP: If an unallowed command is received consider it a failure
Date: Tue, 26 Aug 2025 13:02:20 +0200
Message-ID: <20250826110947.719449354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 724dc901eaf27..0f4e92c4dc94a 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2971,8 +2971,25 @@ static int smp_sig_channel(struct l2cap_chan *chan, struct sk_buff *skb)
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
index 87a59ec2c9f02..c5da53dfab04f 100644
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



