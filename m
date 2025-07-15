Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4632EA49D;
	Tue, 15 Jul 2025 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586425; cv=none; b=W+tBAbBkPjhZ+YFUCkS5Mi4Cd01b4PmGWXUjG89J6XGv/gr0dD2sxajHsSH9/n0L9yjYlqK80XnnXtqa00rD3MBFHs/aNKOKJtK1He9fRq8nQxzKxQaIWL3q+z7/dBlb+weRLH+1PI7XNGY/pbReSsIGH1Y614Ozv70szrYYSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586425; c=relaxed/simple;
	bh=0780TFSUF+yoOwjcu0DyRH4POa02ut96nIXvuNEFTas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8Z2EIqYSHu4QWkjlE8i7Mi9SFZyxxxRSLedk29yLRahZDWXgrf3P87AJYnWTmj+EPVoRIqaa2YpgaAvZT7hVJvE3SC4KkcVa56Yxc22bwDxXeAxjc/NfJAkt0zdjNyznxfdW3KkoYFku+fcCnemBhiJkFP0n69BTf0TYq9tyE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bza/aYKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bza/aYKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6735C4CEE3;
	Tue, 15 Jul 2025 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586425;
	bh=0780TFSUF+yoOwjcu0DyRH4POa02ut96nIXvuNEFTas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bza/aYKke5XYTr4eYiSL+3kdd5ASQxSZsCmXvU2uz1kEiKDoh2BUxcFb984EpqiPU
	 oxaM1UDsIz56/nt0DRD7Ll4r5jhYharm0zlWfSTVAb7cpSl8n5Ta0l9t/RxQIBvw+x
	 KbobFPlAFbVU48IWYsl0sxrDBr7/ky6sfA3uT3qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 060/148] mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data
Date: Tue, 15 Jul 2025 15:13:02 +0200
Message-ID: <20250715130802.731268651@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -681,9 +681,10 @@ static void msdc_prepare_data(struct msd
 	struct mmc_data *data = mrq->data;
 
 	if (!(data->host_cookie & MSDC_PREPARE_FLAG)) {
-		data->host_cookie |= MSDC_PREPARE_FLAG;
 		data->sg_count = dma_map_sg(host->dev, data->sg, data->sg_len,
 					    mmc_get_dma_dir(data));
+		if (data->sg_count)
+			data->host_cookie |= MSDC_PREPARE_FLAG;
 	}
 }
 


