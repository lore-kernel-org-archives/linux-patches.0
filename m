Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055082;
	b=Fq0/Wa1v7fYsKwKb4lQhMnugITukz5Ipg2KOOUB5lDih+X02fA7crj3JO6v7m+tyVrAv
	 E2OYo82nJwSN9o52z9S0zKPvODDT81EWnuDG8+6Rz8FJFQHDT3CK1qB73uq5i1jrtDzhk
	 w7jCjeVdgCK17ek2zPk+qAJ5w2m+r0mJjOzuZsnvi8czSaKJ+W5fxOJ0xK6gjLnWLZRYw
	 oSJzW8ZWF6+MLLQ7LzHEbk5rf3M1FaQr5jrbPVQicrLLvIC+xF5J6PJ4m0uSO6e889uah
	 kzU1VMqx7sFD8hJ/zNVQqy2Q3D6FP52U41I1oIjFrEE5mZ6O2VdSVHW3FjPxm0TJ7XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RDmmYda3NqTz6DZkjuP+HGB5qN/03igv9lFnhEbi8EA=;
	b=fsx94DVfKpHqmQ3nLZxljq8rYjvdVnfRwuCS9cAQvc740JiVZ2qGgIrxT1O1ZCZcgG64
	 p9YJzR+vzV3mpCx1lU8f852303BHO/8SlADydximbu2As+p2un0xn48Xzq8HFm9jXRV0s
	 9eMYJYXoMOK5F6CaiLuzujjAAmq6+Dai0QCVmmd1FnZHxUqOpWrT7IU0oXKhGdS/b4w2a
	 /I1HUrbfvEEsHBCNYoGSlNc1FNgxlX34yvmyV3pqW349ev623Lk7VzBFkru0Z9+INBAGz
	 vyJ/qd2gnME5Urj8gM4bmNw2cR/H+utUFaoyOomdgB0ZbhCFEWOKUmFpoSWyyahOpDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHB1rzI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5F606A31C;
	Thu, 19 Nov 2026 02:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wHB1rzI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790701F000C4;
	Thu, 19 Nov 2026 02:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055082;
	bh=RDmmYda3NqTz6DZkjuP+HGB5qN/03igv9lFnhEbi8EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHB1rzI4aYKNCWDKz/i7R1R6NPdmvEEfl/RZSgUjLX/o2+3AolJqsOfCrbGyr1EKn
	 pXoZw02guGu29dkrIIFzsOi3zJ3g1wTqbnPZe8oLzmLQ5+hKZE2XMkRhJ4cHLihOSF
	 5zdgOxcVUeYj0SrXjoYvrVJ8yPUswE6d+r2O8tWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1502/2214] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:52:58 +0100
Message-ID: <20261118150111.899098200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit e3631d0242842940f9e902afaea98202e56277e8 ]

If kasprintf() fails while setting up mailbox channels, already
requested channels from earlier iterations were never freed. Route
the failure through the existing cleanup path.

Fixes: ffbf23d50353 ("firmware: imx: Add DSP IPC protocol interface")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index 0f656e4191d5c..e0419f908f6bd 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -100,8 +100,10 @@ static int imx_dsp_setup_channels(struct imx_dsp_ipc *dsp_ipc)
 		else
 			chan_name = kasprintf(GFP_KERNEL, "rxdb%d", i - 2);
 
-		if (!chan_name)
-			return -ENOMEM;
+		if (!chan_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		dsp_chan = &dsp_ipc->chans[i];
 		dsp_chan->name = chan_name;
-- 
2.53.0



