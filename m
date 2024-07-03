Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748986E5ED;
	Wed,  3 Jul 2024 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006082; cv=none; b=Hfis7TPgSpLtEKqUIKi4g80dKGzJPjIH0KFo/y5gPWqzOX+rQ08aZXGfNfljoG+iVepMHFAPlo/QoV4qD0zm2RLt5l/hVZObB7SyUFhO3R1jtiO/CQV1DIj/N6QEGjFdG5EAYVcOjWs96MKPLdK/r4kELY3f7YSKkBjTG4NbKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006082; c=relaxed/simple;
	bh=nb5qmla3GsQV+Cirz0yVJut8AGVy3zDMGsvCfPKCJR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iw8leXqLYCqweERIHTxfoIpZGWk8qgJj9ZtlMA68VzPfJ0FlzpSGj24jdmgMQN7lgOrVa2CHVgK+iaCiWoqZZtuhURNwfxW11i7SazqVmGadF8jMqCmR4p72DO/Lxw3hK5IqVLiXJ15UV3xeIRDMwmhtny2HwQUT2kETh4Dw6pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyyJ8Yob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyyJ8Yob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD3AC32781;
	Wed,  3 Jul 2024 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006082;
	bh=nb5qmla3GsQV+Cirz0yVJut8AGVy3zDMGsvCfPKCJR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyyJ8Yobpdzgqa1aNfHpWL3b8+FJKEsabM714uALfnsDZgH2UVgIGAMnpN/YmKZaE
	 YZ/9/ifHG/Krxnd+it0tXDlx4dMnJSMpEC6S43DCQZOfblUwCL6wWfCicrFIsrF/wu
	 GQQT4kWg8NR6MprIkudjkifvV1oHG/gez5bp9hZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/356] media: dvbdev: Initialize sbuf
Date: Wed,  3 Jul 2024 12:40:31 +0200
Message-ID: <20240703102924.275786865@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 23a0c209744dc..661588fc64f6a 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -974,7 +974,7 @@ int dvb_usercopy(struct file *file,
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



