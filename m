Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590470;
	b=fB+PRZ0YAJBEbEAtpW9TltmLZRLz3jeimnUL4xyXtxKB1MR5ahyIi+AvLzBxcgbUDVYO
	 Gj924w4uze3tADCTN6xy8qNs9SDlCqfdEpFKVEMeQClaCfHrM8rkAe/HV7NhuKzXAfBid
	 Tjx/un2g15jVSkn5D+JzDKVbGyN8AlPjueyhzy864F5g5Ly746UTHeMrQVtbZYjqcHKNf
	 HoL8QK9wB+Wj8Vxwue19mE2PjQm+e8GZpYDagQiLRFUitEtYTwvnuGyWiocxNpT2BSBwI
	 /XL/mOcTLIvjlniov91nFHFbvAdmkYDeU5SicQIWgG7lgxIAZqHlbuKWppdH5TdUCxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kp/TXJ7pik77nlw+8zpejgYJw6C/Na5HNiXH4VceXGA=;
	b=M2oj4iCt1xu26R3/lXK6h/yrFI6+SP2o3/CrHgS+BGKnLuYBnz8SQa+6rfsinxUJ+ClE
	 XkgNOUKqtHsfW4X4Iur9ZtrC048cpV/nKoHQmiCmdbnmyIbw3Y8a5BeVswqrR71zOQmeI
	 Y0lxccgoZx8c1ihsV7yDoH0p2pKBTxEHzFUODQrM7Nr383Mp0vvtmtNqWjU4K5JaNxRDO
	 NvGhMGke/JuHMexXkRYxKfuYNWW5mSHQcwt7NvpIKRIQUK5vEvsBXla5p3a++hBEROqIS
	 qbAsL1apY06ofH0XohOTdeitmL1+xXCAoASg/gfxgJFboBJBXppIEb/GRKk0P6JJJpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVttDWds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACE8606B805;
	Fri, 13 Nov 2026 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVttDWds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167141F000C7;
	Fri, 13 Nov 2026 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590470;
	bh=kp/TXJ7pik77nlw+8zpejgYJw6C/Na5HNiXH4VceXGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVttDWdsd8rhtUTd3mVXbjjTD9jsuCRKfMepxPhXb8R/B6uMaHzViUWI5b34Sbznw
	 cz8+KPLZLMvS7hcOSIh+zgb2mDL93tI/CMXL8B+RMOooeVrc/eqeriEGJGpfDAejcJ
	 DuOYsTBwd0Uht/6EYx/Mbd/KxHLhXAij0eT7frgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Zeruhn <fzeruhn@icloud.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 425/686] drm/dp: keep MOT set between messages when no_zero_sized is set
Date: Fri, 13 Nov 2026 10:49:18 -0500
Message-ID: <20261113153835.340904067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Zeruhn <fzeruhn@icloud.com>

[ Upstream commit 06bb2e5c71e9983519929a8482bea89da6d80ad8 ]

When aux->no_zero_sized is set, drm_dp_i2c_xfer() cannot use a bare
address packet to close the transaction, so it clears MOT on the last
data packet instead. The check only looks at the position within the
current i2c_msg, so MOT is cleared at the end of every message and each
one is terminated by an I2C stop.

This breaks E-DDC reads of EDID blocks 2 and up. Those are read as three
messages: a write of the segment pointer to 0x30, a write of the offset
to 0x50, and the read. The stop after the first message resets the
segment pointer, so the read returns segment 0 again.

On a Pimax Dream Air (three EDID blocks, native timings in a DisplayID
extension in block 2) connected to an RTX 5070 Ti with nouveau, block 2
reads back as a copy of block 0. The checksum is valid, so nothing is
reported, and the connector only offers fallback modes.

Clear MOT only on the last packet of the last message, as the commit
that added the option describes. With this, block 2 reads correctly and
the native 7104x3840 modes are listed for the Dream Air.

The same problem was pointed out by the Sashiko review of the patch that
sets no_zero_sized for all DisplayPort connectors in nouveau.

Fixes: f0ddbb1eed18 ("drm/dp: add option to disable zero sized address only transactions.")
Link: https://lore.kernel.org/all/20260827015758.0B4FB1F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Finn Zeruhn <fzeruhn@icloud.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20261002212833.9674-1-fzeruhn@icloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 4fc371f0fa123..8ef5adecace12 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2183,7 +2183,8 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			msg.buffer = msgs[i].buf + j;
 			msg.size = min(transfer_size, msgs[i].len - j);
 
-			if (j + msg.size == msgs[i].len && aux->no_zero_sized)
+			if (aux->no_zero_sized && i == num - 1 &&
+			    j + msg.size == msgs[i].len)
 				msg.request &= ~DP_AUX_I2C_MOT;
 			err = drm_dp_i2c_drain_msg(aux, &msg);
 
-- 
2.53.0



