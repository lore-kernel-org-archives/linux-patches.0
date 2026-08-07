Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72760477293;
	Fri,  7 Aug 2026 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117317; cv=none; b=lXSE0Acw0VXNwA5grytn9ea2InYm5/hDgLjcTSFn0F4K99hM8sRGcKSyUoJ7vhe8ql+Jnnt8hgJSkvIVU3i3xmLPZxHneecBHrBACl1ziRIJHJCxQveSEMtUpVNFytjGclpqAPgud8XCZK6O/XSNXwG3fFdxnVxYgkdkrB+cGVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117317; c=relaxed/simple;
	bh=QsmgMzYiv4284QE8IzN2QMt1ahT3/r5X9Z+q7QUOEw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXUCbCTStyvA+YSFGRjYqgE8rshwZC2n36IT3OBnq0rs3tHgwAi3it1SMsAhKXx+OT4AgjO93yHH3lwere0p2ydd30tUUNzydc5PMxfbBpi89lXj4A1U9IglFF4rJ9w9EgMsfF/g9WcxioUO9VEM1aCCn96jcbwBZHoJR8SBNgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYHXm6Y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYHXm6Y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0EE1F000E9;
	Fri,  7 Aug 2026 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117315;
	bh=z+MB7mMseDe7un53dPAC647oX0FYbsonxnXNN+Cy0t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYHXm6Y6WVC6vfnHe5rcv/8dnwhHKRoEFHwvQa8zmd4oAVKmGNBzmKB9+tqqGjMRr
	 LTe0xcozeZZgcqQr7ZIq1VMblxCadCZtx7bi45diUVWjOkMsuybgxvUDt67GlyC9IH
	 gs3+dNHEnQCEpPFnIpj+99cm3CADx4QbrqIHieWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 259/438] ASoC: fsl_asrc: fix m2m_init error path to use goto instead of bare return
Date: Fri,  7 Aug 2026 16:37:35 +0200
Message-ID: <20260807143433.515229747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 890b4253134f3a39883af7d5bea67af9c494c56d upstream.

When fsl_asrc_m2m_init() fails in fsl_asrc_probe(), the code did a
bare return ret, bypassing pm_runtime_disable() in err_pm_get_sync.
Use goto err_pm_get_sync to ensure proper cleanup on failure.

Fixes: 286d658477a4 ("ASoC: fsl_asrc: register m2m platform device")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260715024758.1252801-2-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_asrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -1419,7 +1419,7 @@ static int fsl_asrc_probe(struct platfor
 	ret = fsl_asrc_m2m_init(asrc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init m2m device %d\n", ret);
-		return ret;
+		goto err_pm_get_sync;
 	}
 
 	return 0;


