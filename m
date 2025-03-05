Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C53250C1C;
	Wed,  5 Mar 2025 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197517; cv=none; b=KVyVHfnO+VVOzd7spRqp0X7riiAOOdl7n49yHH1iWFK5Mr+SYE1qvG7o4roLrqD+jOB4KdixjULqnWU6jdHbUTvANAAFUV2aymJF+Zj22QmURIQVPssV6uZD1iaHzpOb34DCWY8LtM5lWES846OoLD5VX0r7dWKcHDDgHASL+3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197517; c=relaxed/simple;
	bh=LCZCzvVSA46cgAfb3DP0BWmRshSoRuU29A2Rmhkff70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgZAoDMMRnf42ZU+ZsCHuR/7hQfEjplE39w3iG0kSLDOQgt8GPczJKdHbQ9ihktsk9uBj3S1nQfVb/1j6Gq+r3cUZc/27d1udzyzFhecBtp38H8hoUHQDX518h00KVYcyjE71jVE+Kw1gdJYEH0LVQ5O2WaaC6SL/9GR8w94vDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcZAdUpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcZAdUpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7936AC4CED1;
	Wed,  5 Mar 2025 17:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197516;
	bh=LCZCzvVSA46cgAfb3DP0BWmRshSoRuU29A2Rmhkff70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcZAdUpMz1AWlAgj57AlCTm7Bl1+oDprPmq+um3Kt2/XT6xFpv7rXfwDZz5/zMvyN
	 jyZfHLwaVCFtbqWOhA4yA/rv+pS03aLPLpb/3aUptfWXOgLdu+9YQ+unm5rJ/3OeL3
	 UU285ttfUcIimmr7X7M6nGzwmC64kVIQkEVcl3Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 176/176] media: mtk-vcodec: potential null pointer deference in SCP
Date: Wed,  5 Mar 2025 18:49:05 +0100
Message-ID: <20250305174512.504068563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fullway Wang <fullwaywang@outlook.com>

commit 53dbe08504442dc7ba4865c09b3bbf5fe849681b upstream.

The return value of devm_kzalloc() needs to be checked to avoid
NULL pointer deference. This is similar to CVE-2022-3113.

Link: https://lore.kernel.org/linux-media/PH7PR20MB5925094DAE3FD750C7E39E01BF712@PH7PR20MB5925.namprd20.prod.outlook.com
Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
@@ -65,6 +65,8 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_
 	}
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return ERR_PTR(-ENOMEM);
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;


