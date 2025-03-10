Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D05170A11;
	Mon, 10 Mar 2025 17:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628668; cv=none; b=NmUbEgV+w6SXaag+IkIy+vLtAyVqfsJM5QWoc3KtkYEctpZ5SJB/8rfXyVJajEBi1mHWBpOvkBPTgEEeXQfTXl5gDowAETDjXf4py9J63+Zxl6nos8hF7eqso5t80ep6RXINsLavT8juzsIMB6oJgWbnh5fUUVJUTmJ1grUbwjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628668; c=relaxed/simple;
	bh=eDpI/Bu3TiGNehMtfW5O+V2OKZ+SoOgYfmApgclsJds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDTUerEYnizNOUBqI1pla3/39NwjAgJTqXSSFK8+QGMU6BeQsFnFtIAZhOL5rP1kncP/MRgx/JotAuAUiBWAPGXTebGNaxCCksYE5J69ridyLyu1Fckn+3lYfhZyCzC+pkaYpiILFVLQzTyFj6jS98WoDPpcochZ6Xd/s4ZoJ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvRBu+ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvRBu+ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079B7C4CEE5;
	Mon, 10 Mar 2025 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628668;
	bh=eDpI/Bu3TiGNehMtfW5O+V2OKZ+SoOgYfmApgclsJds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvRBu+ZNzqyUopgEAPmK25wXK4CBb40Q45Q3bd+6VeSKAs/enol29uRvYzcrQfjlJ
	 Vh8WCu8IxomGWM4EtOTjugtzc8KEUy+NYenPJ+9Q0e/AlhQvTJjy5XeJDtllC9b8CR
	 0CwVwOQb9HcuvPTp/eZvFJraCl2fVU0umgHOC6Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Erkun <yangerkun@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/620] block: retry call probe after request_module in blk_request_module
Date: Mon, 10 Mar 2025 17:57:36 +0100
Message-ID: <20250310170545.982295338@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 457ef47c08d2979f3e59ce66267485c3faed70c8 ]

Set kernel config:

 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=0

Do latter:

 mknod loop0 b 7 0
 exec 4<> loop0

Before commit e418de3abcda ("block: switch gendisk lookup to a simple
xarray"), lookup_gendisk will first use base_probe to load module loop,
and then the retry will call loop_probe to prepare the loop disk. Finally
open for this disk will success. However, after this commit, we lose the
retry logic, and open will fail with ENXIO. Block device autoloading is
deprecated and will be removed soon, but maybe we should keep open success
until we really remove it. So, give a retry to fix it.

Fixes: e418de3abcda ("block: switch gendisk lookup to a simple xarray")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241209110435.3670985-1-yangerkun@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 2f66745de5d5a..421e02794614e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -674,7 +674,7 @@ static ssize_t disk_badblocks_store(struct device *dev,
 }
 
 #ifdef CONFIG_BLOCK_LEGACY_AUTOLOAD
-void blk_request_module(dev_t devt)
+static bool blk_probe_dev(dev_t devt)
 {
 	unsigned int major = MAJOR(devt);
 	struct blk_major_name **n;
@@ -684,14 +684,26 @@ void blk_request_module(dev_t devt)
 		if ((*n)->major == major && (*n)->probe) {
 			(*n)->probe(devt);
 			mutex_unlock(&major_names_lock);
-			return;
+			return true;
 		}
 	}
 	mutex_unlock(&major_names_lock);
+	return false;
+}
+
+void blk_request_module(dev_t devt)
+{
+	int error;
+
+	if (blk_probe_dev(devt))
+		return;
 
-	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
-		/* Make old-style 2.4 aliases work */
-		request_module("block-major-%d", MAJOR(devt));
+	error = request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt));
+	/* Make old-style 2.4 aliases work */
+	if (error > 0)
+		error = request_module("block-major-%d", MAJOR(devt));
+	if (!error)
+		blk_probe_dev(devt);
 }
 #endif /* CONFIG_BLOCK_LEGACY_AUTOLOAD */
 
-- 
2.39.5



