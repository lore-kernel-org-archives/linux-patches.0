Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F35318ED6;
	Wed, 20 May 2026 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302089; cv=none; b=lK+AxPxmI3SyklRw4NpSOUa2pmqotiAuXWATsAnDdYVHAdPmrZ9CP1n2I7P0+4pbFVNsQiLbn6x7mkEZuV1LBdbyOKaGLDPPGFrDs9hei+dVOkzZFN9kt59NStI0cz6t2IYEVuWvkOxgu3hchOu2ZdSITpIsZLz5d+VPtWBdX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302089; c=relaxed/simple;
	bh=YbI2QISgC2S+je08dJKrP1AXcsWGlXXrq8V6j7eH56s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SizReEv3aUi6iyOduACOTCA0RtLppWNpK/DM8jhkQYLErwefJ/NfeVMjLZu5V9m39sy+dL7ga3TPfO65t1SzQJ2QKyBCl820PiPoABSsZrHN12iPv1Qixs7HiAlqrRv5HjEN487j4+smtgdbwIRK8HmAqbZl+AI03sr0fsCEM5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xcuxkh45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xcuxkh45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5981F000E9;
	Wed, 20 May 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302088;
	bh=p54n8hzZBGOXW9BQNDzl0m6KiiJWf/VCL5Cx5eca/14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xcuxkh45wwL26j3EkyCNNn5HF6H0aArp5X9/8G+AQvSYzkKuyw81D8G+CW1WudhzM
	 Q4IVn+UuZ3XhqcuU70gci+ftw/4agjfKyjaH+yD2AM1ATD9V0ySI9Z0BzBUtDfCMel
	 DqxYtU8qr3d1AwGazlP1hmbBbk6ski2DoSf++adw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/508] pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()
Date: Wed, 20 May 2026 18:19:18 +0200
Message-ID: <20260520162101.554410856@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pmdomain/imx/scu-pd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/imx/scu-pd.c b/drivers/pmdomain/imx/scu-pd.c
index 368918e562f55..606d6bdccf94a 100644
--- a/drivers/pmdomain/imx/scu-pd.c
+++ b/drivers/pmdomain/imx/scu-pd.c
@@ -326,6 +326,7 @@ static void imx_sc_pd_get_console_rsrc(void)
 		return;
 
 	imx_con_rsrc = specs.args[0];
+	of_node_put(specs.np);
 }
 
 static int imx_sc_get_pd_power(struct device *dev, u32 rsrc)
-- 
2.53.0



