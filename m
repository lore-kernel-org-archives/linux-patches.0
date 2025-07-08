Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FDE8F5E;
	Tue,  8 Jul 2025 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993821; cv=none; b=f7WtbrR7AQf5jSmx6VFQwMsO4vYDo/tbW0XAPLuLFFaDJ484pINTWzNAjSehYUJ6FrT8QQ+0Tyw4wBHUsZ7XUG0pEgyjEns9ek4CCHkRvXk4RQcz9Lz28nYwst51KauhCtxwe26OTnfvFvnkLIN1Y69DcZE8c9znsktpEl54xHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993821; c=relaxed/simple;
	bh=fkxOKGDUqUuF47pPguoHssRU0NaW6UyunREz61H4lI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr4rFn+r6bkV3qpuJNEc6vBjE1WiWFUmhR6HOmVg71m3Em/18Z1Kd7x3sTMxlpXztP+x/srwu9K2RkBmZNrEfx5Iben2ltjeqHrvPQGb/ActtTaHomAPg3hzVLnjaLp8XeO7Cq4CP5Uk6idjBXecBOTW7q5iLhWmSFpzwRLthOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIdtedUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIdtedUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E218C4CEF0;
	Tue,  8 Jul 2025 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993821;
	bh=fkxOKGDUqUuF47pPguoHssRU0NaW6UyunREz61H4lI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIdtedUURKCcoxP/nSXCbPdBjkiANDAdt+BfLPXvep55Oh6nFeP/TmeMX/8wy/VPu
	 ZPTqmTy0Pq3mKk8e5BuQ0/SWV32E4zAsb5rCdJON1eu68LP8mAvQ0wxr5XV2FBlsI7
	 8NBQuHlLQdvpWgcvM4gUD70IQc+A5wHDZih+d0FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Nikiforov <Dm1tryNk@yandex.ru>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/160] media: davinci: vpif: Fix memory leak in probe error path
Date: Tue,  8 Jul 2025 18:21:06 +0200
Message-ID: <20250708162232.328001432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Nikiforov <Dm1tryNk@yandex.ru>

[ Upstream commit 024bf40edf1155e7a587f0ec46294049777d9b02 ]

If an error occurs during the initialization of `pdev_display`,
the allocated platform device `pdev_capture` is not released properly,
leading to a memory leak.

Adjust error path handling to fix the leak.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 43acb728bbc4 ("media: davinci: vpif: fix use-after-free on driver unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Nikiforov <Dm1tryNk@yandex.ru>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 8ffc01c606d0c..a59a059008cf8 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -503,7 +503,7 @@ static int vpif_probe(struct platform_device *pdev)
 	pdev_display = kzalloc(sizeof(*pdev_display), GFP_KERNEL);
 	if (!pdev_display) {
 		ret = -ENOMEM;
-		goto err_put_pdev_capture;
+		goto err_del_pdev_capture;
 	}
 
 	pdev_display->name = "vpif_display";
@@ -526,6 +526,8 @@ static int vpif_probe(struct platform_device *pdev)
 
 err_put_pdev_display:
 	platform_device_put(pdev_display);
+err_del_pdev_capture:
+	platform_device_del(pdev_capture);
 err_put_pdev_capture:
 	platform_device_put(pdev_capture);
 err_put_rpm:
-- 
2.39.5



