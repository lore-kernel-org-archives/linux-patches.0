Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDD34BD348;
	Wed, 30 Sep 2026 16:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784864; cv=none; b=dSACGTvUcMHqXKKl/9ajKa4jpUWY9w0dFLOBjQsqw+w5ElIJTaEdXFoLT8lMbN+y/4zl+TQReWrR0MITJtScYb+9h9w9MFS/Cjk3qI7XqtGo9VHrY1U1qbsSgtTDFXFWm5eaEdijoKH2zJt9jabo82QeQLxLaLMc7RTxXCxg/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784864; c=relaxed/simple;
	bh=4bfdwXdTcDK68tscioERLq1Df2dtUA2qkz0lYV2mSI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HieZ/W5YZWchYC+ldN1upg93dp36TILxxx4cUb+cVLvXMssHqjO1203qQstDlj50ci4z3V6U415aQrxqam8NTarFmrMEif4z57G7msuNVw6Zzz+GXfptOxx81zSTZYn/gytWY0t2IuRvOLfHkhhymFsBSoepgLuLYpTIuAxn6bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6DZ8lkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6DZ8lkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AFF1F00893;
	Wed, 30 Sep 2026 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784852;
	bh=0B2IfMmba4EpF9CgHVeHIYED63kT5z+bIXhqP/XL9q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6DZ8lkM7Lh1MpT3kttLiLcsvN8Yj6YwZzqpdA5PlgUNG0TxSKiIjwogEsJUmDTIs
	 MtVJ1eY6juqd5ziENSISGjrfHRbCKrWxONeoOteVvniudvqwYTfcQ3YwCHCpMuM0mV
	 K+z4L9Rfl/ek8IQGeYdneKmHjx+Slh5bf5XB4XB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 257/982] wifi: libipw: fix key index receive bound checks
Date: Wed, 30 Sep 2026 17:16:33 +0200
Message-ID: <20260930152422.316279541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 74ed3669f26803b1761c1f55403062bea44c3466 ]

libipw_rx() reads skb->data[hdrlen + 3] to extract the WEP key index in
both the software-decrypt key selection path and the hardware-decrypted
IV/ICV strip path. In both places the existing guard only checks
skb->len >= hdrlen + 3, which proves bytes up to hdrlen + 2 but not the
byte at hdrlen + 3.

Require hdrlen + 4 bytes before reading that item in both paths. This is
a local source-boundary check only; it does not change the key index
semantics.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705083519.23567-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 9a97ab9b89ae8..2220a9814c8a6 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -417,7 +417,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 	    ieee->host_mc_decrypt : ieee->host_decrypt;
 
 	if (can_be_decrypted) {
-		if (skb->len >= hdrlen + 3) {
+		if (skb->len >= hdrlen + 4) {
 			/* Top two-bits of byte 3 are the key index */
 			keyidx = skb->data[hdrlen + 3] >> 6;
 		}
@@ -663,7 +663,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 		int trimlen = 0;
 
 		/* Top two-bits of byte 3 are the key index */
-		if (skb->len >= hdrlen + 3)
+		if (skb->len >= hdrlen + 4)
 			keyidx = skb->data[hdrlen + 3] >> 6;
 
 		/* To strip off any security data which appears before the
-- 
2.53.0



