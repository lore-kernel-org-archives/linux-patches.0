Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0822509F18;
	Wed, 30 Sep 2026 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784697; cv=none; b=NkLdu3vC5lvR8P6311gRQEeKaXhnMvV+8vgYtzgoa71r5FnHPO+NiUAa+XAcYhwPfENydzPqNNa0iFLhg105m4MFCEoV1V5viPxvh3+sGZOqpegZBVgR0pF2iSy02T4rBsYVTcQyficT2xCvgOljEPq1W7eQ+B0aRLoo9Mdm5jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784697; c=relaxed/simple;
	bh=HxQ38iBVw+wN+w6U8nQsbpqflWXoKDVhNMf6MTMu/fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M931BybK5tXs8dli+46ojxzlyEaOyQGAXGctEDIayzaQ+IkzhgAGHJy+PDl25HdHYTUpiX/QHccWkOd9nmLMKxBieXzZL+oPkwWyEq7mfbqmBQkXU8BF4myK0gINAAJcr2p/G6xlbjdmwIeraNbfghw2XyXlLcRJ+xR4tGBp1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjyME5qf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjyME5qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDBD1F00893;
	Wed, 30 Sep 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784688;
	bh=aNmkm+n4PE7qLy62fsE2le6rizEz4y4IMzHZiWM66RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjyME5qf/RC9TkVyLZitmNkaDVjMfFVS49Ctw70wzWDAp75gumoH1hes/Wp/DZqkb
	 VIZHD+d4pFg41PpyP8vMdlbnLidTiHRVKz/kZW0hhgxw/gPzQvHrwL8MVtMoj9Eyet
	 leNDnCP359k/ITZGiMLBRaIiu8dScag5TEB10+zQ=
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
Subject: [PATCH 6.1 243/982] cachefiles: Fix double fput
Date: Wed, 30 Sep 2026 17:16:19 +0200
Message-ID: <20260930152422.014871034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cbd0ff47acea0..7893c607b2479 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -494,7 +494,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}
-- 
2.53.0



