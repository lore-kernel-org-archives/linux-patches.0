Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5191522EE6;
	Wed, 30 Sep 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790978; cv=none; b=g8DPSH+5QuCktF8GQDSMHq8xcLIahDMqxH7OC/FcsdkRkc8R/8WlXgAjIywXS85LLAhVOQpiOY+6k80zsRbcY1WfPtXPhlJw84EergCEmY8hMczeLs2hr+r0yirMP+sJKsXf+yoWsGfeO/lRw+kHK9WDHFAGYKGRQR9d6PyCtyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790978; c=relaxed/simple;
	bh=ACtG1F1A1FzJRiuDOHF00TeZJo2ZDzA32NDu/WQshv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/wHAobMObNJ8S6gVO+OPJ7TcwvDuNNbT9uq+VRFxAwnfw/2ZFIMY97xKEjmC/a2BK39pfS7bEwLzf7ooxlC7CtigNQ1EX3+Qitw8IPrAB2iRzrv9LPVbtO88A808/TVDGddA9OGyg3l0B/4IPvQjr/BkwefCUxqXVbU3K7j4d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ant/5Slm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ant/5Slm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF281F000FF;
	Wed, 30 Sep 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790977;
	bh=1xh14zGsRjVxZfmkdPZGUbmIEEygnkkbZLZoYtfDDtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ant/5SlmpqDX6/oK30v30JbdXQ1Bp228kT2cWl7ftpCCUlaLousGLfHOabqIrsfy0
	 FqHUrUNZckbS5VCHj6ye/4CM40k3Q8aYbiJbPzYYWcN1wLXeJfNJHmm0c1KCvAhUZI
	 IffKtWMHrWv2Zy9JmcSLpCcsOTh4UvHy+eYEE9gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/752] Bluetooth: L2CAP: validate connectionless PSM length
Date: Wed, 30 Sep 2026 17:20:12 +0200
Message-ID: <20260930152401.250998960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 34f89f7f993be..b469464f78eb6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8054,6 +8054,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
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



