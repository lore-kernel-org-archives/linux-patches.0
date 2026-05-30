Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D430C29B78B;
	Sat, 30 May 2026 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164182; cv=none; b=YO/zcfGt5Kmy5VqQInmQmbKmekoTWnPliLOtJKReSp4enlE10U02A8jwna2ZWbmJS0geZOq7hgSySkxqcnBUNYoZ1FJ0mB33CLhq0JVHRkROiz9pJ0EIpnmHxpqNhqsWtHacTpZhP9Uehg3M2JdXpnetW3hd1KI07yAwr5cp38s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164182; c=relaxed/simple;
	bh=OgDrhehz2uOh39ifnUiCFDRMPTsxw/1E96leQaFPKWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBw6fsAOkHUffYUsAVoTFfCLGYUkGtMiV3WrrBBawF1NQekcxYi57Jg7dBEs2KVs250+4rhDdWqy7uSx2OQsDx3xF68yg4qkaIuzMdkPGSAeBUpbHXmbfJ8Sgr0DJCpKD4GE9Mr9aqxPGZiFjHw4LmhpZkcs/kVbI4Swg7kf+lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jw7kkscD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jw7kkscD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FE61F00893;
	Sat, 30 May 2026 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164181;
	bh=7kkLSBjKGt+43j7VhyPtZ2g8AgEJczr9TWuxOUKNq4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jw7kkscDMnZpjwyoAlyQ2tosXZAf2Tz+QT+b6pyGuw2AUnHRi9iB4cI7mFlV3WJKo
	 ViN84kAYV6+uJKnf3WbxByTAfraD1/VUGN+MgmiJ8c+EHmS7PxUXIgg7YPx9DEXul4
	 5JfMT16OfdYs1ZyCzOhlNa9tt6m08oGx/Fl/Ecs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/776] pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()
Date: Sat, 30 May 2026 18:02:55 +0200
Message-ID: <20260530160252.274610169@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c8e9b6a55702be6c6d034e973d519c52c3848415 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In imx_sc_pd_get_console_rsrc(), it does not release the reference.

Fixes: 893cfb99734f ("firmware: imx: scu-pd: do not power off console domain")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/scu-pd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/scu-pd.c b/drivers/firmware/imx/scu-pd.c
index ff6569c4a53bd..a0fc352a79936 100644
--- a/drivers/firmware/imx/scu-pd.c
+++ b/drivers/firmware/imx/scu-pd.c
@@ -231,6 +231,7 @@ static void imx_sc_pd_get_console_rsrc(void)
 		return;
 
 	imx_con_rsrc = specs.args[0];
+	of_node_put(specs.np);
 }
 
 static int imx_sc_pd_power(struct generic_pm_domain *domain, bool power_on)
-- 
2.53.0



