Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D0E2E49A4;
	Tue,  8 Jul 2025 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992301; cv=none; b=D5lov84FdUK5PQu+eHtPc+oHLtrVX9MQhfoqOC8WESuTeGBovjPv30AW8KC4tSatVCj9HuWE9aUwZSNF09q49CHl2YEFHl5A9uT9wUuHooG9hhut8KGh8c50uLpJJZ2YAxF7r5J9496A02uDoSHO2DxPGTQByahcHp4dmdHeJLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992301; c=relaxed/simple;
	bh=iJAeyZB/ymMEPBJj1sO6C235UClQ6qb3rmvsMIq72KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuUJQQUg43fWOqRHN1urj/U32rX5RaEaLuwJkUP44ES6eJRj6XmoSPvJtm5ckw5aFsZ9TMwIb+SiiSzAQh2IGlWQBmccboFhcKpiC8HA/RnUQOG6eNCZJ3I6rnh1UKAD9MRc1Qe/3Lhn/C9IEpBCq1OnFsKf+0mp6C4SEX5LkDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jk1jwnkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jk1jwnkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAB8C4CEED;
	Tue,  8 Jul 2025 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992301;
	bh=iJAeyZB/ymMEPBJj1sO6C235UClQ6qb3rmvsMIq72KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jk1jwnkjkvRz0ow/LNchwFHRq+9jx4oFA5Oam9a2/+qmwVKja4EQMAgAQdhiDfYXS
	 m6myQUja/+sbt20Ho7f2baZ7j3GeRIOM2jw2wgEI+yDG0DM/WSS3ua0hEy52bwDIZJ
	 W4ZZyuxkFIO8tUGcKaugeZS/pYy97dGtrZXbOnYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 015/132] mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data
Date: Tue,  8 Jul 2025 18:22:06 +0200
Message-ID: <20250708162231.177180155@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 539d80575b810c7a5987c7ac8915e3bc99c03695 upstream.

When swiotlb buffer is full, the dma_map_sg() returns 0 to
msdc_prepare_data(), but it does not check it and sets the
MSDC_PREPARE_FLAG.

swiotlb_tbl_map_single() /* prints "swiotlb buffer is full" */
  <-swiotlb_map()
    <-dma_direct_map_page()
      <-dma_direct_map_sg()
        <-__dma_map_sg_attrs()
          <-dma_map_sg_attrs()
            <-dma_map_sg()  /* returns 0 (pages mapped) */
              <-msdc_prepare_data()

Then, the msdc_unprepare_data() checks MSDC_PREPARE_FLAG and calls
dma_unmap_sg() with unmapped pages. It causes a page fault.

To fix this problem, Do not set MSDC_PREPARE_FLAG if dma_map_sg()
fails because this is not prepared.

Fixes: 208489032bdd ("mmc: mediatek: Add Mediatek MMC driver")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/174908565814.4056588.769599127120955383.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -770,9 +770,10 @@ static inline void msdc_dma_setup(struct
 static void msdc_prepare_data(struct msdc_host *host, struct mmc_data *data)
 {
 	if (!(data->host_cookie & MSDC_PREPARE_FLAG)) {
-		data->host_cookie |= MSDC_PREPARE_FLAG;
 		data->sg_count = dma_map_sg(host->dev, data->sg, data->sg_len,
 					    mmc_get_dma_dir(data));
+		if (data->sg_count)
+			data->host_cookie |= MSDC_PREPARE_FLAG;
 	}
 }
 


