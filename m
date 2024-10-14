Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40B71BD00A;
	Mon, 14 Oct 2024 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918119; cv=none; b=ekZsRRmUvov3NY1iXfBY+dcWh7VVTsgP41Q95MT1t6B1Y31zF+wlrOSidp8fqpI628vRyTNMTIzL+YZ7jb+oglijxbvFK8gU5fl3plExhOtKgFIMlBgP0t66KARWD+MH1AG0CO8S9cGjY4yJwmoMPFfWoZSCJO6dn547DFX2nRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918119; c=relaxed/simple;
	bh=/FYYSas/aChp9Sp9Hv2HQGBmD2reDWoLaPKmFOu1KS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+JKDwDTxKqm/noV0IKHZ64whRTGaNpB0FrqMDA6/+D8GmuIaacRT/eMWy/C/riHQArJjtIGbdXbTiuOxbhgGstgf5Fk/NjISmT/Y4LlPdTOXiuOBAaxHa66HP7eI2Ielg6y0z9FoXRXxQiSqV1uGi2MNonDO0HG7+hOIAsK47A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dh5xxTdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dh5xxTdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF022C4CEC3;
	Mon, 14 Oct 2024 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918119;
	bh=/FYYSas/aChp9Sp9Hv2HQGBmD2reDWoLaPKmFOu1KS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dh5xxTdOBAzF7N/0nksiIxIUz1F/Ma8QpnpjM0er9vaPaJ1OHY/ZehlKulSE0KiL4
	 gGt3Nt8/chBYx0bzdBDvHWBabpBY55KOr+XOrNcfZo6aWBNfMD4XSDRUreGgUNhfQ1
	 U1FxvGpr8FFTj0PmbnDyjgbuvnVOeQf9rD76R7rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/798] drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
Date: Mon, 14 Oct 2024 16:12:31 +0200
Message-ID: <20241014141225.667626064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junlin Li <make24@iscas.ac.cn>

[ Upstream commit 46d7ebfe6a75a454a5fa28604f0ef1491f9d8d14 ]

Ensure index in rtl2830_pid_filter does not exceed 31 to prevent
out-of-bounds access.

dev->filters is a 32-bit value, so set_bit and clear_bit functions should
only operate on indices from 0 to 31. If index is 32, it will attempt to
access a non-existent 33rd bit, leading to out-of-bounds access.
Change the boundary check from index > 32 to index >= 32 to resolve this
issue.

Fixes: df70ddad81b4 ("[media] rtl2830: implement PID filter")
Signed-off-by: Junlin Li <make24@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/rtl2830.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index e0fbf41316ae7..73a6166c0083d 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -609,7 +609,7 @@ static int rtl2830_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid, int on
 		index, pid, onoff);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



