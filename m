Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65167279915;
	Tue, 12 Aug 2025 17:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020873; cv=none; b=k8ss00qdanv9dxSe9JD5fX8EJACOVP7xsnesrgA9V9AHCYnaS0GEdswzk59WTYgdf/TCXABsWF3Ymey1uRI7PTNK7JT6igR0aOKjITq69ZTA143WBQbU6dE2AsPc+jzRcqHT/wRTwsIktbIpTkEnEDjPDD2ItpnYsFJ/813zSi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020873; c=relaxed/simple;
	bh=pKETphnQ7G5R+O4mnvigND2sSw788dYl10lV5BG3v7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKeI9Om0qoyY+XHGyUBTqaf83cMRfpezx7r0Rb9jQgD/RgLdOwvKZ1HFPsDiMA0bqTq14ArE8ly10afOslQS52iD5aV9IbfQ+sfnIZ22m/jXeTtlyWCpk7uQNG1jwzPqXEApCgg7SkHMedjpTTe0apk3NncztuxPC/W+RwAiY84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WV8NQ6tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WV8NQ6tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC6EC4CEF0;
	Tue, 12 Aug 2025 17:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020873;
	bh=pKETphnQ7G5R+O4mnvigND2sSw788dYl10lV5BG3v7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WV8NQ6tuJQM2wRp6rs1G+Jnl/K5My9SXDeKGyX+vxtR1TTp8ty7twAvsw9Uv5pbVh
	 uSCpKomnyLR5tdOG4hkxvsS5MLRnzAtq+c42LePAqT3MtHI4Apr/8F+8+Ur75oenh6
	 KP0+xxrOShFkLtPqRqpwlCs+gMHxh/DdErzkrwGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/262] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 12 Aug 2025 19:26:55 +0200
Message-ID: <20250812172954.128196559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit eb2cb7dab60f9be0b435ac4a674255429a36d72c ]

In the error paths after fb_info structure is successfully allocated,
the memory allocated in fb_deferred_io_init() for info->pagerefs is not
freed. Fix that by adding the cleanup function on the error path.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250626172412.18355-1-abdun.nihaal@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index eac1d570f437..dce721f440c5 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -744,6 +744,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



