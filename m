Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13023242D9B;
	Wed, 25 Feb 2026 01:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982874; cv=none; b=Qv4RDSRev0InPgn8SYv0FQr3N1Bi8ykmsSZChfNEXgxPI1HK5NBjiy6/ARYW44q8JZH/LjooO/aqrHm0CJYCrYCsV73cuJZ1mxrdMZe+PqZI1WZ9p6VtikcgMLGmxOxdf6DeSO7X4ITCw4lWxt6VCDO7KS9LCt8n9XzDzxIffDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982874; c=relaxed/simple;
	bh=em7S20UXtLoodsZqMuVu8sWTKlpe0ilh+3AiIWRR/js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA7NuOR1/YHokDqNxL9IEkvyfaKn+AGhC9az9vZcNXlBkHIrfR83C+YagUIuWlI/cSDeHkPFYLKQBpyTtHMJLxUulxxXrvSGKcy58OHCIziwjncDYwj7phQxdPWh82mVXbA/pKHQx/M0kp9djne2UHjv+5kB/oHryu+VYjAmrXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQVsQ6nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQVsQ6nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32FBC116D0;
	Wed, 25 Feb 2026 01:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982874;
	bh=em7S20UXtLoodsZqMuVu8sWTKlpe0ilh+3AiIWRR/js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQVsQ6nZkrPmAuxQnxE3W74zOVTy6/RF1F3mUMzaNc4BTDkogDfDGbZS5GSRpNtgM
	 9twxb6l3KWw3FTOFwHpCNgqy0R+cDe7VdpEx9/aiUHbduN3biDuPgFbz4bZq+enowE
	 Jad3XJUP8HytyAtNA93co8r8QiWhbEKxjEALIaGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 058/781] md/raid1: fix memory leak in raid1_run()
Date: Tue, 24 Feb 2026 17:12:47 -0800
Message-ID: <20260225012401.129228132@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6abc7d5dcf0ee0f85e16e41c87fbd06231f28753 ]

raid1_run() calls setup_conf() which registers a thread via
md_register_thread(). If raid1_set_limits() fails, the previously
registered thread is not unregistered, resulting in a memory leak
of the md_thread structure and the thread resource itself.

Add md_unregister_thread() to the error path to properly cleanup
the thread, which aligns with the error handling logic of other paths
in this function.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Link: https://lore.kernel.org/linux-raid/20260126071533.606263-1-zilin@seu.edu.cn
Fixes: 97894f7d3c29 ("md/raid1: use the atomic queue limit update APIs")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57d50465eed1b..cc9914bd15c19 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3254,6 +3254,7 @@ static int raid1_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
 		if (ret) {
+			md_unregister_thread(mddev, &conf->thread);
 			if (!mddev->private)
 				raid1_free(mddev, conf);
 			return ret;
-- 
2.51.0



