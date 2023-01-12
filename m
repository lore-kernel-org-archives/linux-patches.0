Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C144D79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4480AC433F0;
	Thu, 12 Jan 2023 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533962;
	bh=HkauKw7sF3DOMpakq10EffHxGSqfsWbhj3x6thbYu8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWzfVKYCWbPyUlDCeZamZYTfhD6gXfgU6bleQtrAoFREAOztx8xjTmmlP1d6wIURK
	 u321nhWsDExr6cWhoQF1Wui+ag2D0qBp/8Xrxdy6BTj8qsXqHG7ZGLSWz1MQyxAzOF
	 f9yTkXSV/YF6+ptJc02v85IeYsAi7zR//JuWRhV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 632/783] dm cache: Fix UAF in destroy()
Date: Thu, 12 Jan 2023 14:55:48 +0100
Message-Id: <20230112135553.608263856@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -1965,6 +1965,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 


