Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233430DD22;
	Sat, 12 Sep 2026 08:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200091; cv=none; b=YYUnaklQvHdQ8c26aM3dVQs3DMZJ2GfYKyrfNZPclRHedvDppjNPKhQuV3bpxpQCu0lSKvvAMXbQDhSXVFXERf1K7g67Rx8jdfyYLouJuX4qmEy9ojapbm5tBN6noRdkKe2I1c6XkWuhooW7EwL39KsBEsdwlf0u9DAvQbXj2S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200091; c=relaxed/simple;
	bh=6r0y0lE4/UAt/+YEpWok0rAuccnd41JFsHkp8BNXRzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBs/tN6dC8d1xALpI53lKtlotDPhtIBFt9McoxTNTkjGknoZFJfXImcmephPvdG6NdH5It62kvVNuSihtwXJXQSJbE3lGIDB/DAAAnGWgYj5TgzpKZBryRznwFXZrgHQbvSrhchJc5eA9Y3+QEXTtyRzlCK6MyuQXl0YvbedXQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcAhUyWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcAhUyWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4434A1F000FF;
	Sat, 12 Sep 2026 08:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200090;
	bh=lkaYEJ+yaO4o6UUnl+Iok9xgR7AWNS2dkwna2ATZa+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcAhUyWQXHdpqv5ftK1SdlL8/w0s6fVI6Zg1R/v0SPW161FYzpYZFQdTOOK+1BJCw
	 SoZEfFGVvYuZS3f/pdcAMbYh37OVk9R2BnBFDQCBWUCjCd7ixEhnMg0KnfnrUOu+Ir
	 HIgIQ0Yfibrzp0wJNhmtjbcJFbAOIimVOxo5X/RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0718/1815] clk/x86: pmc_atom: add kasprintf return value check
Date: Sat, 12 Sep 2026 08:41:08 +0200
Message-ID: <20260912065705.753764348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: longlong yan <yanlonglong@kylinos.cn>

[ Upstream commit 18e9d14cbac33db1c1fb933c26a736eef53dd538 ]

The kasprintf() function returns NULL on memory allocation failure, but
the code in plt_clk_register() was not checking this return value. If
kasprintf fails, init.name would be NULL and could cause NULL pointer
dereference when clkdev_hw_create() uses it.

Add proper error checking for the kasprintf() return value and return
ERR_PTR(-ENOMEM) on failure.

Fixes: 1141d9d08184 ("clk: x86: Add Atom PMC platform clocks")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-pmc-atom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/x86/clk-pmc-atom.c b/drivers/clk/x86/clk-pmc-atom.c
index 99291ba65da73..08c83e0abc41d 100644
--- a/drivers/clk/x86/clk-pmc-atom.c
+++ b/drivers/clk/x86/clk-pmc-atom.c
@@ -160,6 +160,9 @@ static struct clk_plt *plt_clk_register(struct platform_device *pdev, int id,
 		return ERR_PTR(-ENOMEM);
 
 	init.name =  kasprintf(GFP_KERNEL, "%s_%d", PLT_CLK_NAME_BASE, id);
+	if (!init.name)
+		return ERR_PTR(-ENOMEM);
+
 	init.ops = &plt_clk_ops;
 	init.flags = 0;
 	init.parent_names = parent_names;
-- 
2.53.0



