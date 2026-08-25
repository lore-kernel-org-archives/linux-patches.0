Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED32A446C18;
	Tue, 25 Aug 2026 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666175; cv=none; b=UMOhjDmk0jfWUnu4Euqz3IxH5HTUH8G3V97jEOdG+4ct+xK/zwKrWTcaY+7i1rm9fIUx33YjVh6qdcqWIJ7GCBpeax7A6r0grOiholZhMhCWG2xLtxdzBpuKMK2bKBu8e3j0FiaupTEhgsamJiHw9DbWNlQr7cZR4Wdoy1o9MWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666175; c=relaxed/simple;
	bh=1wXhW+4QqnJDjEVNRv2MW8GiIOH+1a+qIGAJKFzuBKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3cCt1a1z9Hj94c80X2Sg9/Gm4pIVWssyG0Mi8Se1GlA888+PL22+zesfzoaiNm8/lhnp39nihhK4lisesyMVnGTv6Q2gk6gHigUT6W66XHriPMKkTiIVlhUiSyfHF5u9cCMkiR1fxNgyo+2bQOkTdMENyaL7EV4r6Ug9NQ3koE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHZ3ZK0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHZ3ZK0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1A61F000E9;
	Tue, 25 Aug 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666173;
	bh=RYzxRxNs8zOcOz5c6lzHyPYf4EmJAQFXHYE6+nJDlpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHZ3ZK0mgALi82TpHyqhinnrvwkdiUtEdk9FhqgmpPorIH/fd4pe2QvkJWCQILI2J
	 hoNpzxBcYudJwUj44JEwSy5KeaDBmKb5aKX7/gnay7RCmEBXPoV5fN1UwnVPfBQyty
	 6TgwkZIweHa0mmZPNwR1eoSrAZL5ioe+GSOQqABU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 29/76] nfc: digital: clamp SENSF_RES length to the destination buffer
Date: Tue, 25 Aug 2026 15:26:22 +0200
Message-ID: <20260825132542.702911801@linuxfoundation.org>
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
 


