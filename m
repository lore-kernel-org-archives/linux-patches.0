Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829AC2EAD1B;
	Tue, 15 Jul 2025 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587561; cv=none; b=AF1Sao1qSiQKpY58bfYSxSoTDQQYRVXCit7Q7ZcoAG0prJpJpbB1m/fBWnbuSpJSplQ48WYEc4q5ztCW/p/NFUg2kGQxqyZKnEnuxDzY6idphxRaiu2UEk0YCDWi58HJzlzXv2a8Litbkn6a2a9uMK31ZTMsGbfEVlHj16K8W5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587561; c=relaxed/simple;
	bh=k1uXgcip4gKPj7VgFwS3ZGOmnoEsSisEEOnN4NHfSBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aWiEAOukLyu/P060vOrwXXXTeYBCrFtYgGq7gAe1FjigwIME9dIAyePZx1P6/QvH524AsL0egSWOWLKsxU9PgmKDqoYtPy/Q7Cd844hzIVfDVA6c7PnOM7z8tY4PdxlbZgJAvB8rOdhu5m53LSJvco1sX+6eEcv6+GKROI/Y5TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ilvhh/kL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ilvhh/kL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEBFC4CEE3;
	Tue, 15 Jul 2025 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587561;
	bh=k1uXgcip4gKPj7VgFwS3ZGOmnoEsSisEEOnN4NHfSBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ilvhh/kLKLZwwSClEI8FnL+bN/E9rB445Eg9mfRQGUfvS9JGSCtBIKTZga5nPU9+b
	 b3cI2m9G2mdaj7qn2v2hDATRWLuJWHf59QiS7rX/3oDzCMIyJDV61DP2Yjrr35I9Bg
	 GOGCLE8KLRiLdZOlgBFWrTnFcYPnT6Kqh/2mRESM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 057/208] Bluetooth: L2CAP: Fix L2CAP MTU negotiation
Date: Tue, 15 Jul 2025 15:12:46 +0200
Message-ID: <20250715130813.236053305@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

commit 042bb9603c44620dce98717a2d23235ca57a00d7 upstream.

OBEX download from iPhone is currently slow due to small packet size
used to transfer data which doesn't follow the MTU negotiated during
L2CAP connection, i.e. 672 bytes instead of 32767:

  < ACL Data TX: Handle 11 flags 0x00 dlen 12
      L2CAP: Connection Request (0x02) ident 18 len 4
        PSM: 4103 (0x1007)
        Source CID: 72
  > ACL Data RX: Handle 11 flags 0x02 dlen 16
      L2CAP: Connection Response (0x03) ident 18 len 8
        Destination CID: 14608
        Source CID: 72
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
  < ACL Data TX: Handle 11 flags 0x00 dlen 27
      L2CAP: Configure Request (0x04) ident 20 len 19
        Destination CID: 14608
        Flags: 0x0000
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 32767
        Option: Retransmission and Flow Control (0x04) [mandatory]
          Mode: Enhanced Retransmission (0x03)
          TX window size: 63
          Max transmit: 3
          Retransmission timeout: 2000
          Monitor timeout: 12000
          Maximum PDU size: 1009
  > ACL Data RX: Handle 11 flags 0x02 dlen 26
      L2CAP: Configure Request (0x04) ident 72 len 18
        Destination CID: 72
        Flags: 0x0000
        Option: Retransmission and Flow Control (0x04) [mandatory]
          Mode: Enhanced Retransmission (0x03)
          TX window size: 32
          Max transmit: 255
          Retransmission timeout: 0
          Monitor timeout: 0
          Maximum PDU size: 65527
        Option: Frame Check Sequence (0x05) [mandatory]
          FCS: 16-bit FCS (0x01)
  < ACL Data TX: Handle 11 flags 0x00 dlen 29
      L2CAP: Configure Response (0x05) ident 72 len 21
        Source CID: 14608
        Flags: 0x0000
        Result: Success (0x0000)
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 672
        Option: Retransmission and Flow Control (0x04) [mandatory]
          Mode: Enhanced Retransmission (0x03)
          TX window size: 32
          Max transmit: 255
          Retransmission timeout: 2000
          Monitor timeout: 12000
          Maximum PDU size: 1009
  > ACL Data RX: Handle 11 flags 0x02 dlen 32
      L2CAP: Configure Response (0x05) ident 20 len 24
        Source CID: 72
        Flags: 0x0000
        Result: Success (0x0000)
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 32767
        Option: Retransmission and Flow Control (0x04) [mandatory]
          Mode: Enhanced Retransmission (0x03)
          TX window size: 63
          Max transmit: 3
          Retransmission timeout: 2000
          Monitor timeout: 12000
          Maximum PDU size: 1009
        Option: Frame Check Sequence (0x05) [mandatory]
          FCS: 16-bit FCS (0x01)
  ...
  > ACL Data RX: Handle 11 flags 0x02 dlen 680
      Channel: 72 len 676 ctrl 0x0202 [PSM 4103 mode Enhanced Retransmission (0x03)] {chan 8}
      I-frame: Unsegmented TxSeq 1 ReqSeq 2
  < ACL Data TX: Handle 11 flags 0x00 dlen 13
      Channel: 14608 len 9 ctrl 0x0204 [PSM 4103 mode Enhanced Retransmission (0x03)] {chan 8}
      I-frame: Unsegmented TxSeq 2 ReqSeq 2
  > ACL Data RX: Handle 11 flags 0x02 dlen 680
      Channel: 72 len 676 ctrl 0x0304 [PSM 4103 mode Enhanced Retransmission (0x03)] {chan 8}
      I-frame: Unsegmented TxSeq 2 ReqSeq 3

The MTUs are negotiated for each direction. In this traces 32767 for
iPhone->localhost and no MTU for localhost->iPhone, which based on
'4.4 L2CAP_CONFIGURATION_REQ' (Core specification v5.4, Vol. 3, Part
A):

  The only parameters that should be included in the
  L2CAP_CONFIGURATION_REQ packet are those that require different
  values than the default or previously agreed values.
  ...
  Any missing configuration parameters are assumed to have their
  most recently explicitly or implicitly accepted values.

and '5.1 Maximum transmission unit (MTU)':

  If the remote device sends a positive L2CAP_CONFIGURATION_RSP
  packet it should include the actual MTU to be used on this channel
  for traffic flowing into the local device.
  ...
  The default value is 672 octets.

is set by BlueZ to 672 bytes.

It seems that the iPhone used the lowest negotiated value to transfer
data to the localhost instead of the negotiated one for the incoming
direction.

This could be fixed by using the MTU negotiated for the other
direction, if exists, in the L2CAP_CONFIGURATION_RSP.
This allows to use segmented packets as in the following traces:

  < ACL Data TX: Handle 11 flags 0x00 dlen 12
        L2CAP: Connection Request (0x02) ident 22 len 4
          PSM: 4103 (0x1007)
          Source CID: 72
  < ACL Data TX: Handle 11 flags 0x00 dlen 27
        L2CAP: Configure Request (0x04) ident 24 len 19
          Destination CID: 2832
          Flags: 0x0000
          Option: Maximum Transmission Unit (0x01) [mandatory]
            MTU: 32767
          Option: Retransmission and Flow Control (0x04) [mandatory]
            Mode: Enhanced Retransmission (0x03)
            TX window size: 63
            Max transmit: 3
            Retransmission timeout: 2000
            Monitor timeout: 12000
            Maximum PDU size: 1009
  > ACL Data RX: Handle 11 flags 0x02 dlen 26
        L2CAP: Configure Request (0x04) ident 15 len 18
          Destination CID: 72
          Flags: 0x0000
          Option: Retransmission and Flow Control (0x04) [mandatory]
            Mode: Enhanced Retransmission (0x03)
            TX window size: 32
            Max transmit: 255
            Retransmission timeout: 0
            Monitor timeout: 0
            Maximum PDU size: 65527
          Option: Frame Check Sequence (0x05) [mandatory]
            FCS: 16-bit FCS (0x01)
  < ACL Data TX: Handle 11 flags 0x00 dlen 29
        L2CAP: Configure Response (0x05) ident 15 len 21
          Source CID: 2832
          Flags: 0x0000
          Result: Success (0x0000)
          Option: Maximum Transmission Unit (0x01) [mandatory]
            MTU: 32767
          Option: Retransmission and Flow Control (0x04) [mandatory]
            Mode: Enhanced Retransmission (0x03)
            TX window size: 32
            Max transmit: 255
            Retransmission timeout: 2000
            Monitor timeout: 12000
            Maximum PDU size: 1009
  > ACL Data RX: Handle 11 flags 0x02 dlen 32
        L2CAP: Configure Response (0x05) ident 24 len 24
          Source CID: 72
          Flags: 0x0000
          Result: Success (0x0000)
          Option: Maximum Transmission Unit (0x01) [mandatory]
            MTU: 32767
          Option: Retransmission and Flow Control (0x04) [mandatory]
            Mode: Enhanced Retransmission (0x03)
            TX window size: 63
            Max transmit: 3
            Retransmission timeout: 2000
            Monitor timeout: 12000
            Maximum PDU size: 1009
          Option: Frame Check Sequence (0x05) [mandatory]
            FCS: 16-bit FCS (0x01)
  ...
  > ACL Data RX: Handle 11 flags 0x02 dlen 1009
        Channel: 72 len 1005 ctrl 0x4202 [PSM 4103 mode Enhanced Retransmission (0x03)] {chan 8}
        I-frame: Start (len 21884) TxSeq 1 ReqSeq 2
  > ACL Data RX: Handle 11 flags 0x02 dlen 1009
        Channel: 72 len 1005 ctrl 0xc204 [PSM 4103 mode Enhanced Retransmission (0x03)] {chan 8}
        I-frame: Continuation TxSeq 2 ReqSeq 2

This has been tested with kernel 5.4 and BlueZ 5.77.

Cc: stable@vger.kernel.org
Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3571,7 +3571,7 @@ static int l2cap_parse_conf_req(struct l
 	struct l2cap_conf_rfc rfc = { .mode = L2CAP_MODE_BASIC };
 	struct l2cap_conf_efs efs;
 	u8 remote_efs = 0;
-	u16 mtu = L2CAP_DEFAULT_MTU;
+	u16 mtu = 0;
 	u16 result = L2CAP_CONF_SUCCESS;
 	u16 size;
 
@@ -3682,6 +3682,13 @@ done:
 		/* Configure output options and let the other side know
 		 * which ones we don't like. */
 
+		/* If MTU is not provided in configure request, use the most recently
+		 * explicitly or implicitly accepted value for the other direction,
+		 * or the default value.
+		 */
+		if (mtu == 0)
+			mtu = chan->imtu ? chan->imtu : L2CAP_DEFAULT_MTU;
+
 		if (mtu < L2CAP_DEFAULT_MIN_MTU)
 			result = L2CAP_CONF_UNACCEPT;
 		else {


