Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018185;
	b=hpqCgvgeeNqMR5L5h2iXONd9brpt/+hss+y7yCLIm0fVDPjC4ZsK3sOUr9g4qiHhnmpP
	 6wRBg/320/mNNwXcf94LKNFBab5r94KYHGUHXQA3gPKsWfOAJmaoTccGSNdRhSJdcDGbh
	 8RNFtqjTZrhE11v3jPtzoedTWCvvpPlUcCj3Sxkq/JDlOzoA0BnhvNn4c8wUJeJNmL3Ro
	 g9UOqVabyrX9dVhFqWhPK9wCRuVPjJEd0YBRtkWk6i4SezgOzbcz8FjncEK8w3A5wjug7
	 niLjvnxkK80Z060M11/6McKIDYRgzHk9Sq2E+uhY3RSeW8QqVX/aiKpnitchgjanf9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aD0t4J/mqUZOAG4bAVPYvHsVB+l58tSaKzMHaEPDf3Y=;
	b=lR5qojWfeL2Bh6aNE4aZ0+wRryxuPyi8/TWp4FzLMvALqHufxFr4fgvnXhnONi9JGsRB
	 3mi78PZJBFUmCUREum0ZSiMGm6pKqWs+bU2dmobjMHMZoR/xKj13lpqIQYjk75Md1dcRz
	 cHAdPy19/cEFLIENOdO6vsYZMyrukTeZsEVqLJnSt3MZwXPoWjYrT6qSbBJfsOlogL9Rv
	 cO9Bj1gfOXMXApnRAch+8rrj35EeoSml33TNLtHwes1SnTH7DxyvEemhNa55wHyVL5Bwj
	 hzOalyr+WcHEkZuRneWyuLq/NClinz7+Yp3gSBnUL5nnD9wPAWhM5BqRAJsFU3hNRLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNt0CKeT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341BD606A32A;
	Wed, 18 Nov 2026 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNt0CKeT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F1C1F000C4;
	Wed, 18 Nov 2026 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018185;
	bh=aD0t4J/mqUZOAG4bAVPYvHsVB+l58tSaKzMHaEPDf3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNt0CKeTAghfLyzExxzNzkhfs5yWCxPZ8IYhXi78aIql2yS/3+Hcs4ywKG++QAwG2
	 ivymohX1uYQpm0HhvbDkfL3Q9ebEQyju3ie6wSvsAEkqG/Q5Eh54BnMF2fZP2ttQHn
	 rudNkmnM5BwqAiMYhf4g/aPRzf2r5FuTTq8mZtqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1150/2651] fbnic: Rework the BMC state pulled from the capabilities message
Date: Wed, 18 Nov 2026 15:39:50 +0100
Message-ID: <20261118150329.410136098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit d261a371e3b74c82c417b1171264dd35f6ddc615 ]

The BMC side of the RPC configuration is driven entirely out of the
capabilities message: it carries the BMC presence, its MAC addresses and
the all-multi request, and the reinit flag raised off it is what gets the
service task to reprogram the MACDA and action TCAMs. Pull that out of
fbnic_fw_parse_cap_resp() into a helper and rework the state it publishes.

The firmware reports the BMC present as soon as its NC-SI channel is
enabled, before the BMC has been assigned a MAC address. Such a message
carries no BMC MAC array and is rejected with -EINVAL, discarding the rest
of it. Treat a present BMC with no MAC as absent instead. There is no entry
to steer traffic to without one, so the BMC paths stay disabled either way,
and the link speed, FEC and anti-rollback version in the same message are
no longer thrown out with it.

bmc_present, need_bmc_tcam_reinit, need_bmc_macda_sync and all_multi are
single bit members of one bitfield, so every write to one is a
read-modify-write of all four. The mailbox writes three of them and the
service task writes the other two. Move them into an unsigned long state
field driven by the atomic bitops. Putting it at the top of the struct
keeps the cost to the word itself: 152 bytes grows to 160, still three
cachelines, with a 1 byte hole left ahead of anti_rollback_version.

Order the reinit handoff while there. The mailbox publishes the BMC state
before raising the flag and the service task tests the flag before
consuming it, so pair an smp_mb__before_atomic() on the raise with a
test_and_clear_bit() on the consume. Claiming the flag atomically also
keeps a raise that lands mid-pass instead of dropping it.

Commit all_multi unconditionally rather than only when the firmware
supplied the attribute. An absent attribute means the BMC is not asking for
all-multi, so holding the previous value just kept stale state. It is read
out of the message only when a BMC is present, so it is never set on its
own and the three callers that paired it with the presence check can test
it alone.

fbnic_write_macda() tests the reinit flag to force a MACDA sync and now
always sees it clear when reached from fbnic_bmc_rpc_check(). That path is
unaffected, as fbnic_bmc_rpc_init() unconditionally marks the broadcast
entry, so the update count is never zero while a BMC is present.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Fixes: 20d2e88cc746 ("eth: fbnic: Add initial messaging to notify FW of our presence")
Fixes: 04a230b27d8f ("fbnic: Add logic to repopulate RPC TCAM if BMC enables channel")
Fixes: cee8d21d8091 ("fbnic: Push local unicast MAC addresses to FW to populate TCAMs")
Link: https://patch.msgid.link/179061192791.414394.2161969547553719796.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic.h     |  7 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c  | 78 +++++++++++++--------
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h  | 15 ++--
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c | 24 ++++---
 4 files changed, 80 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic.h b/drivers/net/ethernet/meta/fbnic/fbnic.h
index d0715695c43e7..0d381a6273a50 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic.h
@@ -160,7 +160,12 @@ void fbnic_fw_wr32(struct fbnic_dev *fbd, u32 reg, u32 val);
 
 static inline bool fbnic_bmc_present(struct fbnic_dev *fbd)
 {
-	return fbd->fw_cap.bmc_present;
+	return test_bit(FBNIC_FW_CAP_F_BMC_PRESENT, &fbd->fw_cap.state);
+}
+
+static inline bool fbnic_bmc_all_multi(struct fbnic_dev *fbd)
+{
+	return test_bit(FBNIC_FW_CAP_F_BMC_ALL_MULTI, &fbd->fw_cap.state);
 }
 
 static inline bool fbnic_init_failure(struct fbnic_dev *fbd)
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 6d7eb8479edf4..ce2a66aeb8d26 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -620,11 +620,55 @@ static int fbnic_fw_parse_bmc_addrs(u8 bmc_mac_addr[][ETH_ALEN],
 	return 0;
 }
 
+static int fbnic_fw_parse_bmc_cap(struct fbnic_dev *fbd,
+				  struct fbnic_tlv_msg **results)
+{
+	struct fbnic_tlv_msg *attr;
+	bool bmc_present = false;
+	u32 all_multi = 0;
+	int err;
+
+	/* FW reports the BMC present once its NC-SI channel is enabled, before
+	 * it has a MAC. No MAC array means nothing to program, so treat it as
+	 * absent rather than rejecting the message.
+	 */
+	attr = results[FBNIC_FW_CAP_RESP_BMC_PRESENT] ?
+	       results[FBNIC_FW_CAP_RESP_BMC_MAC_ARRAY] : NULL;
+	if (attr) {
+		err = fbnic_fw_parse_bmc_addrs(fbd->fw_cap.bmc_mac_addr,
+					       attr, 4);
+		if (err)
+			return err;
+
+		all_multi = fta_get_uint(results,
+					 FBNIC_FW_CAP_RESP_BMC_ALL_MULTI);
+		bmc_present = true;
+	} else {
+		memset(fbd->fw_cap.bmc_mac_addr, 0,
+		       sizeof(fbd->fw_cap.bmc_mac_addr));
+	}
+
+	/* all_multi is only read out of the message when a BMC is present, so
+	 * it is never set on its own and callers can test it without pairing
+	 * it with the presence check.
+	 */
+	assign_bit(FBNIC_FW_CAP_F_BMC_PRESENT, &fbd->fw_cap.state, bmc_present);
+	assign_bit(FBNIC_FW_CAP_F_BMC_ALL_MULTI, &fbd->fw_cap.state, all_multi);
+
+	/* Always assume we need a BMC reinit. The barrier orders the BMC state
+	 * published above ahead of the flag, pairing with the ordering implied
+	 * by the test_and_clear_bit() in fbnic_bmc_rpc_check().
+	 */
+	smp_mb__before_atomic();
+	set_bit(FBNIC_FW_CAP_F_BMC_TCAM_REINIT, &fbd->fw_cap.state);
+
+	return 0;
+}
+
 static int fbnic_fw_parse_cap_resp(void *opaque, struct fbnic_tlv_msg **results)
 {
-	u32 all_multi = 0, version = 0;
 	struct fbnic_dev *fbd = opaque;
-	bool bmc_present;
+	u32 version = 0;
 	int err;
 
 	version = fta_get_uint(results, FBNIC_FW_CAP_RESP_VERSION);
@@ -684,37 +728,13 @@ static int fbnic_fw_parse_cap_resp(void *opaque, struct fbnic_tlv_msg **results)
 	fbd->fw_cap.link_fec =
 		fta_get_uint(results, FBNIC_FW_CAP_RESP_FW_LINK_FEC);
 
-	bmc_present = !!results[FBNIC_FW_CAP_RESP_BMC_PRESENT];
-	if (bmc_present) {
-		struct fbnic_tlv_msg *attr;
-
-		attr = results[FBNIC_FW_CAP_RESP_BMC_MAC_ARRAY];
-		if (!attr)
-			return -EINVAL;
-
-		err = fbnic_fw_parse_bmc_addrs(fbd->fw_cap.bmc_mac_addr,
-					       attr, 4);
-		if (err)
-			return err;
-
-		all_multi =
-			fta_get_uint(results, FBNIC_FW_CAP_RESP_BMC_ALL_MULTI);
-	} else {
-		memset(fbd->fw_cap.bmc_mac_addr, 0,
-		       sizeof(fbd->fw_cap.bmc_mac_addr));
-	}
-
-	fbd->fw_cap.bmc_present = bmc_present;
-
-	if (results[FBNIC_FW_CAP_RESP_BMC_ALL_MULTI] || !bmc_present)
-		fbd->fw_cap.all_multi = all_multi;
+	err = fbnic_fw_parse_bmc_cap(fbd, results);
+	if (err)
+		return err;
 
 	fbd->fw_cap.anti_rollback_version =
 		fta_get_uint(results, FBNIC_FW_CAP_RESP_ANTI_ROLLBACK_VERSION);
 
-	/* Always assume we need a BMC reinit */
-	fbd->fw_cap.need_bmc_tcam_reinit = true;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
index 5f9969247e305..e542b17bdac7e 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.h
@@ -45,7 +45,18 @@ struct fbnic_fw_ver {
 	char commit[FBNIC_FW_CAP_RESP_COMMIT_MAX_SIZE];
 };
 
+/* Bits in fbnic_fw_cap.state. The firmware mailbox publishes the BMC state
+ * and the service task consumes it, so they are updated with atomic bitops.
+ */
+enum {
+	FBNIC_FW_CAP_F_BMC_PRESENT,
+	FBNIC_FW_CAP_F_BMC_ALL_MULTI,
+	FBNIC_FW_CAP_F_BMC_TCAM_REINIT,
+	FBNIC_FW_CAP_F_BMC_MACDA_SYNC,
+};
+
 struct fbnic_fw_cap {
+	unsigned long state;
 	struct {
 		struct fbnic_fw_ver mgmt, bootloader;
 	} running;
@@ -54,10 +65,6 @@ struct fbnic_fw_cap {
 	} stored;
 	u8	active_slot;
 	u8	bmc_mac_addr[4][ETH_ALEN];
-	u8	bmc_present		: 1;
-	u8	need_bmc_tcam_reinit	: 1;
-	u8	need_bmc_macda_sync	: 1;
-	u8	all_multi		: 1;
 	u8	link_speed;
 	u8	link_fec;
 	u32	anti_rollback_version;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
index bc0f38b6a2b2b..f94ce73ddc109 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_rpc.c
@@ -117,7 +117,7 @@ void fbnic_bmc_rpc_all_multi_config(struct fbnic_dev *fbd,
 	 * BMC.
 	 */
 	mac_addr = &fbd->mac_addr[fbd->mac_addr_boundary - 1];
-	if (fbnic_bmc_present(fbd) && fbd->fw_cap.all_multi) {
+	if (fbnic_bmc_all_multi(fbd)) {
 		if (mac_addr->state != FBNIC_TCAM_S_VALID) {
 			eth_zero_addr(mac_addr->value.addr8);
 			eth_broadcast_addr(mac_addr->mask.addr8);
@@ -148,7 +148,7 @@ void fbnic_bmc_rpc_all_multi_config(struct fbnic_dev *fbd,
 	/* If we are not enabling the rule just delete it. We will fall
 	 * back to the RSS rules that support the multicast addresses.
 	 */
-	if (!fbnic_bmc_present(fbd) || !fbd->fw_cap.all_multi || enable_host) {
+	if (!fbnic_bmc_all_multi(fbd) || enable_host) {
 		if (act_tcam->state == FBNIC_TCAM_S_VALID)
 			act_tcam->state = FBNIC_TCAM_S_DELETE;
 		return;
@@ -242,20 +242,25 @@ void fbnic_bmc_rpc_check(struct fbnic_dev *fbd)
 {
 	int err;
 
-	if (fbd->fw_cap.need_bmc_tcam_reinit) {
+	/* Consume the flag before the state it advertises. The ordering
+	 * implied by test_and_clear_bit() pairs with the barrier in
+	 * fbnic_fw_parse_bmc_cap(), and claiming it atomically means a set
+	 * racing with us is kept and retried rather than overwritten.
+	 */
+	if (test_and_clear_bit(FBNIC_FW_CAP_F_BMC_TCAM_REINIT,
+			       &fbd->fw_cap.state)) {
 		fbnic_bmc_rpc_init(fbd);
 		netif_addr_lock_bh(fbd->netdev);
 		__fbnic_set_rx_mode(fbd, &fbd->netdev->uc, &fbd->netdev->mc);
 		netif_addr_unlock_bh(fbd->netdev);
-		fbd->fw_cap.need_bmc_tcam_reinit = false;
 	}
 
-	if (fbd->fw_cap.need_bmc_macda_sync) {
+	if (test_and_clear_bit(FBNIC_FW_CAP_F_BMC_MACDA_SYNC,
+			       &fbd->fw_cap.state)) {
 		err = fbnic_fw_xmit_rpc_macda_sync(fbd);
 		if (err)
 			dev_warn(fbd->dev,
 				 "Writing MACDA table to FW failed, err: %d\n", err);
-		fbd->fw_cap.need_bmc_macda_sync = false;
 	}
 }
 
@@ -488,8 +493,7 @@ void fbnic_promisc_sync(struct fbnic_dev *fbd,
 				mac_addr->act_tcam);
 			mac_addr->state = FBNIC_TCAM_S_ADD;
 		}
-	} else if (mc_promisc &&
-		   (!fbnic_bmc_present(fbd) || !fbd->fw_cap.all_multi)) {
+	} else if (mc_promisc && !fbnic_bmc_all_multi(fbd)) {
 		/* We have to add a special handler for multicast as the
 		 * BMC may have an all-multi rule already in place. As such
 		 * adding a rule ourselves won't do any good so we will have
@@ -660,12 +664,12 @@ void fbnic_write_macda(struct fbnic_dev *fbd)
 	}
 
 	/* If reinitializing the BMC TCAM we are doing an initial update */
-	if (fbd->fw_cap.need_bmc_tcam_reinit)
+	if (test_bit(FBNIC_FW_CAP_F_BMC_TCAM_REINIT, &fbd->fw_cap.state))
 		updates++;
 
 	/* If needed notify firmware of changes to MACDA TCAM */
 	if (updates != 0 && fbnic_bmc_present(fbd))
-		fbd->fw_cap.need_bmc_macda_sync = true;
+		set_bit(FBNIC_FW_CAP_F_BMC_MACDA_SYNC, &fbd->fw_cap.state);
 }
 
 static void fbnic_clear_act_tcam(struct fbnic_dev *fbd, unsigned int idx)
-- 
2.53.0



