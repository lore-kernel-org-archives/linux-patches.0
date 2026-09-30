Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B173BFAFA;
	Wed, 30 Sep 2026 18:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794767; cv=none; b=MhtMxxgtwmnLAVtwEclkDXYbiHl/Z/19m919YfjYexnwrCRTIZqwhysrUlL8xvcZnMbj7Naew5VeJgXtgeevo7ey0hJVqoEyDrVQaHSfbtWfsZDFsc92VE0HtVeeKtP068AIxtPVbgglJ/LW2u9bcv9wjhjJZvpjCSzl3lFigDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794767; c=relaxed/simple;
	bh=dzvr+0s5letatLyo239SPECmbzaMrm4+o42IpDxn42A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1adP0XtAbVBvUH/qqT0TJODPBThGMUIg2/GIwrFhQcxI6fmkd9gA3M+DPuBGL5NrU/XCFOok/kXVZ7nkQoOWj2XN1i04l7C4apdPVEJqvjl1dclBSx5XEOsflDmJyBSL/SCIXEUmuiPoBifbMm8kLfpTgEF3aqnousVFjTL4Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id2Y6IRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id2Y6IRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD4E1F000FF;
	Wed, 30 Sep 2026 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794765;
	bh=9JeeYPhA3KoxKnRsNB2wAYRf3QmrhK7sBDzDsvqUogk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=id2Y6IRHzJJuswk+ZsklCzaKsniPV/FGLLiYO463o352dtWez6+MjpFsTmdBzAW+J
	 EYQy+578VwT8JuCmcnz9gJIXHKzY9GFxtgOUWrcVaVVWbajCPeazCUwO0IbnuBdyzY
	 O6MJEmWqZSWBaWlgh3jolOenXisjeqLeNzQPjoU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0281/1193] cachefiles: Fix double fput
Date: Wed, 30 Sep 2026 17:16:05 +0200
Message-ID: <20260930152440.408852841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit af6830cc12dfe86c832dccc9c9878a93aaa22f83 ]

Fix a double fput() in error handling in cachefiles_create_tmpfile().

Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-4-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 594e41582ae9c..048dc6b0288a5 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -495,7 +495,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}
-- 
2.53.0



