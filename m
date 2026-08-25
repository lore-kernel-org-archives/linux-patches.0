Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27FF47143A;
	Tue, 25 Aug 2026 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665464; cv=none; b=jnMHoQSBZey85GCps67+IATHNydbaHYNpd3eNhJkNlOy8ccytC3DYB0DzJUddAVjqjdH6fNwx6ksEXtrir1P8pd1bwF/kZ6ckTACXSyFkc5eMGqIbzBYqWg8dcVWZNpn7smkiInpMNhWh9xqP6/rgVz0dYp9lugOyKrgV3BjfeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665464; c=relaxed/simple;
	bh=hKXS/VynehjzLhpRpCRUzgRUsUbJVy7Jn0MqWakhJeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azHG+jaHbOY3I7Rx+H78y7HuSYmdpZvpzVJHkgBXyvCHSa06beJcp3ethQheU/LygKjc7AxCrs7z3CeGQiunAN8+mqvZR5GbAV2Ij8DeDSM/mNuGtS3eSJEBo6C2o+BQ4kCo629ynI94A4LLlmMzTzahPip0jNpeKB6/OtwOSF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfLdEh4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfLdEh4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154901F00A3A;
	Tue, 25 Aug 2026 13:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665463;
	bh=Iz0vQtoQyOClMKd5i6SkGRhJD8tTn3I+2dwgNI7i9QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfLdEh4KAG3uv7p2NUsiBCpLLkd6BYBRK5ZzOadRrmlwCcLCWkAAgBsH5U1aGOK1O
	 gkdIZ30CnJj2kpvTY6iVj6MkP8exJgDs/F2djYyLK9lqtmYI6b+/pzoz6bZbQXBPGV
	 sJs1znIATPurG0W0uMZRaXBusjXsxgwHCqBoFuNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.12 34/77] nfc: digital: clamp SENSF_RES length to the destination buffer
Date: Tue, 25 Aug 2026 15:25:56 +0200
Message-ID: <20260825132542.897007602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 344a56d7c8e0f3cbaff0bcb1bcd95a1a1db24b16 upstream.

digital_in_recv_sensf_res() memcpy()s resp->len bytes from a remote
NFC-F device response into the NFC_SENSF_RES_MAXSIZE-byte target.sensf_res
field without an upper-bound check. A nearby malicious NFC-F device can
send an oversized SENSF_RES response to overflow the stack-local struct
nfc_target.

Clamp resp->len to NFC_SENSF_RES_MAXSIZE before the copy.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 8c0695e4998d ("NFC Digital: Add NFC-F technology support")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260603141355.68156-1-doruk@0sec.ai
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/digital_technology.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/digital_technology.c
+++ b/net/nfc/digital_technology.c
@@ -778,6 +778,8 @@ static void digital_in_recv_sensf_res(st
 
 	sensf_res = (struct digital_sensf_res *)resp->data;
 
+	resp->len = min_t(unsigned int, resp->len, NFC_SENSF_RES_MAXSIZE);
+
 	memcpy(target.sensf_res, sensf_res, resp->len);
 	target.sensf_res_len = resp->len;
 


