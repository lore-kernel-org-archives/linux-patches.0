Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F85217704;
	Sat, 30 May 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165344; cv=none; b=MiH39xSyIyad4GU1/Kcl5cfECJZfb6jl2F3vSCy2/3LAmaE9bSh8klzG93e4qCI3ytIgzYnNoh3xdfBY9DjGaDjru1tPRyBt31GRR1geoGgsV3hZJkb2nO0Jx4ovpuZ8dm0MG4wAEDsKVxmNfQJnoEUd9azHBl6l7dprQJHk6gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165344; c=relaxed/simple;
	bh=v/hK87NwVpJ8UpPmuf7LuVJ2XrBD3lHhKxOj9ZqSwww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSafG2etvtCPQL9U2x6Q3poSaAkzYM0hm0WgYrSOBRGMW9MRDPFU7ReToBRYnIBQyYEOdypcd+yzIr7HpU3iFxeC6cgrB9JXgPb2U9RaAvORwyxRPeIVto7q8CFgGc6tJYCWLRORkkYNJ5Y6FPHYZlgvQR3AO/r94rOsLdr3NsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3zn+3q4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3zn+3q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132221F00893;
	Sat, 30 May 2026 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165343;
	bh=/wVRaw3IklSJu5RStWUFCQN/3+wQZNBMBPhAOdrYdpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3zn+3q4oDnlEgMKx/R68M+/3uFbXETH1MaWVLwJUVO2B9gSFj1UIar4OEmYSZDS5
	 TGGtKoWabLtXtB8viIo0ighbxbpXKEqVhZsJaT3wPP03jnEw/2PewAc692JX8yHLQM
	 OLFE2quYB2Fv54dMZON6+G9W8Q7McSgpdQx3ZTFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	stable <stable@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 050/589] NFC: digital: Bounds check NFC-A cascade depth in SDD response handler
Date: Sat, 30 May 2026 17:58:51 +0200
Message-ID: <20260530160225.906268473@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 46ce8be2ced389bccd84bcc04a12cf2f4d0c22d1 upstream.

The NFC-A anti-collision cascade in digital_in_recv_sdd_res() appends 3
or 4 bytes to target->nfcid1 on each round, but the number of cascade
rounds is controlled entirely by the peer device.  The peer sets the
cascade tag in the SDD_RES (deciding 3 vs 4 bytes) and the
cascade-incomplete bit in the SEL_RES (deciding whether another round
follows).

ISO 14443-3 limits NFC-A to three cascade levels and target->nfcid1 is
sized accordingly (NFC_NFCID1_MAXSIZE = 10), but nothing in the driver
actually enforces this.  This means a malicious peer can keep the
cascade running, writing past the heap-allocated nfc_target with each
round.

Fix this by rejecting the response when the accumulated UID would exceed
the buffer.

Commit e329e71013c9 ("NFC: nci: Bounds check struct nfc_target arrays")
fixed similar missing checks against the same field on the NCI path.

Cc: Simon Horman <horms@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Thierry Escande <thierry.escande@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Fixes: 2c66daecc409 ("NFC Digital: Add NFC-A technology support")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026040913-figure-seducing-bd3f@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/digital_technology.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -424,6 +424,12 @@ static void digital_in_recv_sdd_res(stru
 		size = 4;
 	}
 
+	if (target->nfcid1_len + size > NFC_NFCID1_MAXSIZE) {
+		PROTOCOL_ERR("4.7.2.1");
+		rc = -EPROTO;
+		goto exit;
+	}
+
 	memcpy(target->nfcid1 + target->nfcid1_len, sdd_res->nfcid1 + offset,
 	       size);
 	target->nfcid1_len += size;


