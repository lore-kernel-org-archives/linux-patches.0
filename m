Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BED3537FF;
	Sat, 12 Sep 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231581; cv=none; b=mrJuKDPxZb7agfzLCXnojcx1/fw6h9wfzHhdA+vKbpaPsEzlzeWAXE8v2ZwbpdAIQVZA3LpQ2hxBFPhc/cXKMi2HJGRTionv30lGijq9sw0uWZIr8dExmcCBnDXoO56hbE7wXzrraMmnmdT+bywQb16qh7POrW2J/flbXsnBAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231581; c=relaxed/simple;
	bh=TToxetSwZ8n9WQsnCicrkuT1eyqBEQyVF/BLsYZnmnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhqZ/b+WoSgbLyzhPMk+O4lDDzoh6HEtiKJGKiOdT3ypSvNs9NntuaTmQiqmGD7oThCj2yQnag4bB0qYuYCXDFQ5haamZTkgIUpgZGb6IQzo1qwyKsaikDxnSulZW+xXeKFH24IVO58/7TRpVvq0A1rXw+/Rc3NSjc6PCt5pDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIPQNM+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIPQNM+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967401F000FF;
	Sat, 12 Sep 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231580;
	bh=b0epr5r67zVQqB/0K7iNSAcuF9dREOdJAHVEPTOZyAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIPQNM+X4lYN5KZElsBBUGczxoolUpIRC8YzEFM8k6OL7pzwSx4kHkQEl2BwCr8B7
	 1nwVwhG+30JcvZ42lSpdeDDQm3+ZrLcUS/08obylW5OxySNHBMXqJxeiwcmkflmZZU
	 P6c6vRYiub+lPzcLTwoP+ud4WAtuIUsKtppOJ5ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1029/1191] null_blk: free global tag_set on init error path
Date: Sat, 12 Sep 2026 09:02:37 +0200
Message-ID: <20260912065611.297093434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 5a1c5ff3a49ba93a1fd0b70537e7a0164071760d ]

If shared_tags is enabled, null_setup_tagset() allocates the global tag_set
via null_init_global_tag_set(). If device creation later fails, err_dev
destroys the default devices and calls unregister_blkdev(), but never frees
the global tag_set. Since module init failed, null_exit() is never invoked,
so the global tag_set's tags and maps are permanently leaked.

Free the global tag_set in err_dev, matching null_exit() which does
if (tag_set.ops) blk_mq_free_tag_set(&tag_set).

Fixes: 82f402fefa50 ("null_blk: add support for shared tags")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-5-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index d7e4a0be125af..7383a54af2c4d 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2307,6 +2307,8 @@ static int __init null_init(void)
 		null_destroy_dev(nullb);
 	}
 	unregister_blkdev(null_major, "nullb");
+	if (tag_set.ops)
+		blk_mq_free_tag_set(&tag_set);
 	return ret;
 }
 
-- 
2.53.0



