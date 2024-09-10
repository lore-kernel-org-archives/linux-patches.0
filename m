Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C8A17C220;
	Tue, 10 Sep 2024 10:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964877; cv=none; b=AM9e06GZeUDb7EGJlNXm2vDvj6T6vc6wgrZkdvFkrX3ECp+6Gf6e3zI2bc6u77StMwgRYsuE9WBz19oPoxg9gXc//ESSF/eb/xf5wWWy7+D+shbII97xIVB/0zIN9eX7vYH1gfJnBOTd0bwNQb+xmYqDi2HCUdsFv64ShMnzGFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964877; c=relaxed/simple;
	bh=NkvelPiQNj9bJ2xOEa0mB8zNgG65cFCpZzwX9zgGgNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvieMYFg6tgM63YMKPdL4PMfwPBHfZ4Z+ZtgnYa+kHuuq0nE6CcQd6vSK58Kiwo4pKY2DyCivGVDn+pVMS/C6eXsFufaDHIKpGX1uKtH2bdReEjTw0E2R6IC0GrFoWlWv7IRVKdB/ByxroveXucbjrpNZGEEbDOoF6pt9EcSpTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsMFiRB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsMFiRB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE3DC4CEC3;
	Tue, 10 Sep 2024 10:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964877;
	bh=NkvelPiQNj9bJ2xOEa0mB8zNgG65cFCpZzwX9zgGgNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsMFiRB+jckt8j63opccYpnNgWXW4LluMmge6MBXkqtsLTGzL5WexTXGr5eTRg62+
	 TPPvZ+jixllr5SL4aZaIFpdp5sw9f0J1tkmNPEVjit+Y7ZVM9UR2IJ8FbnClj+Vhfs
	 aPjxawESYqef0OlDBMwxCdSfA7aKMJ2Qn/kur4f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/186] ionic: fix potential irq name truncation
Date: Tue, 10 Sep 2024 11:32:09 +0200
Message-ID: <20240910092555.965258908@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 3eb76e71b16e8ba5277bf97617aef51f5e64dbe4 ]

Address a warning about potential string truncation based on the
string buffer sizes.  We can add some hints to the string format
specifier to set limits on the resulting possible string to
squelch the complaints.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20240529000259.25775-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 324ef6990e9a..f0c48f20d086 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -210,7 +210,7 @@ static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		name = dev_name(dev);
 
 	snprintf(intr->name, sizeof(intr->name),
-		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
+		 "%.5s-%.16s-%.8s", IONIC_DRV_NAME, name, q->name);
 
 	return devm_request_irq(dev, intr->vector, ionic_isr,
 				0, intr->name, &qcq->napi);
-- 
2.43.0



