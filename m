Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECE71514DC;
	Tue,  2 Jul 2024 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941393; cv=none; b=k9pwegZXh0xNGMkXP3PwrgRoX62Ty+pphk4SzHtc27Hv+VwxxQeJt/KyjWNGxbZ7jASaed3j6WOh2A5bcIL73peo3SKqlGIm1fzc6UdYuMaYY4R1Pua4AbReQqpO43JGJ6GtOYHvuFXHFsr9h8qdyvfnbug1To1zbi0j9A+Snb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941393; c=relaxed/simple;
	bh=tOOezIBvnK8YvKWcxsuwCVh/oW+0jaxcdmwSuDufhPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ApS7flLdB5VCGNB7cpFp0ssh3ba9ABwkUCIC1sXKuhSHF05wyKUtDlZkY/O9yPi6t20mYjUzV7swphDlFvm81yKd1FAElhsydpktrhl+AMdgE6tndrRxn5zhmOH0312wbA67KFliYVX86QdkU3nmteooZAxoSIdyFSc1fxQKJKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6ltkHxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6ltkHxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAD4C116B1;
	Tue,  2 Jul 2024 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941393;
	bh=tOOezIBvnK8YvKWcxsuwCVh/oW+0jaxcdmwSuDufhPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6ltkHxcgue/1vhtZ0KFNceHz8W4uJ7V2L2HFDoxOlvTaWgTkIfTvwHJIQxGMxIVU
	 bjyEO982hpKvcqFydkJeSI/MDl3cYpdiLePFj6/I0Thr04LaHQXRmmMEYkSSfTsHsq
	 lhndYiiazBdINweS8W7J6UB6lhFHRbtn6nlXtJDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/128] media: dvbdev: Initialize sbuf
Date: Tue,  2 Jul 2024 19:04:11 +0200
Message-ID: <20240702170228.126787230@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 17d1316de0d7dc1bdc5d6e3ad4efd30a9bf1a381 ]

Because the size passed to copy_from_user() cannot be known beforehand,
it needs to be checked during runtime with check_object_size. That makes
gcc believe that the content of sbuf can be used before init.

Fix:
./include/linux/thread_info.h:215:17: warning: ‘sbuf’ may be used uninitialized [-Wmaybe-uninitialized]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index aefee2277254d..04b7ce479fc38 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -964,7 +964,7 @@ int dvb_usercopy(struct file *file,
 		     int (*func)(struct file *file,
 		     unsigned int cmd, void *arg))
 {
-	char    sbuf[128];
+	char    sbuf[128] = {};
 	void    *mbuf = NULL;
 	void    *parg = NULL;
 	int     err  = -EINVAL;
-- 
2.43.0



