Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846F6AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D3CC433EF;
	Wed,  4 Jan 2023 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848720;
	bh=+g1Lj1GSqtp96cPofOdb+PwD0swlU4Qum60Li979MnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAMTAk9PGgxLP7kWurDPw9XPdJp1Tgocjwyp65IFqHiwMrKGpdaP27BY2OFwSGeIa
	 LIdgj2wGEEfKluPDdT9DShaMA64IAkce99EJtRDVjJ4CBj+8cXU5WNb7sy8KYpUQvU
	 H0TEpuDm5lDPAV5V+imdRJWtOb52vHA2ZLSe+8aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 072/207] dm clone: Fix UAF in clone_dtr()
Date: Wed,  4 Jan 2023 17:05:30 +0100
Message-Id: <20230104160514.218686222@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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
@@ -1958,6 +1958,7 @@ static void clone_dtr(struct dm_target *
 
 	mempool_exit(&clone->hydration_pool);
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
+	cancel_delayed_work_sync(&clone->waker);
 	destroy_workqueue(clone->wq);
 	hash_table_exit(clone);
 	dm_clone_metadata_close(clone->cmd);


