Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AE7569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5B6C433EF;
	Sun, 28 May 2023 19:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302365;
	bh=jZwCVYRwomB0GO/E7pd4QMROKXE4wDu48IuisVSdih4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hgSaUmO1f0bnGuJsJpqLtiEAR2QSvJ6X9HWVFpPFyjdMDpGUQBbDcFVoM0LroGDc
	 aC2f1N/gWQPGzmF3vTs2fbPko0vkkA5V+PoXbqTv1sIzESc1LqZx6hjXLPFIoQ5D3d
	 uhcOEx8txuKWqrXRIxaK2UgHa+jsQkQLrIR7QBpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 106/127] forcedeth: Fix an error handling path in nv_probe()
Date: Sun, 28 May 2023 20:11:22 +0100
Message-Id: <20230528190839.724954680@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 5b17a4971d3b2a073f4078dd65331efbe35baa2d upstream.

If an error occures after calling nv_mgmt_acquire_sema(), it should be
undone with a corresponding nv_mgmt_release_sema() call.

Add it in the error handling path of the probe as already done in the
remove function.

Fixes: cac1c52c3621 ("forcedeth: mgmt unit interface")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Link: https://lore.kernel.org/r/355e9a7d351b32ad897251b6f81b5886fcdc6766.1684571393.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6138,6 +6138,7 @@ static int nv_probe(struct pci_dev *pci_
 	return 0;
 
 out_error:
+	nv_mgmt_release_sema(dev);
 	if (phystate_orig)
 		writel(phystate|NVREG_ADAPTCTL_RUNNING, base + NvRegAdapterControl);
 out_freering:


