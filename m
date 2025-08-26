Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F1517332C;
	Tue, 26 Aug 2025 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207948; cv=none; b=myIWmbeaGyTK4QjsWdXG1NG8Sc5P5L6J1otqrPHvrY+1QAg+7gvZRjGLT10W/sUeRkiEw5DNuX91zcGbDiQZW3RxfPG6KbBIKFzMZj8FXrlfYL/7b/LO/PnohyvqCK0882mWougZf2paMyqXNPfOajz/msZgYMLnchOH6wKhf6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207948; c=relaxed/simple;
	bh=1uaPbzoU54UgtSif61sqB5fWJ6WKhYpPJogx6hPDYN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQW8LnLYmTO3kO5ISTl39+i2NDyEXUHtl4R9Jqn8zkZ8v+ELiTiLeBdBKTH+bm3/eACLavL8yUSVXsd1E2s3Ea0aQIztxLRdUAwk1Y2ypnH/EJoDvD3AkKeDa3eKm0vNRBclakxhUSdLPFVHItLAtPJhvbwZN+OTFzBDsYmE7E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qea9gtOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qea9gtOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3A4C4CEF1;
	Tue, 26 Aug 2025 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207948;
	bh=1uaPbzoU54UgtSif61sqB5fWJ6WKhYpPJogx6hPDYN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qea9gtOymcAtkP1554LF+ZLK3e5vYEVGRtYz70m+zvtnsGr0cCyNCIohjkFwkKoUl
	 XxLkDrZonnbTXmyVqISqufCOm4KeOB3f3Ym+SexY3h0ai8yNT7wgAW+zX8dXqjSiqF
	 JIR5dJ2zoytfHwWiIFHz0sooribqfe8C0O/8YfXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 378/457] Bluetooth: hci_event: fix MTU for BN == 0 in CIS Established
Date: Tue, 26 Aug 2025 13:11:02 +0200
Message-ID: <20250826110946.637786714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 0b3725dbf61b51e7c663834811b3691157ae17d6 ]

BN == 0x00 in CIS Established means no isochronous data for the
corresponding direction (Core v6.1 pp. 2394). In this case SDU MTU
should be 0.

However, the specification does not say the Max_PDU_C_To_P or P_To_C are
then zero.  Intel AX210 in Framed CIS mode sets nonzero Max_PDU for
direction with zero BN.  This causes failure later when we try to LE
Setup ISO Data Path for disabled direction, which is disallowed (Core
v6.1 pp. 2750).

Fix by setting SDU MTU to 0 if BN == 0.

Fixes: 2be22f1941d5f ("Bluetooth: hci_event: Fix parsing of CIS Established Event")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b83995898da0..f93509007e92 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6744,8 +6744,8 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 		qos->ucast.out.latency =
 			DIV_ROUND_CLOSEST(get_unaligned_le24(ev->p_latency),
 					  1000);
-		qos->ucast.in.sdu = le16_to_cpu(ev->c_mtu);
-		qos->ucast.out.sdu = le16_to_cpu(ev->p_mtu);
+		qos->ucast.in.sdu = ev->c_bn ? le16_to_cpu(ev->c_mtu) : 0;
+		qos->ucast.out.sdu = ev->p_bn ? le16_to_cpu(ev->p_mtu) : 0;
 		qos->ucast.in.phy = ev->c_phy;
 		qos->ucast.out.phy = ev->p_phy;
 		break;
@@ -6759,8 +6759,8 @@ static void hci_le_cis_estabilished_evt(struct hci_dev *hdev, void *data,
 		qos->ucast.in.latency =
 			DIV_ROUND_CLOSEST(get_unaligned_le24(ev->p_latency),
 					  1000);
-		qos->ucast.out.sdu = le16_to_cpu(ev->c_mtu);
-		qos->ucast.in.sdu = le16_to_cpu(ev->p_mtu);
+		qos->ucast.out.sdu = ev->c_bn ? le16_to_cpu(ev->c_mtu) : 0;
+		qos->ucast.in.sdu = ev->p_bn ? le16_to_cpu(ev->p_mtu) : 0;
 		qos->ucast.out.phy = ev->c_phy;
 		qos->ucast.in.phy = ev->p_phy;
 		break;
-- 
2.50.1



