Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B631154BFF;
	Thu,  5 Sep 2024 09:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529725; cv=none; b=dQhFg85jPhNv2Xwk5F0Xqlvlnv0wCwpyT5A+wnaDm22tsirWJCE96VJjfwOZ3c0CURVhBveJuSQkKDNIiPOhpY7qqJbz0QyeoLGzMgAKzfuouR8hE4SwUxvu9ujySei4EmjnSX0C0UeOdFxtvZn2Oqwqs/wyxslxBrvTHweTJh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529725; c=relaxed/simple;
	bh=aZVBlDKHRerPZQ1WQFn5k8bAa2MxhH28Nuv85gvwzDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaQ3tiEowAG7uEpQD32pdCF+dt1MUpZq4k0TCaRScIyXzSLw9Nb/eYOj53xzaTtGNu1/V2hjzCsC8odfp4EFRJ8nWVFWMVjrw9jtY7b5ybFU++dhDcJqTg+NNoiPEHG2p4PiJOa7FQnl11b3WjJQN3GB7v+F9mARl21OzG12Veo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YejNPT30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YejNPT30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B15DC4CEC3;
	Thu,  5 Sep 2024 09:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529725;
	bh=aZVBlDKHRerPZQ1WQFn5k8bAa2MxhH28Nuv85gvwzDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YejNPT30MW36OaGbNv3xoNhaFjmiqaYRoXoGIGKYX8L1p1qX+W1WbnQURkzFpYKGi
	 IkK74549AV/Fsn/0rAFr4KFijSJ3CR/F4IxeccjUbS54eVHb64H6W60AP7fUsu+kQI
	 BLz6QZDg0VDmp8nzw/hVF6o4BQLNiZFZLDldq9bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 122/184] remoteproc: mediatek: Zero out only remaining bytes of IPI buffer
Date: Thu,  5 Sep 2024 11:40:35 +0200
Message-ID: <20240905093736.991960928@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 9dbd9962cfe56d210be5232349851420b5f9c8f6 ]

In scp_ipi_handler(), instead of zeroing out the entire shared
buffer, which may be as large as 600 bytes, overwrite it with the
received data, then zero out only the remaining bytes.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240520112724.139945-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index abf7b371b860..e744c07507ee 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -117,8 +117,8 @@ static void scp_ipi_handler(struct mtk_scp *scp)
 		return;
 	}
 
-	memset(scp->share_buf, 0, scp_sizes->ipi_share_buffer_size);
 	memcpy_fromio(scp->share_buf, &rcv_obj->share_buf, len);
+	memset(&scp->share_buf[len], 0, scp_sizes->ipi_share_buffer_size - len);
 	handler(scp->share_buf, len, ipi_desc[id].priv);
 	scp_ipi_unlock(scp, id);
 
-- 
2.43.0



