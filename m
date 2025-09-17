Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA238371E9E;
	Wed, 17 Sep 2025 13:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114033; cv=none; b=K8Kd92e5nlK7XddFtmZ1QIqX1uxSVGTdxajTbQYVz8XimOSWZdZsL5XtqQ5jB6oo1e3f2IUDsQGsTYQ+S6zi7ruMeGDvgtcKVHexkH8zWIhsmRxsE+jm5ZjBqk3tC/dfe4YR94JjkiM2NoU8ZGJjzry1eYuIq9rnYvNj9GffNBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114033; c=relaxed/simple;
	bh=XNAsv/X0PVTtU14TkixXVkSFc8WfygJm5Bhv261xfps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpmR7WeLZJtIvZC+FifcwSKWuWUajegIq5BXewsUxRBb6Y+0f4hqhqbrbRDlI69yXNOUoKPaZsfYupey3r+8U9meFIbJbC3ouNaBgcjUczhPOYHo4X6WrL/vKdHlQrb5WgZJo3qIjXGTrsTMGnf+yg5/e7SgVzeKLeT04rYc7xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSxQ8BPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSxQ8BPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEBBC4CEF0;
	Wed, 17 Sep 2025 13:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114033;
	bh=XNAsv/X0PVTtU14TkixXVkSFc8WfygJm5Bhv261xfps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSxQ8BPPK9I1QivAzxBrL878QmGoDLabbXfbmH91oTazI91EoGCZ99nd1NB4seANs
	 W05XDylLDiN3Qs9H1hNufuVp0suh1/6VBSmAbeU93NqEB8cEPpXiRFTCy0u9CiqAqG
	 b1/opkLg0I8PiJKD7p9Zr8lY1IPGMe8inWYo8jbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/78] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Wed, 17 Sep 2025 14:34:24 +0200
Message-ID: <20250917123329.662389376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 4936cd5817af35d23e4d283f48fa59a18ef481e4 ]

On Mediatek devices with a system companion processor (SCP) the mtk_scp
structure has to be removed explicitly to avoid a resource leak.
Free the structure in case the allocation of the firmware structure fails
during the firmware initialization.

Fixes: 53dbe0850444 ("media: mtk-vcodec: potential null pointer deference in SCP")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ Adapted file path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_fw_scp.c
@@ -65,8 +65,10 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_
 	}
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		scp_put(scp);
 		return ERR_PTR(-ENOMEM);
+	}
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;


