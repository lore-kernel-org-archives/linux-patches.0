Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72431511E96;
	Wed, 30 Sep 2026 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782783; cv=none; b=g9elWG9x4e/Qwt7QRFc1FyJlv/VyBrAhKrdaPz4ZojCJAqdXT405NICpYGmYf+sESvS9L2kB1Z3yyoDlfWiU1IfBsYLUsNJlhJ3mkq64vlZ1A6dc/jcBscKcZCPGb1Dx8/RTOA5YFTSmLKE2TE+I0NTlNO6CUmjV8DBgLy6ugKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782783; c=relaxed/simple;
	bh=BGULv7p0JCzt/6Na6WR1bFg2EWiznPg2kKQdWSyV70k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dU3+CCFm9H6wuVIK3YLMOR3cgRHQ7Ph8qLaj8rfNj33B17LXBtawXV/KMwjKQD5vdpZ3Iq98kQZZPviONDJksRykLhQDskAIIevrZKBn5491xhyHF97kDe5kwyl9m2LlbzugJYyyk79AZGtgcrSUN8WhVOAFez1+weZYSNdNeS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvAw4OsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvAw4OsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7931F00893;
	Wed, 30 Sep 2026 15:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782774;
	bh=PIpG8seWZ0mDidS7IIaeFu6rnOaDZ27I/WpHouScbPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvAw4OsPEivFsg3mQw9se1mSPOCS4iJSkq6EQFVmrXq7HipqrAYC4pxHvrj7e6u4E
	 ANpEn65qeUTOIn1J/MNWQDYsOnw51segXMp/eaSbrh8cfvXL086rTWRHmxesu8rE2I
	 /myGErAdEAP6VAjH7Rm5JqTjE49m6LW5wvadMYVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/595] Bluetooth: L2CAP: validate connectionless PSM length
Date: Wed, 30 Sep 2026 17:20:13 +0200
Message-ID: <20260930152350.321095699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit a40a5f922546b3bd7c094d882b29177db4f2abe0 ]

Connectionless L2CAP frames carry a two-byte PSM at the start of the
payload.  l2cap_recv_frame() currently reads that PSM unconditionally
after validating only the outer L2CAP length.

A malformed connectionless frame with a zero- or one-byte payload can
therefore make the parser read beyond the advertised skb payload and use
tailroom bytes as part of the PSM.  A VHCI-backed QEMU reproducer
injected a one-byte connectionless payload and reached the unchecked
read.

Reject connectionless frames that cannot contain the PSM before reading
or pulling it.  This preserves all valid connectionless frames while
dropping only structurally incomplete packets.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1122566c4b500..b9031c92f99c7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8106,6 +8106,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
 		break;
 
 	case L2CAP_CID_CONN_LESS:
+		if (skb->len < L2CAP_PSMLEN_SIZE) {
+			kfree_skb(skb);
+			break;
+		}
+
 		psm = get_unaligned((__le16 *) skb->data);
 		skb_pull(skb, L2CAP_PSMLEN_SIZE);
 		l2cap_conless_channel(conn, psm, skb);
-- 
2.53.0



