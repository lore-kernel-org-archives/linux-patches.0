Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2F3213E6B;
	Thu, 12 Dec 2024 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023013; cv=none; b=PIv2BWyWIc2z4EMSQky/i8LVQY/6V81/gFNdAGKAJAFgsafeMPKEqRNVrydF/iKEfHL+oIXxsm75Y5gvlCDh2ieFCBNe6/WnWWw0vJLLbBACTm+DsthTlcgOXaK9YvX7cy5N8uIoBPjOTalRADCf4d46dyGaQAqeLm4UZ+Pv2Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023013; c=relaxed/simple;
	bh=Gc+BBNtIrnHIs9x0tWGokBRxVn03Cbs3PxI4MhlaNjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0JgAE75CdgWM3SpLZF4XWuZbT/TH2XBsqcQRLlJR7UQFTNckQtxCdpDDz9ZtfOZVImCkUSgzLDQC3CkhjTsQ8cPiuuV679KScgJZ44WFXN20iPpcMX72r454V9hVlOmYshRVSair1LFuH6rhEXASdAYhc1hqz0xQjVRwSzvXFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/PcOMVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/PcOMVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A726C4CED0;
	Thu, 12 Dec 2024 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023013;
	bh=Gc+BBNtIrnHIs9x0tWGokBRxVn03Cbs3PxI4MhlaNjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/PcOMVeWMIzNJrcmXzHBmIiHLzPjUCRxkSeVc8tK3erXH18CTPWGT7Ej7L9n2JhN
	 yi5VQKRdB+lPQbR+drP/fIFLTaxPzHRODRzEiF5rf1+HFYUftS/xp6SlyeEXZRyux3
	 zF7mbMox0NUlvV5BRzePNzKbauDzkG3qhu+C52VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 5.15 397/565] drm/etnaviv: flush shader L1 cache after user commandstream
Date: Thu, 12 Dec 2024 15:59:52 +0100
Message-ID: <20241212144327.341594199@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

commit 4f8dbadef085ab447a01a8d4806a3f629fea05ed upstream.

The shader L1 cache is a writeback cache for shader loads/stores
and thus must be flushed before any BOs backing the shader buffers
are potentially freed.

Cc: stable@vger.kernel.org
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -481,7 +481,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	} else {
 		CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_CACHE,
 				       VIVS_GL_FLUSH_CACHE_DEPTH |
-				       VIVS_GL_FLUSH_CACHE_COLOR);
+				       VIVS_GL_FLUSH_CACHE_COLOR |
+				       VIVS_GL_FLUSH_CACHE_SHADER_L1);
 		if (has_blt) {
 			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
 			CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);


