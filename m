Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FE82BD5BF;
	Wed, 25 Feb 2026 01:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983803; cv=none; b=gzIyZGHhMf8C0acE/uJWkGo8ADMZumoPUoZ6LpkDuWqZsrdTy81G91+ipQclW9PQw9ed4OQzBCTUL7Vfl/1MNksYlJla1Lf+uzk8ZnFODx0oSsF2+aGhgs18tyFatkGt6znx3tqi7wRv5QtZWL4EWO9d09fHIZwThpsFcOMLNRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983803; c=relaxed/simple;
	bh=0WARkBJQlVK/6i/bHHa9v8CtiaIdCUoMa6yf/2jFsO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZFaZlxNAtDOxioyxKwEQohxdNYqsy1dJ+YwtoLg7aC2aaRknK93+fuSxdUZ/817RQIgRYEdkhMnHN5wHXgmaK5bszqXAUYk7ydstkQhGt81n3MQSgXamYl4q5QLT5RZuH0Zafp33dcUySdCUvnk/qRxStQnl7HU6VE/HQ2emtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=semEweTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="semEweTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D694AC116D0;
	Wed, 25 Feb 2026 01:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983803;
	bh=0WARkBJQlVK/6i/bHHa9v8CtiaIdCUoMa6yf/2jFsO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=semEweTU+CHR+7358GYB20o+NwK5gqm5IeELBUyLbHFUFjX0n5ClK62s1/DWaMtGv
	 6ynFWMa6kXNSOBG75zIuJzBmTUvvKEVi0zgp1YLQ+Nh/NTYmVz9HpeEtFquKdrAeaf
	 notyns4oAJ5vJ4/3a0VabjWGKsSt2PP7p0hfquVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/641] md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout
Date: Tue, 24 Feb 2026 17:16:12 -0800
Message-ID: <20260225012350.145166269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit d119bd2e1643cc023210ff3c6f0657e4f914e71d ]

When llbitmap_suspend_timeout() times out waiting for percpu_ref to
become zero, it returns -ETIMEDOUT without resurrecting the percpu_ref.
The caller (md_llbitmap_daemon_fn) then continues to the next page
without calling llbitmap_resume(), leaving the percpu_ref in a killed
state permanently.

Fix this by resurrecting the percpu_ref before returning the error,
ensuring the page control structure remains usable for subsequent
operations.

Link: https://lore.kernel.org/linux-raid/20260123182623.3718551-3-yukuai@fnnas.com
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-llbitmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 1eb434306162a..bcb6eae1c711f 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -712,8 +712,10 @@ static int llbitmap_suspend_timeout(struct llbitmap *llbitmap, int page_idx)
 	percpu_ref_kill(&pctl->active);
 
 	if (!wait_event_timeout(pctl->wait, percpu_ref_is_zero(&pctl->active),
-			llbitmap->mddev->bitmap_info.daemon_sleep * HZ))
+			llbitmap->mddev->bitmap_info.daemon_sleep * HZ)) {
+		percpu_ref_resurrect(&pctl->active);
 		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.51.0



