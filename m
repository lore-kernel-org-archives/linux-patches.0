Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457444FD27E;
	Thu, 17 Sep 2026 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664778; cv=none; b=o4k5ToAeRVOhgZdeE/ffpr2gAc61/WPrbJ27jAzZff8v/0VSfALrdPy5FN/L6wyP1by4O4Veq2IQiGA//PJ987G0ApuBdra3BCqT88ba1u205dyHHRe5n2ywj2KaqYYdjS/B1j4Z+g4iuFIebU6Tk5O/AhQY7bLTBVHR9fjs79I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664778; c=relaxed/simple;
	bh=9MezfVXIGebtogiGKf0/+yJF3RDtAM9mH0Mnc//mWQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufFTUkwQHOKwcowX0MkVmJUxJMV62LX7tUpnnMXixK1+qz2bX00qDdfECHl9KLryArMeqX+Y8xffMUX+JQX/vu7qAvf4KpxvLYVjvXmiUGWH3g61x/a6x1k/oyQnDEWdhLv+qnJuh/3VDHGHf3A5juwnLNFomijEtzHnnUhVOgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/vjqGot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/vjqGot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B2E1F000FF;
	Thu, 17 Sep 2026 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664776;
	bh=SaZY03bHdzzQ9p4HKAyFmV+6FHHmo4gfwd9HFVzRjfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/vjqGotwErDf7jmt3pRwnNZxpRpLMrAKG3oGW4tgDj+EunbxJnxB9PJ2uSZrxzDC
	 nYXHA+582E/kKcSvKKnbj+YD6fTBqrPePriqZPe4WgyCWjZJy74yUfEFe3Z8GV+FsH
	 Tecx4NZYtO4pJQYMdBzr99O2LlGpz7n4zEoNt9oY=
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
Subject: [PATCH 6.18 0486/1250] cachefiles: Fix double fput
Date: Thu, 17 Sep 2026 16:04:41 +0100
Message-ID: <20260917151605.139938192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index d1edb2ac38376..eae5045d50081 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -499,7 +499,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}
-- 
2.53.0



