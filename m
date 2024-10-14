Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4341AB508;
	Mon, 14 Oct 2024 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916183; cv=none; b=YLxFjs0FM/sGLRYkBNfe0dumyozsxsF5gWAwyahlgLJpbl6l+UPUDDfUyDDwYBTt0fmlmHMWGO4041LBNaCq7T8e04ZzZ4FlW9tGIzAZDt2ovKRJMRRPyr8XLzXZr1HcFHm4LIqiZslkj8T6LF8m3OQGU6p1b7ApQhB2UCEFlIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916183; c=relaxed/simple;
	bh=pBhfDn2vncCod7kFTMV2RRj92XzMFRo7ggLSpFdbrCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThPMpOo6cU1GRux8HQK6kMTvHmdvMadie7TuDu/9AbOjFHteD0Zpcvs6hyoRlU7fybd1zFvuOKPW+1Je2FX+J35P0OglswxWdZ+9MXcFkmZmnN2ZlIll9dKp9B96hpXJcX+fJvmKhqiy2vxC0gD0PsQrFm71KU06wW1tpLeiqAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3yYakov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3yYakov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93A4C4CED1;
	Mon, 14 Oct 2024 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916183;
	bh=pBhfDn2vncCod7kFTMV2RRj92XzMFRo7ggLSpFdbrCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3yYakovnDLHgrCClZRt8vlj/mH2y0AbpzzzerC6ScW5si92Vj27pU2ltPPua/iEM
	 5uLXqqZuJo+fHTFX9vv58tpglQs/6JRfEfkBBqObV9SMMMKVZRcnBnwsZagLMwdJKf
	 UAbAfJJ5wu1yec3oYE9cuWGbQrHFRi4sRgYb19Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 108/214] net: ethernet: adi: adin1110: Fix some error handling path in adin1110_read_fifo()
Date: Mon, 14 Oct 2024 16:19:31 +0200
Message-ID: <20241014141049.211571401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 83211ae1640516accae645de82f5a0a142676897 ]

If 'frame_size' is too small or if 'round_len' is an error code, it is
likely that an error code should be returned to the caller.

Actually, 'ret' is likely to be 0, so if one of these sanity checks fails,
'success' is returned.

Return -EINVAL instead.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/8ff73b40f50d8fa994a454911b66adebce8da266.1727981562.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 0713f1e2c7f38..bf2e513295bb7 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -318,11 +318,11 @@ static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
 	 * from the  ADIN1110 frame header.
 	 */
 	if (frame_size < ADIN1110_FRAME_HEADER_LEN + ADIN1110_FEC_LEN)
-		return ret;
+		return -EINVAL;
 
 	round_len = adin1110_round_len(frame_size);
 	if (round_len < 0)
-		return ret;
+		return -EINVAL;
 
 	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN - ADIN1110_FEC_LEN;
 	memset(priv->data, 0, ADIN1110_RD_HEADER_LEN);
-- 
2.43.0



