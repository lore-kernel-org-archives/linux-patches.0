Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5142820AC;
	Wed, 23 Apr 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420824; cv=none; b=RO+NoTtZZsYnPKfTX5WYxBwIrr8yQxKmg2xRe2yjtRtshfhVcNx1o4V741QuEbFfRg8Px/ZDhSiBLWXfPQwxgbF6k2Ksqz3tBDAHnMEpCvIhuJK2SeRDKIcMDFCSsJReFMsr49tkycySgWYhdgTbaDQpyc5Hc3sEBn4l7avyD7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420824; c=relaxed/simple;
	bh=W8UKKBB1p5BrN+6ucTVl9odEzue0RfWF6FzQzLS2Va8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjoDVSyWRyg0SOuwe8C9RxMFuFkbRyEkcFkK9msiwAfS/lyRSeauEdP88NAVdUMvjrDH+3xDfPLd1Y/SdiP6dB1Pis9vcONzYlNR5Y2mM6B2AHQvnHPS5FT8xYiPTQipLKHXUj7/CtbAUaziW2Kfzh6RGamPaljpUC1ODFoNb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lG3uIIg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lG3uIIg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF5AC4CEEB;
	Wed, 23 Apr 2025 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420824;
	bh=W8UKKBB1p5BrN+6ucTVl9odEzue0RfWF6FzQzLS2Va8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lG3uIIg/jbd1RMymemJzeU1+y5NT7tx+Rw8SQyBDaXrD8JvTwWXt13u9hkyqem7hw
	 IEwR21gPUEP5+w/Z1Xee365YJjKcvE8wncpUdh7Z6BPMjQU4s726hsNJAmQUBHj+V1
	 3XbVoFWiDcaTXqefMxlEWCPbJG8WF+wjgfrfigTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.14 125/241] Bluetooth: l2cap: Process valid commands in too long frame
Date: Wed, 23 Apr 2025 16:43:09 +0200
Message-ID: <20250423142625.679659192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

commit e2e49e214145a8f6ece6ecd52fec63ebc2b27ce9 upstream.

This is required for passing PTS test cases:
- L2CAP/COS/CED/BI-14-C
  Multiple Signaling Command in one PDU, Data Truncated, BR/EDR,
  Connection Request
- L2CAP/COS/CED/BI-15-C
  Multiple Signaling Command in one PDU, Data Truncated, BR/EDR,
  Disconnection Request

The test procedure defined in L2CAP.TS.p39 for both tests is:
1. The Lower Tester sends a C-frame to the IUT with PDU Length set
   to 8 and Channel ID set to the correct signaling channel for the
   logical link. The Information payload contains one L2CAP_ECHO_REQ
   packet with Data Length set to 0 with 0 octets of echo data and
   one command packet and Data Length set as specified in Table 4.6
   and the correct command data.
2. The IUT sends an L2CAP_ECHO_RSP PDU to the Lower Tester.
3. Perform alternative 3A, 3B, 3C, or 3D depending on the IUT’s
   response.
   Alternative 3A (IUT terminates the link):
     3A.1 The IUT terminates the link.
     3A.2 The test ends with a Pass verdict.
   Alternative 3B (IUT discards the frame):
     3B.1 The IUT does not send a reply to the Lower Tester.
   Alternative 3C (IUT rejects PDU):
     3C.1 The IUT sends an L2CAP_COMMAND_REJECT_RSP PDU to the
          Lower Tester.
   Alternative 3D (Any other IUT response):
     3D.1 The Upper Tester issues a warning and the test ends.
4. The Lower Tester sends a C-frame to the IUT with PDU Length set
   to 4 and Channel ID set to the correct signaling channel for the
   logical link. The Information payload contains Data Length set to
   0 with an L2CAP_ECHO_REQ packet with 0 octets of echo data.
5. The IUT sends an L2CAP_ECHO_RSP PDU to the Lower Tester.

With expected outcome:
  In Steps 2 and 5, the IUT responds with an L2CAP_ECHO_RSP.
  In Step 3A.1, the IUT terminates the link.
  In Step 3B.1, the IUT does not send a reply to the Lower Tester.
  In Step 3C.1, the IUT rejects the PDU.
  In Step 3D.1, the IUT sends any valid response.

Currently PTS fails with the following logs:
  Failed to receive ECHO RESPONSE.

And HCI logs:
> ACL Data RX: Handle 11 flags 0x02 dlen 20
      L2CAP: Information Response (0x0b) ident 2 len 12
        Type: Fixed channels supported (0x0003)
        Result: Success (0x0000)
        Channels: 0x000000000000002e
          L2CAP Signaling (BR/EDR)
          Connectionless reception
          AMP Manager Protocol
          L2CAP Signaling (LE)
> ACL Data RX: Handle 11 flags 0x02 dlen 13
        frame too long
        08 01 00 00 08 02 01 00 aa                       .........

Cc: stable@vger.kernel.org
Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7504,8 +7504,24 @@ void l2cap_recv_acldata(struct hci_conn
 		if (skb->len > len) {
 			BT_ERR("Frame is too long (len %u, expected len %d)",
 			       skb->len, len);
+			/* PTS test cases L2CAP/COS/CED/BI-14-C and BI-15-C
+			 * (Multiple Signaling Command in one PDU, Data
+			 * Truncated, BR/EDR) send a C-frame to the IUT with
+			 * PDU Length set to 8 and Channel ID set to the
+			 * correct signaling channel for the logical link.
+			 * The Information payload contains one L2CAP_ECHO_REQ
+			 * packet with Data Length set to 0 with 0 octets of
+			 * echo data and one invalid command packet due to
+			 * data truncated in PDU but present in HCI packet.
+			 *
+			 * Shorter the socket buffer to the PDU length to
+			 * allow to process valid commands from the PDU before
+			 * setting the socket unreliable.
+			 */
+			skb->len = len;
+			l2cap_recv_frame(conn, skb);
 			l2cap_conn_unreliable(conn, ECOMM);
-			goto drop;
+			goto unlock;
 		}
 
 		/* Append fragment into frame (with header) */


