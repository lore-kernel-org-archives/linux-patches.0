Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E191F130D;
	Tue,  3 Dec 2024 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238264; cv=none; b=FLrtrxxU5nVjeKEisQHEYNb3t4d6whOOTMMilCHVxe8ZsdEzlE13RSxdQXvefBEalTs0ci0LEqhl/W0BPJS/BR0AojNSP/R0s2P//0tGy9O2QhOzaEbWqLydH8AKncSoF7Q42QcOcztdaOzKhGQ5w/mtJE838e5JQLOxAkim+Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238264; c=relaxed/simple;
	bh=bqceVYGZ7qULyoQjWaZ0NuD1WHNprQE3FSu7PiKYvAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JM68eu2WOE3mTdxizdyhmxMZ+kqjy1filBfa7WtfQqsrU7lEAgRyKT73RX+KZYk8yzwiADJQ4hCEm9u9RJ0Ui5YrGpZX2rRB/+HLEbBz02McD59+p68Rhs93wmzUNqAFf4mxX2cNg8flJjeu2Nyr3/7njaNUtEJpQ7pgmvW1FUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZWjGVHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZWjGVHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E83C4CECF;
	Tue,  3 Dec 2024 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238264;
	bh=bqceVYGZ7qULyoQjWaZ0NuD1WHNprQE3FSu7PiKYvAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZWjGVHHZLys3VOEEYK1DZ8UZtRYiEQQgDqPmX3LMtF0ePx0uXOamyMCBJnShdypE
	 nwLgpwATGW47yifOGVCmunFS3c+8w80VzqEBSipceC8HKKoKVUwhXyjCzIPpe5HiT/
	 +NCVwqGXCGcU46gz3BeYxpGqMGJx1aGPW05XtrpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 219/817] drm/vc4: hvs: Fix dlist debug not resetting the next entry pointer
Date: Tue,  3 Dec 2024 15:36:31 +0100
Message-ID: <20241203144004.298969009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 6d5f76e0544b04ec5bdd2a09c19d90aeeb2cd479 ]

The debug function to display the dlists didn't reset next_entry_start
when starting each display, so resulting in not stopping the
list at the correct place.

Fixes: c6dac00340fc ("drm/vc4: hvs: Add debugfs node that dumps the current display lists")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-18-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 1ac55c19197cb..7137a90e6efa7 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -110,7 +110,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_printer p = drm_seq_file_printer(m);
-	unsigned int next_entry_start = 0;
+	unsigned int next_entry_start;
 	unsigned int i, j;
 	u32 dlist_word, dispstat;
 
@@ -124,6 +124,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 		}
 
 		drm_printf(&p, "HVS chan %u:\n", i);
+		next_entry_start = 0;
 
 		for (j = HVS_READ(SCALER_DISPLISTX(i)); j < 256; j++) {
 			dlist_word = readl((u32 __iomem *)vc4->hvs->dlist + j);
-- 
2.43.0



