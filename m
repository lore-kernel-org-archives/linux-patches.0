Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C9B3AEF51;
	Sat, 12 Sep 2026 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214697; cv=none; b=C6BDONF6j/A7/0dlY0BVRtwxS7ZJYjznuJ3OlCay/JNg/d47Mpp69s2WIpnJFVtO+4GxbFDFd4d0C5dAwet5SBZIYv9ajYrP3qi17fwt6DQ+DABygnPk/oUOwcMVe5xKiT4LmTcWywyNlg+qxU8RlnINHs2lHggTd9RN7zZUsH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214697; c=relaxed/simple;
	bh=NUGjcrPJNJDPKQKGmHXMZ+Fy+ruhupedfWgAJnMwIeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFVNp6HECILEV5BAs+pUAAYcQYPrlTUDzVlzLuNuUVOImjYteR7yAGCKLNMeh0LSThrVRI7SE3U1ve8qlNvOxkGhbo4oq7Ti33J7UakB22IWvG6Un1omCBijl9jdIWxaYI6DAaH/feysvLyPFhcbvA4/1DzxT0uQFWbbBCqlNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sj5o5A+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sj5o5A+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1428E1F000FF;
	Sat, 12 Sep 2026 12:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214696;
	bh=f/lBuJ1sa1/JCPRsunIBNc5qv0djeZHHvWAajQZRqS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sj5o5A+lMe0h4PTjdLgVrrgwAufemZu/OoGwrEl9JjJ4AK6P/XYj37Vx7/0A15rmc
	 dgSA37YcGsAmRVPFHMXq0a5l7SRXmjPTy5HfI0nUNnhhIu89LaxRbh4WdM2nIgcP5W
	 fVz3zPvUl9TleoC3D+UWcDMbJtAh6LUybTbcnmaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Min zhang <zhangmin2026@yeah.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0337/1376] clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller
Date: Sat, 12 Sep 2026 08:46:03 +0200
Message-ID: <20260912065615.062016701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min zhang <zhangmin2026@yeah.net>

[ Upstream commit a8036f4591542de4b38ec81d3e2ba47bc0b2652b ]

Using devm_kmalloc() does not zero-initialize the allocated structure.
Uninitialized members in struct hisi_reset_controller may contain garbage
data, which can cause reset_controller_register() to fail unexpectedly.

Replace devm_kmalloc() with devm_kzalloc() to ensure all structure fields
are properly zero-initialized.

Fixes: 97b7129cd2afb ("reset: hisilicon: change the definition of hisi_reset_init")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Min zhang <zhangmin2026@yeah.net>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/reset.c b/drivers/clk/hisilicon/reset.c
index 93cee17db8b16..c3b7daac93132 100644
--- a/drivers/clk/hisilicon/reset.c
+++ b/drivers/clk/hisilicon/reset.c
@@ -91,7 +91,7 @@ struct hisi_reset_controller *hisi_reset_init(struct platform_device *pdev)
 {
 	struct hisi_reset_controller *rstc;
 
-	rstc = devm_kmalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
+	rstc = devm_kzalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
 	if (!rstc)
 		return NULL;
 
-- 
2.53.0



