Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7424369A;
	Wed, 25 Feb 2026 01:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982816; cv=none; b=SOzL+Qmgbu00n2rrurQnuDvFn4CZ8oLmSN5zbJnTqZPCawvO+QjY4gc/K6hOBBkKEd4VCzIh/gbgUAO6xbZ1ZcfrClK8nAJoy1a+DQ4r6Ev+XO1IuilLj3ND6PnknonbFkZi2x6AhYmoeizBF/TyAsJJRa1uyGXvQqXcMcHK6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982816; c=relaxed/simple;
	bh=aHExn5cLhDKoxtKTBBMPx6uF1NXuigBTxyb5mI8FIjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NulMSnrz5L/tp1lByyN4EmwaEez0aelVM1Ro8VZD/ytYLIaQj7wEDLDrD6WewN5jWG8mAzBEcgIzKjGSsXN3kmKYtq/AZoQF371MvLTpqgr1BbgWKpvi7extK3eYKOefDWmBfxuvCQEMyZxQ52aV5VgcohTuMIPV5N3eviE6KnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPTV4dad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPTV4dad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1617C116D0;
	Wed, 25 Feb 2026 01:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982815;
	bh=aHExn5cLhDKoxtKTBBMPx6uF1NXuigBTxyb5mI8FIjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPTV4dadjyE34xsv2XV6yagN/kTh4aFTGGQVna4H3MgtHkBB5PnuK8eHC5XG+L1sA
	 qfMjPRcKsy/KjAn7vNlHH2AwLC0DdMB3P5pfR/vIeCOmSUcICMzbcK+va+acRtzxVo
	 b1o/0WBwr+e6jYcgGLz15TnIZRizYL8H3nwb/vco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 013/781] i3c: master: Update hot-join flag only on success
Date: Tue, 24 Feb 2026 17:12:02 -0800
Message-ID: <20260225012400.027308005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit f0775157b9f9a28ae3eabc8d05b0bc52e8056c80 ]

To prevent inconsistent state when an error occurs, ensure the hot-join
flag is updated only when enabling or disabling hot-join succeeds.

Fixes: 317bacf960a48 ("i3c: master: add enable(disable) hot join in sys entry")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 1bc3c90684028..5408332861a1b 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -618,7 +618,8 @@ static int i3c_set_hotjoin(struct i3c_master_controller *master, bool enable)
 	else
 		ret = master->ops->disable_hotjoin(master);
 
-	master->hotjoin = enable;
+	if (!ret)
+		master->hotjoin = enable;
 
 	i3c_bus_normaluse_unlock(&master->bus);
 
-- 
2.51.0



