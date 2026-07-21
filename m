Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5663B3C0A;
	Tue, 21 Jul 2026 20:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666228; cv=none; b=NbOVT1ZO3Sf5dWHml+XOanxwi1T0lH5wlNalujH7b1h6dwAGHxjnckADGkA5eZ5XoVqRX023fZ6JzQ1B2az33IJnzAjVR1D45RjAcqfLuRKYSry48w10peUOxjzoVjyU/G6LmdUyNh4nTUPuSQTtXKLQwr8gaPuuWfeeNUqKg9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666228; c=relaxed/simple;
	bh=ThgaAT8pGLxl6Rxa67e2b1K3iU8XOix+C8BbbcnhV0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk0TG4UUBq6bkY5U0DBmvHlBy7+UDqIXROyoXej896cciltifOz9XLDwduyOp0CHZZOPpOpHDKaDKhPLVoMMgxudMwYPVodm+xhyxe3S4Uiub6OcFq7n37NWoV3HbqPcER7fexPnt1dZREurhWD5paKF5fwQSmMY1P7arRw/fc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDO/nfGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDO/nfGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7DD1F000E9;
	Tue, 21 Jul 2026 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666227;
	bh=43HuLrLRd6nfdDFFPSMJdxd4+RiNKOVQQTpSJ2ynzAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDO/nfGP2O7nz43dKAgHbCILocTgijM2k7ojypuvnFfIry1PMRbEWvU1Zdl+dOf4X
	 yg4hx/+9dt1YEXLRDAwStcfL2z54IYVYMr+15yxNloVMh36cUDRhzRRz5878hPijZ1
	 h+nTDcBe+JNPrHK/K0JOOCE0+QEPXQty43f8zJHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0550/1266] Bluetooth: hci: validate codec capability element length
Date: Tue, 21 Jul 2026 17:16:27 +0200
Message-ID: <20260721152454.174580609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



