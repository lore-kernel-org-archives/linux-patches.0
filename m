Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D420356754;
	Sat, 12 Sep 2026 08:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200677; cv=none; b=F7RyjOAFsMFw1AiQm0dVdnhx2JIEl1auW3qarUU4esmbvCFg1sKJ8vWi+Do/CTcxCRw9uYhCQ6QZ83wGCi6jvyMPfvAnUvhpIz5UOZVh3+Hwu9EV5OYDveuoOivrDMylWxd7+RGJQfw419PtJ+OH3rTvudzI+wmNNh2apJlGtoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200677; c=relaxed/simple;
	bh=ZIqYQ39ag+r/mECebtvWANHO93iztUtQuu7Ij8UYUOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6MO44EiZIW5UL7hyt5xoUBDmEXPyR8HtCfJna91Nxlz7XdYOfpg+64wBQ9NTZ19lmR6mhyUerk8/+0Z1qsTFK2i1rzkrwHpsS8r//PUeIX9o+G12u/bgF1yb9sze8OiIXgPXBu7p3KeZ4zB3xKVEQa8xCUCKYvyjTAHUxy3kbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0hW8YeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0hW8YeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4121F00893;
	Sat, 12 Sep 2026 08:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200676;
	bh=B//lOKPqlgZEUnlIicmY8ZUMlWM5NRjGfe4WWp7J6V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0hW8YeFcUKnoaJY8dawTs76CsVOtF/KrLn7FsAlIPzJvvkENKK0lZLeR4GLbcEP2
	 3wkzWd8DQoI1Fwh73YCw5AgV2iu7LS1GDZP0QCsv9PUJpV1R+qSEPirdK00fo4ZCxH
	 DCVxFQu9xDqYcY0J3O+11WlS2SVzbpbyAQRpbj5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0839/1815] md/bitmap: resume array on backlog_store() error path
Date: Sat, 12 Sep 2026 08:43:09 +0200
Message-ID: <20260912065708.611030104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 2911cd0a0f4366a7e06832bc5f0a7fdcc138e4dc ]

backlog_store() suspends the array before checking whether a write-mostly
device exists. If no such device exists, the error path only unlocks
reconfig_mutex and leaves the array suspended, blocking subsequent I/O.

Use mddev_unlock_and_resume() to release both states.

Fixes: 58226942ad3d ("md: use new apis to suspend array before mddev_create/destroy_serial_pool")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260718034236.4119093-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7d778fe1c47ca..9730aab9bcff3 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2857,7 +2857,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!has_write_mostly) {
 		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
 				    mdname(mddev));
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



