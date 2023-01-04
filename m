Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78421AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1191C433EF;
	Wed,  4 Jan 2023 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848726;
	bh=nPxBtxz6G++DwdQglkJOF6dm4xPDMrbf3WK8tdcieK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swt/72o5XTWK8ft65vUO5fNLuJ7ijHNKEsvNIxjEK+w2rxvEP8+upOK8nwzKU4Vys
	 mmEzEuXj+B9BTLguDdILCrqmWK/D9nlHIRBQNKaiOeWHGDKzzvNJ1j2rQ8U9iQZRrp
	 qqfUe4TKlDTRBZXA04A5Go/cMe1ZreEfHv4YlvCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 073/207] dm cache: Fix UAF in destroy()
Date: Wed,  4 Jan 2023 17:05:31 +0100
Message-Id: <20230104160514.256737921@linuxfoundation.org>
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

commit 6a459d8edbdbe7b24db42a5a9f21e6aa9e00c2aa upstream.

Dm_cache also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in destroy().

Cc: stable@vger.kernel.org
Fixes: c6b4fcbad044e ("dm: add cache target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1887,6 +1887,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 


