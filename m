Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F3375222;
	Sat, 28 Feb 2026 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301549; cv=none; b=AsNkLMHI5dyxzhYgQ9qAGvouijodkoFgqz214ZMUArGUfAvv2NOjNxjELP0QS4UrCeI/xpD81db6Wa2qCLI7u182VR3b2Q3IHri3Ytwec12JWX/sAi58mvWSy3Z+ES17k0v7g65pg3uM30GfhVLtc8peigJRhbSGglQdgURczKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301549; c=relaxed/simple;
	bh=QHca3r2l3zROSicefrNcatC2gyxEbz5tmBfbzmPLDEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEHX/JxFlHH7GJv+DyM1+t4zxFrNnDUKq7KsmwUZohtvJpEzAbKT7eTRmZr0gjD1XK6aXhRYdGDhLbyXcFURCEuVT7uqyuOg3jPt6kVVA+H31aMEkXPeDEowT44B34U827iijI6nn2PLadBiXngbrDIv904CUBO4UIUoNOdAzLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4sGntOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4sGntOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8EBC19425;
	Sat, 28 Feb 2026 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301549;
	bh=QHca3r2l3zROSicefrNcatC2gyxEbz5tmBfbzmPLDEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4sGntOBnlzZIAJ9BQ3tk/qlQvgyImc2qWPY6RTcMgyBfAI+XJkxFneAsZt1gDG8p
	 AEr0Olgiy3h9d50sXDZGC0G3FbzyX4gJ8o/0Tvpz5fpHa8ZW2DqZPxx2V95zSwOUAZ
	 yuYPiMhExVRHg6qvpH2PWmjle4DEoYkJ3V8NVTO4CV0MBbW/TAFo213674Is85pFd0
	 6AuxdEQiagR+Gy7iZJgDE7+DXTE005W2IamERE3clr2FPhfrGLRJrr0W9syAEqtfa4
	 QvX4Du5CcPs+NSbioLkS3TkbMxRh/PjvqvQwzTPzqPvRE7bgn1J1qwL1dKlF6j1PqM
	 EdyeBGlnf3ZMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 732/752] net: ethernet: ec_bhf: Fix dma_free_coherent() dma handle
Date: Sat, 28 Feb 2026 12:47:23 -0500
Message-ID: <20260228174750.1542406-732-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit ffe68c3766997d82e9ccaf1cdbd47eba269c4aa2 ]

dma_free_coherent() in error path takes priv->rx_buf.alloc_len as
the dma handle. This would lead to improper unmapping of the buffer.

Change the dma handle to priv->rx_buf.alloc_phys.

Fixes: 6af55ff52b02 ("Driver for Beckhoff CX5020 EtherCAT master module.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260213164340.77272-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ec_bhf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 67275aa4f65b2..0c86cbb0313c3 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -423,7 +423,7 @@ static int ec_bhf_open(struct net_device *net_dev)
 
 error_rx_free:
 	dma_free_coherent(dev, priv->rx_buf.alloc_len, priv->rx_buf.alloc,
-			  priv->rx_buf.alloc_len);
+			  priv->rx_buf.alloc_phys);
 out:
 	return err;
 }
-- 
2.51.0

