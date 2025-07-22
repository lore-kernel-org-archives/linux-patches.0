Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB972EA15A;
	Tue, 22 Jul 2025 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192438; cv=none; b=szBVB0LOlFVrjLy3bMu1iJeXIhNfH1weFPw64q0No7k66cNVdyu9dQ4fHTSVo2UqQW387Nck/9m8NnQsT6NOPHWpbb/snH1+621l4Rm3XyGSr5PUEqdcoqxRWFQFIWfaIzDCEihP5CD4eBOQQRYMDjDlzDf15NwvktVhBHpewwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192438; c=relaxed/simple;
	bh=O+aQk377tKLn9UmneAiZn6pAdIgQ49+wJHVFIlpA3BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXOsgCQmAQ9ZSvqmkqpAN4F5yXzGxVIy9TkA4z65TpYk0oI3KfIEpAYFi2SDKfhMTe6G0ebOeIMmfBD2TVLFXCrdJOXFGdz6PJYzeKJQMTUakBN0BZKLorY6Esn5jBOWhmXDW7GYDrubqhzsR5W011PpTlpJYUkeITRJQ/QfW5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgaWk8LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgaWk8LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFAFC4CEF1;
	Tue, 22 Jul 2025 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192438;
	bh=O+aQk377tKLn9UmneAiZn6pAdIgQ49+wJHVFIlpA3BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgaWk8LLZC6eqSOWDcI/GwR3zPIM8bBWNBNjXKNG0j2AdaiHsA4n5ovCfcfvFjlu+
	 9Teg/R4bcwSlBCQiZ0JQ5p/iKfOwMTl/LVfjHP47zNhcKlJnYQji9k0nzNPC/8ugYO
	 sc0TUfp1MOPBTEFEVIbmrdNEO2eZMkVJWukaCA08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/111] block: fix kobject leak in blk_unregister_queue
Date: Tue, 22 Jul 2025 15:44:39 +0200
Message-ID: <20250722134335.766869246@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3051247e4faa32a3d90c762a243c2c62dde310db ]

The kobject for the queue, `disk->queue_kobj`, is initialized with a
reference count of 1 via `kobject_init()` in `blk_register_queue()`.
While `kobject_del()` is called during the unregister path to remove
the kobject from sysfs, the initial reference is never released.

Add a call to `kobject_put()` in `blk_unregister_queue()` to properly
decrement the reference count and fix the leak.

Fixes: 2bd85221a625 ("block: untangle request_queue refcounting from sysfs")
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250711083009.2574432-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 74839f6f2e0cb..8d15c73a520bd 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -909,4 +909,5 @@ void blk_unregister_queue(struct gendisk *disk)
 	mutex_unlock(&q->sysfs_dir_lock);
 
 	blk_debugfs_remove(disk);
+	kobject_put(&disk->queue_kobj);
 }
-- 
2.39.5



