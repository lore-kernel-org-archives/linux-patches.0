Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D51F1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B736EC433D6;
	Wed, 23 Nov 2022 09:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197285;
	bh=oX18axhcbNRYilLpsZvzfG5kLTzdm0anos649hNoZ4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8Nc6GrrGkHjvaRg78gf/bc0N/ZypUFOxR4J2aTtb9i9PfeE+SGMGp/rm2bCiX5AE
	 Xy42DptG3QVQWwaAmTEGdtxNaR3dK4+TepJe/zBcOgsI4r3nZSsg58k2TMUFDchcJo
	 jnZKSbyMykDo21ZAoRjZ3qGOfv7RqNmdrFYY/API=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.0 251/314] dm bufio: Fix missing decrement of no_sleep_enabled if dm_bufio_client_create failed
Date: Wed, 23 Nov 2022 09:51:36 +0100
Message-Id: <20221123084636.876655552@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 0dfc1f4ceae86a0d09d880ab87625c86c61ed33c upstream.

The 'no_sleep_enabled' should be decreased in error handling path
in dm_bufio_client_create() when the DM_BUFIO_CLIENT_NO_SLEEP flag
is set, otherwise static_branch_unlikely() will always return true
even if no dm_bufio_client instances have DM_BUFIO_CLIENT_NO_SLEEP
flag set.

Cc: stable@vger.kernel.org
Fixes: 3c1c875d0586 ("dm bufio: conditionally enable branching for DM_BUFIO_CLIENT_NO_SLEEP")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c5ef818ca36..bb786c39545e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1858,6 +1858,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
 	mutex_destroy(&c->lock);
+	if (c->no_sleep)
+		static_branch_dec(&no_sleep_enabled);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
-- 
2.38.1



