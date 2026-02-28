Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB847CC7E;
	Sat, 28 Feb 2026 17:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301328; cv=none; b=BEBpFaAa+AVCNt88GGuMYKEgNxH7LSnsBi6yRph3VsRKb9sCimWRwxzEKKN889c1bIhfN6OWaj9zHU/fKIcgoZyS9wXWKGLhkY3ajlZP8oMxKeUtFf5PNoEzE+v8AvAGfNSgFDPQHw/oUGk9Hz5ekWORo+ZKoysVYwORfA3nvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301328; c=relaxed/simple;
	bh=X1qt2O3SpR6BNG/h6kwNGVHFl+CAHWvhjIa/OrInxyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOEKUu7/1ExhSzxM9TQOcKkJh2xJfGjck4EGqOHDrS0pWhVNmBG+l7tf3TdMvMPYaGt+gvvQZfH5Vbm1/LyeIo49jCbbamFY7cScjdKFOd3vJPK9QTBybz2hW5uFa0wyStp7DMT7nT501Z2EQgKGnOEWZaQftfHXAAbHJiyfYZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWBKmxNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWBKmxNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC30C2BC87;
	Sat, 28 Feb 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301328;
	bh=X1qt2O3SpR6BNG/h6kwNGVHFl+CAHWvhjIa/OrInxyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWBKmxNjsDTfeunYB/Hvij9PlHkuPd89jtVLt7pIw+V47kl+fXyIW+9GG//R1wzp8
	 IZADHTVcw+lJ7bY7ENFOMSUgCBAhftQQ6z3TwhBpTy5YIq68ipQw5dZuJEkN+Ab8NM
	 j2ZGnZBMadCJn3LbpencSTnSoo0GcXxX5qZXxMmr4PJpJrJJJdYfve++0/iLRuT0IF
	 BPPPiIlP8waDwY4cjPi6lJJpTEi7M2w61eM5zaplXDIuCFyk7mbNhcE9s841r22H+N
	 IAOmGFy0/aUh6pOeRC4IQZ/FBXeZ90+LbrtIY7+BIWLj2jxVvX4/1EyklPIm+jiUIA
	 c1fH9E0pFQYqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	stable@vger.kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 515/752] media: i2c/tw9906: Fix potential memory leak in tw9906_probe()
Date: Sat, 28 Feb 2026 12:43:46 -0500
Message-ID: <20260228174750.1542406-515-sashal@kernel.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit cad237b6c875fbee5d353a2b289e98d240d17ec8 ]

In one of the error paths in tw9906_probe(), the memory allocated in
v4l2_ctrl_handler_init() and v4l2_ctrl_new_std() is not freed. Fix that
by calling v4l2_ctrl_handler_free() on the handler in that error path.

Cc: stable@vger.kernel.org
Fixes: a000e9a02b58 ("[media] tw9906: add Techwell tw9906 video decoder")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tw9906.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index 6220f4fddbabc..0ab43fe42d7f4 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -196,6 +196,7 @@ static int tw9906_probe(struct i2c_client *client)
 
 	if (write_regs(sd, initial_registers) < 0) {
 		v4l2_err(client, "error initializing TW9906\n");
+		v4l2_ctrl_handler_free(hdl);
 		return -EINVAL;
 	}
 
-- 
2.51.0

