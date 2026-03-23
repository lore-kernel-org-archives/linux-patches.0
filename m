Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB49F2517AF;
	Mon, 23 Mar 2026 16:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282772; cv=none; b=rQC3EDkiwLkM9TRDrcdbnylLLWw9JnBpPepzcHPcemFjyhMhs1bNLhz+PHtcIhzkTnn3CyDPLg6nMSGZkh2427OldLe1C63Io/BzRZJxO62N42VAOGJxygGB09eCyx3kw3Woxza6YKiH4IZZHbze34qquprcBtjYaP6wRyoSxSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282772; c=relaxed/simple;
	bh=UD0ddXyXlBHrHx0hPObnP/hvHmYm2dY6AU2bgaFZVtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALWC/FWDX/YrdTXuwwoA1rRyVRUON6B790oqNYhxttrJyxCEgml3ZlbMCktJh0l/+F4+HQSEoZ6ceOBsynh5VFYPXiaaMm0m7LuLFA4Zs89qcNz8+QY09BD6ybw2sI5gu9q4pG6MNPBi53A99b41Z0B38AGuInPQ00N/fPB9nzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEuFSiLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEuFSiLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621DBC4CEF7;
	Mon, 23 Mar 2026 16:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282772;
	bh=UD0ddXyXlBHrHx0hPObnP/hvHmYm2dY6AU2bgaFZVtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEuFSiLiJmidHH3xlgIcah3W5Q+m6Bx40CRLFs4HSzEQq8GdvmrIyPwwSIt+lVlWU
	 buUKyZl3blgkexj6UxBH+KST0kGRKgCrMIZ05wjqCTiZn/AwTJj6OmW6cVgSmUcfIV
	 fE8S8sCMqHQBnc3oBoRpkHs/3N73zaeEWX+CHhI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.1 236/481] staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie
Date: Mon, 23 Mar 2026 14:43:38 +0100
Message-ID: <20260323134530.892956545@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

commit a75281626fc8fa6dc6c9cc314ee423e8bc45203b upstream.

The current code checks 'i + 5 < in_len' at the end of the if statement.
However, it accesses 'in_ie[i + 5]' before that check, which can lead
to an out-of-bounds read. Move the length check to the beginning of the
conditional to ensure the index is within bounds before accessing the
array.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20260224132647.11642-2-luka.gejak@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2010,7 +2010,10 @@ int rtw_restruct_wmm_ie(struct adapter *
 	while (i < in_len) {
 		ielength = initial_out_len;
 
-		if (in_ie[i] == 0xDD && in_ie[i+2] == 0x00 && in_ie[i+3] == 0x50  && in_ie[i+4] == 0xF2 && in_ie[i+5] == 0x02 && i+5 < in_len) { /* WMM element ID and OUI */
+		if (i + 5 < in_len &&
+		    in_ie[i] == 0xDD && in_ie[i + 2] == 0x00 &&
+		    in_ie[i + 3] == 0x50 && in_ie[i + 4] == 0xF2 &&
+		    in_ie[i + 5] == 0x02) {
 			for (j = i; j < i + 9; j++) {
 					out_ie[ielength] = in_ie[j];
 					ielength++;


