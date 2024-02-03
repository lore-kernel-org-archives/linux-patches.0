Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29361B95C;
	Sat,  3 Feb 2024 04:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933763; cv=none; b=KaWbdt/ta8VmhCKOMgQrkVZcCT/QiDCGuING4Amc9lH5hSPkpQ3+Du2JXlDZ5OWul4UnXagja1xgqR0wN3nN503Tsfgt/O6cvQPCPo0CrvYGCrHzJCbpnp6knGFTgrsxw2Mlyg/4c1AJ+7oQV7KEcIXyLG4DmQmjnm5Gi9jCdCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933763; c=relaxed/simple;
	bh=zf+QbtGGM2eFtba5voPG0y+8zXMOuFpDHt4OLTs2GLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM0LjeFwxqVOhd92psAWLjKdnDIv8jCmWcV4xPrDiBwvyVKlF6tPKdDthRCkO5f8MEBztXKfRdXDNnwzvaBh2nsNXCJH9Mp9CDfOprJrZxnpibGST7D1CDU1SMcVTYedr/9O2oDxZsz/7wdwt5JRPOETX7J9ueFQe9B1YA2DwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUq+CEsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUq+CEsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA64C433F1;
	Sat,  3 Feb 2024 04:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933763;
	bh=zf+QbtGGM2eFtba5voPG0y+8zXMOuFpDHt4OLTs2GLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUq+CEsXJxbrBH9sKefs87DzIMejt9QjfvV567uXlnmDBm/DOmvZIawAJd2+jpUGx
	 HGBD5j1qHePCLueyH1M7+bbZxLfw1ANQoaXl1Xa9iGv5L2a/xtItc3sj5ACA7omjM0
	 dCJ70YyhWBumSfM9F4hm2DRwXuikFju4ur6FEGBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weichen Chen <weichen.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 037/353] pstore/ram: Fix crash when setting number of cpus to an odd number
Date: Fri,  2 Feb 2024 20:02:35 -0800
Message-ID: <20240203035404.971368417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weichen Chen <weichen.chen@mediatek.com>

[ Upstream commit d49270a04623ce3c0afddbf3e984cb245aa48e9c ]

When the number of cpu cores is adjusted to 7 or other odd numbers,
the zone size will become an odd number.
The address of the zone will become:
    addr of zone0 = BASE
    addr of zone1 = BASE + zone_size
    addr of zone2 = BASE + zone_size*2
    ...
The address of zone1/3/5/7 will be mapped to non-alignment va.
Eventually crashes will occur when accessing these va.

So, use ALIGN_DOWN() to make sure the zone size is even
to avoid this bug.

Signed-off-by: Weichen Chen <weichen.chen@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20230224023632.6840-1-weichen.chen@mediatek.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index d36702c7ab3c..88b34fdbf759 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -529,6 +529,7 @@ static int ramoops_init_przs(const char *name,
 	}
 
 	zone_sz = mem_sz / *cnt;
+	zone_sz = ALIGN_DOWN(zone_sz, 2);
 	if (!zone_sz) {
 		dev_err(dev, "%s zone size == 0\n", name);
 		goto fail;
-- 
2.43.0



