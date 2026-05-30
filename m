Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66DE39478D;
	Sat, 30 May 2026 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162775; cv=none; b=KJgx5AT9SFO/Wp5W5q6GtyPH5k35QDTgYq4gctgh/TFkxrOsrjlfirKkeRq38bw5Y4zafEDP3a6LqsoE+DBtdXP9puDPQ/cwW8D9p4oquVLeCqDYf5nNiLQulS9WKHYLpI6n4+j14o2dIfo/KGM97LcwycfHp3BS7hwdkOL0lpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162775; c=relaxed/simple;
	bh=XY3tIEQ4uKsI9m74MnNTOO8ekmdUKcusuGG3JUUpmL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEm9bBOFN6PRxVbA8x2MAjOfAE7la/5gTjVVtd2rcQTxohU3J985U/r1c3zKnYksZaToKHvVxuIK+JORswCEyATBYD773dgRSUgNZd+smZsCvHXjG/pGhvCXgTkC8PHjmV83xv87xaRLH6F7BzvKurZ7aCKodFre3kg0QllZfA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4xT/e9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4xT/e9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C771F00893;
	Sat, 30 May 2026 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162774;
	bh=kv7uZNX6+/Rk1wkXgCfS2SVEvNNScNSs3Nz+T8kceDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4xT/e9fxsJfiwoENo+SokxWJjcxFweDPpH2gpwt0SJzwNjHKeDjv0bHJQa+/t8U8
	 ZKkMixQLzWlDtQ9n4StsyhitN0E77EsAjxqM/bx2xTSEP02gvQ9dsxAIx9Jlr94AfY
	 TEQvJ4Rqe8RE1Si92CqV90CoU8DFS9OPRLsGLwjM=
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
Subject: [PATCH 5.15 059/776] NFC: digital: Bounds check NFC-A cascade depth in SDD response handler
Date: Sat, 30 May 2026 17:56:13 +0200
Message-ID: <20260530160241.841130989@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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


