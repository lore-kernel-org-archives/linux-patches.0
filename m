Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306A2326D44;
	Tue, 21 Jul 2026 17:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655735; cv=none; b=BOrb7nrrfPHkMkTGR5YX6smaseQ8ixJhiYoc7Iq8VeLmaB9dQ+ehBfIbXfHyBtv5RlK41lqjKQGdLm9p/tJc7Sh2WFVPgndi2sPcEyI6GZcM33L8vDIuwPrs34dphnEHYHgp96BH29h8eKBfBdJdbcdeFViXUg4D6G+lULkFFwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655735; c=relaxed/simple;
	bh=I5zMCXptW2cj3Z7VTngf1/NDU9zZKEhDI+stdbb3MN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aspQj5IbwAKBXI+LTgqKXVT0lvhrJOz85EPxHJrhh5hzIETiIadEG72A9PDl9taTZ+pS8CEYhjG88gP7DgmQQjuxo3F7nA3xFu/B/KMGQusZv1j+f2JHpyQQYmh5BcUOjhG8iCATyBYDu8V2HCOZzzlh3C2x/+1vnF6cNfyau2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE2DpNrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE2DpNrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BC81F000E9;
	Tue, 21 Jul 2026 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655733;
	bh=1CYLJLf5R/DAIJ3XMIY5OTHN/nHrdfFsjzmd10s1eJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eE2DpNrlNIj+r2x9jbzNSM89X5dqd8NwXMZnCxyRqm0Zeu/k9AhYtE1czkWIz/Opk
	 TYuAGVq9bwrtrhf0te8Y668poCuGHLnVfaC9++c+arHJqRqqlrn84GcRKmRHWUj9b/
	 lwW4o81o8Cy2gPhp7WUQgjxZ01OJkgGeLulImPBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0121/1611] crypto: ccp - Fix snp_filter_reserved_mem_regions() off-by-one
Date: Tue, 21 Jul 2026 17:03:57 +0200
Message-ID: <20260721152517.580512119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tycho Andersen (AMD) <tycho@kernel.org>

[ Upstream commit 1b864b6cb213bbd7b406e9b2e98c962077f300df ]

Sashiko notes:

> regarding the bounds check in snp_filter_reserved_mem_regions()
> called via walk_iomem_res_desc(): does the check
> if ((range_list->num_elements * 16 + 8) > PAGE_SIZE)
> allow an off-by-one heap buffer overflow?
>
> If range_list->num_elements is 255, 255 * 16 + 8 = 4088, which is <= 4096.
> Writing range->base (8 bytes) fills 4088-4095, but writing range->page_count
> (4 bytes) would write to 4096-4099, overflowing the kzalloc-allocated
> PAGE_SIZE buffer.

Fix this by accounting for the entry about to be written to, in addition to
the entries that are already allocated.

Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d99726d1d57f01..563418b9e88917 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1331,10 +1331,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	size_t size;
 
 	/*
-	 * Ensure the list of HV_FIXED pages that will be passed to firmware
-	 * do not exceed the page-sized argument buffer.
+	 * Ensure the list of HV_FIXED pages passed to the firmware including
+	 * the one about to be written to do not exceed the page-sized argument
+	 * buffer.
 	 */
-	if ((range_list->num_elements * sizeof(struct sev_data_range) +
+	if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
 	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
 		return -E2BIG;
 
-- 
2.53.0



