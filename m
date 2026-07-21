Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFF347013D;
	Tue, 21 Jul 2026 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656775; cv=none; b=nCJeJAeISAQU/aO4C/Ph7MVD82K95BzvM1CRGOe0oJHSMNhKqkbNRkyLmol1YG2zzT71b/20/9Qa5qvPZipOWnilDHupnQualn7IBziKbTgeoxWaBxPOaSzXEpVlwMAdRdqU4m0sA1Y+pM8srZq/0u1b6Hbfr8GpNCxVk5erIYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656775; c=relaxed/simple;
	bh=0c5eqFecRM+31I43m1npbuuvTYWWB8SE5kNQnatQhNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9bM8Oav566CPNHRb8Q8T9IAjWdwrn3oPn/qVHnTpl/4IrpDUiPSVOMUZGd3yx8Y1toS+KbE3BPUbpSA5j/8N+IVC2lRyU2E74YS+yya92805HPBX8tR2vTAWwQ+C6CZgUu/VdgGKH/NktlozSVgLJTDQanjZBKgYWgfjGg0IsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6V6B8Lk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6V6B8Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D6E1F000E9;
	Tue, 21 Jul 2026 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656774;
	bh=k5NYGvAO5kttfAyDe2W5Ivun08OxYZsIWQVazp0ANYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6V6B8Lkv4/QotN615Gyzttt2opMVn8qo3qI0keBObwZtwr7zmpQB0sAIeakZP3sC
	 1U2X3hH7P2yxnNEnemzVw02kQqgONocSwr0Csw7HaHBK/zHw0JtQRVknbB+Ll2naIr
	 tim4wDh/lH3r0RxUBFNYGqqUSXCz66iZKQxcCUGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0470/1611] Bluetooth: hci: validate codec capability element length
Date: Tue, 21 Jul 2026 17:09:46 +0200
Message-ID: <20260721152525.893011216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit c38fbcdc407925c7088f7e5f11c1fff73d2d35a2 ]

Read Local Codec Capabilities returns a sequence of capability elements.
Each element starts with a one-byte length followed by that many payload
bytes.

hci_read_codec_capabilities() checks that the skb contains the length
byte, but then validates only caps->len against the remaining skb
length.  A malformed controller response with one remaining byte and
caps->len set to one passes that check even though the element needs two
bytes.  The parser then records a two-byte capability and copies one
byte beyond the advertised response payload into the codec list.

Validate the full element size, including the length byte, before adding
it to the accumulated capability length.  This preserves all well-formed
capability elements and drops only truncated controller responses.

Fixes: 8961987f3f5f ("Bluetooth: Enumerate local supported codec and cache details")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_codec.c b/net/bluetooth/hci_codec.c
index 3cc135bb1d30ca..5bc5003c387c66 100644
--- a/net/bluetooth/hci_codec.c
+++ b/net/bluetooth/hci_codec.c
@@ -100,7 +100,7 @@ static void hci_read_codec_capabilities(struct hci_dev *hdev, __u8 transport,
 				caps = (void *)skb->data;
 				if (skb->len < sizeof(*caps))
 					goto error;
-				if (skb->len < caps->len)
+				if (skb->len < sizeof(caps->len) + caps->len)
 					goto error;
 				len += sizeof(caps->len) + caps->len;
 				skb_pull(skb,  sizeof(caps->len) + caps->len);
-- 
2.53.0



