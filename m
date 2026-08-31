Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6C94EBAEF;
	Mon, 31 Aug 2026 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183630; cv=none; b=XWrfTSUFcxHSGjaiA1dFel5clolSeLKv3tJFrximQIPwaqTasgxrOIh6Mqac1xpSy2KL4/Qt8YsnjxE2Vry00rY+CbaD9U2/XR7/iwu2BQDlrFNm2pcGwbSLcRVd62CvxDmpM1FqcXg3DSLOr86d/WEJ7LJUu1YFbCRvlTJE+Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183630; c=relaxed/simple;
	bh=hNr87Kqa8DKvg14Kw28dTNDaw2cFnYnDRQx8gNTGbw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1fT+K1D3dWQZbNWKlaoCXYOifYIu0zp2+L9tYAp6JQQG+yDxDAnH3g9XKfbFfdWZnu6JBCGVlT20/YOmmZkpNzMxw3hGyi33KgCcn5B1x0SseXfs6fdS1c4RNIkk5gCTVVID74vekyZFjG3siYp4A91JJFPe8Y3QNrU8wUwNEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmVa1m2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmVa1m2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3571F00ADE;
	Mon, 31 Aug 2026 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183627;
	bh=JAsaYLnB6f6YFl+J2a9zgmsONfJFwMD11bOzwQv+uZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmVa1m2iqTnzv+xh3lDCDCQr5HtdPN38sy5iym3hkuJOR/LyJgarxIT6lN3xM7gzc
	 7CCZoIzD4QCcOKYYsYJTefCgjvsKgePTtDs8JR6nPaYaBygCzrsn2P96UaMJ6lydYJ
	 P0DxHSSSHGDj3L8PbUTGdzqEi2+39TDK7ncdGV1IS/n7u/AGQFRfzavvD5aLl9+7d8
	 TBC5a2/X/YtGbV0aVPPQFwJoVVwUH5vvzPqs96NZspPoSHo0YIdFByxTotiMagn18G
	 p4WvDg/lLTUUahFyPNsVKzwEy53M/PIU6ATIi0zjVyZck8L5aYmyb9D5dZsPw6pglM
	 SwY4wWG26dvvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] Bluetooth: L2CAP: validate connectionless PSM length
Date: Mon, 31 Aug 2026 09:23:55 -0400
Message-ID: <20260831133314.4125787-207-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background git searches finished: neither `git log --grep="validate
connectionless PSM"` nor `--grep="connectionless PSM length"` found
anything on HEAD, which matches the earlier finding that `a40a5f922546`
is not in the 6.18.44 tree even though the buggy code is still there.

**Verdict for this tree (6.18.44): YES** — backport the 5-line PSM
length check. It fixes a remote-triggerable out-of-bounds read in
connectionless L2CAP handling, applies cleanly, and follows the same
pattern as other L2CAP validation fixes already in this branch.

 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 6133c65b20172..1a38a667ef0b0 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7117,6 +7117,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
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

