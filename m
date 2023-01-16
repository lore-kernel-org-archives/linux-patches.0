Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868C64437
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C0C433EF;
	Mon, 16 Jan 2023 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886610;
	bh=EOWCnsDAF65zCDp6mjH6uma2ZBo5SIVa9IIfx9aO6f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9zspX1a9DV78TzhAyzozgVfxz5VGsILmq8FTrkLFKYjKeIExq4C+XG3slpbUbXM8
	 z/CjASfG3lzp11SjMRIq0xR6ab7zldSZoH5zrojVm2012pYXAZd0gCw6m2QMUoLlBn
	 FQ/9nLseQtT+CFHiLGefVTGJIgsCjDU1O6GaQzE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 496/658] dm clone: Fix UAF in clone_dtr()
Date: Mon, 16 Jan 2023 16:49:44 +0100
Message-Id: <20230116154932.187556894@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luo Meng <luomeng12@huawei.com>

commit e4b5957c6f749a501c464f92792f1c8e26b61a94 upstream.

Dm_clone also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in clone_dtr().

Cc: stable@vger.kernel.org
Fixes: 7431b7835f554 ("dm: add clone target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-clone-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1977,6 +1977,7 @@ static void clone_dtr(struct dm_target *
 
 	mempool_exit(&clone->hydration_pool);
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
+	cancel_delayed_work_sync(&clone->waker);
 	destroy_workqueue(clone->wq);
 	hash_table_exit(clone);
 	dm_clone_metadata_close(clone->cmd);


