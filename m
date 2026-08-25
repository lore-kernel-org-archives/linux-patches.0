Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE373D9547;
	Tue, 25 Aug 2026 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666192; cv=none; b=h4Gm4bJSMb6vpzy4A+CZd6Y51WQ8Om8xlOVlgsFsefHpbFC3+NQbOe+5q5KbhInFrclIHBhYqG1CMjnWO/tG686bUGFMG9omJegOcHxA9vPBHQekbbKwDOZI/IENfxHqNj5ZV2KXEu/NKD8RttryaUwcP25ZVfYhldHqWZyKeJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666192; c=relaxed/simple;
	bh=JLGs+XxyOmujtcA11Ipgq0emsVGOsavZCHE/QCoGK3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dW+qtCEc/ThUAwkWWxnnfvr6fgBehyCcsiS8YWGDfutKlCPw+5gm9Zt+U5uCacm0g79hXCXtuE5zH2nSx/O/bgdo+fbCxqIgmZZPtKy/+MuiGlAMQDGz+5GRITPtbzIfi1+ElVheKeuLCW+b9JYu0Sal3a5cj/+wE59mkiPtsp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9STSUol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9STSUol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6CD1F000E9;
	Tue, 25 Aug 2026 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666191;
	bh=J8Z0TdKU39Ez+wLngs+dGM71veiEOQvmKX8z3Z5MPqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9STSUolJ8v12YVIqIhQE3W2nCFwDaoo5Bvt+qgXo10dUcqYSJSlVoN0weacudnQz
	 6kdQ3EhSGuS4wZMrU0/89LtgDv/AO3PvR4is4En1OXVeGrYusupmlSNHzqkJudJaCW
	 py5DMExlSZoOl/8Z5+qiEEPAMENpwF/7I08YH7UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 34/76] nfc: llcp: reject PDUs shorter than the LLCP header
Date: Tue, 25 Aug 2026 15:26:27 +0200
Message-ID: <20260825132542.895306331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 95674f506c6376d6722a23144c9acd26609771ed upstream.

Every LLCP PDU begins with a two-byte header (DSAP/SSAP + PTYPE), but the
receive path never checked that a frame is at least LLCP_HEADER_SIZE bytes
before parsing it.

nfc_llcp_rx_skb() reads the header via nfc_llcp_ptype()/nfc_llcp_dsap()/
nfc_llcp_ssap(), which dereference pdu->data[0] and pdu->data[1], and a
CONNECT or CC PDU then computes

	tlv_array_len = skb->len - LLCP_HEADER_SIZE;

as a size_t and hands it to the TLV walk. When the frame is shorter than
the header the subtraction wraps to a huge value and the walk runs far
past the buffer, an out-of-bounds read.

A nearby NFC device can reach this without authentication; LLCP link
activation happens automatically after NFC-DEP.

Guard the common receive choke point __nfc_llcp_recv(), shared by both the
target (nfc_llcp_data_received()) and initiator (nfc_llcp_recv()) paths, so
a short skb is dropped before the rx_work worker parses it. Use
pskb_may_pull() rather than a skb->len test so the two header bytes are
guaranteed to sit in the skb linear area even for a non-linear skb,
matching how the sibling NCI and HCI receive paths validate their headers.

Reproduced with a KFENCE out-of-bounds read via /dev/virtual_nci on
linux-next.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: stable@vger.kernel.org
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260714164631.75068-1-doruk@0sec.ai
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1561,6 +1561,11 @@ static void nfc_llcp_rx_work(struct work
 
 static void __nfc_llcp_recv(struct nfc_llcp_local *local, struct sk_buff *skb)
 {
+	if (!pskb_may_pull(skb, LLCP_HEADER_SIZE)) {
+		kfree_skb(skb);
+		return;
+	}
+
 	local->rx_pending = skb;
 	del_timer(&local->link_timer);
 	schedule_work(&local->rx_work);


