Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA18368D40;
	Tue, 21 Jul 2026 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662160; cv=none; b=HhfCcRrmDiomosMM9GtW6zZ3NfS0ssP66WVgKqcGpFBZ8X3XCOf3xrqQ5sQJuowjA+z+8eP6U8He6QqHRNtwiHHPCCMH+8O8Oq2btF/hRAIOpZmMjVJY0kZHnYC7BOfChSQci9Qd00Nq6BlG3S0pIDaUa6ymy7C/0R6vLff9AJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662160; c=relaxed/simple;
	bh=V+LBmOrjRGko6LkdY7Mcnptyclz9A3AnVQizRqJ1exQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKYGPCOA4ExzkPXralf3tRn1OtLA/dJakmRZAR7xIuePSUlvBl5YulNvrU9GpeUaEhTzBUWRDqm3PNRTIttDXz3YwaWyFgJYDMGn6Bld0ZQsT/hyWH0EBgsOi49YBfLHx+SsRZTY8G5GI47+ove4cNlT3DAVFK4lwlB83GIP/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pr6r73j5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pr6r73j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A241F000E9;
	Tue, 21 Jul 2026 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662158;
	bh=unZPg4PQkV8gEz/XJ+BUetBKWNhj7UWBcSFp8O4J88E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pr6r73j513BR22UYVmFOeeDgnXL5vdI/1f6hx3sXSgnDEYJH/1Gmbe8VSCeFhBqVk
	 8JGOtLM8Z9ZNshFlMZWsKKCAoeEo3auyq9EL83AvPAW4zXsoNep9lYtt7p3AgOjpf9
	 Vp6iPMvAKq9V4HZ58FM2TlEYq2jNuFkaN/u47x8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0322/1276] Bluetooth: hci: validate codec capability element length
Date: Tue, 21 Jul 2026 17:12:45 +0200
Message-ID: <20260721152453.301327992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



