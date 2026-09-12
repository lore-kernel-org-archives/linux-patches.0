Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B9B486424;
	Sat, 12 Sep 2026 18:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237134; cv=none; b=reVv2Ntol1NPQFdnCvhwYPVR335EI7NV7jindIkb6BO+NVaVltxLoc1FqKH9fl+aEj+fDQOc9Z/OcBi7NRO3q4uHa7uQayz1shmnI3A0hOmk8cmQ+rnQ7Vn0TD3lq6MN6xQLhA0zcaq9+3QcRKNnGbsApB75Nmq6hIE6QFccUjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237134; c=relaxed/simple;
	bh=I1syv+R/8NNQ1pv50wjxIidk+3pl1VYIfIHTbhSW+fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC6rhrNrAFi+ztPvGEE82u2kMiM5TM+hPIlTTsRvg7ZE/adwiAn+FO/P2JjFUX8rVWCbwhx2c6EKdtr1Qtn8oX4TfgDZfI1d4NyE6LYcA2Mcg12EXuwG/aMbchWNRspwGte9nIvNhggBCdd09M0aeoCA/Vo287MilmiQyDkGiMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiO45Lap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiO45Lap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0CB1F000FF;
	Sat, 12 Sep 2026 18:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237132;
	bh=bJUgg4Y2/fJTwH9CqXwRVN/xVQNaBNJb1q3gFDr+I9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiO45LapHWjsro1IWKSM2gxGZQu3eFfkCySYw8itMXZGzVlCRJakzSY2O6j5MD51V
	 HjhDreob+jCH9A/sB5PxkaaHfpmXzE80Sxeu6gcd60+lB/o0kpUdI9wdNW2O5riVZz
	 OR7ncAJdB6FSXuBxHzUtL1GGxwM0zCQwWh+78Beo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.15 170/935] interconnect: Fix use after free in icc_get() and of_icc_get_by_index()
Date: Sat, 12 Sep 2026 08:53:20 +0200
Message-ID: <20260912065530.717549223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 25c7e242aca084fdc1098248194032317dca625d upstream.

In of_icc_get_by_index() and icc_get(), if the dynamic allocation for
path->name fails via kasprintf(), the error handling path directly
calls kfree(path) to free the path object and returns an error.

However, prior to this point, path_find() calls path_init(), which
already links the path's requests into the req_list of the respective
interconnect nodes via hlist_add_head(). Directly invoking kfree(path)
leaves dangling pointers in the hlist. A subsequent call to icc_get()
or icc_set_bw() will traverse or modify these corrupted lists, triggering
a slab use afterfree.

KASAN report showing the vulnerability when reproducing via debugfs:

  BUG: KASAN: slab-use-after-free in path_find+0x6f8/0xcfc
  Write of size 8 at addr fff000000d43f748 by task sh/1
  ...
  Call trace:
   kasan_report+0xac/0xfc
   path_find+0x6f8/0xcfc
   icc_get+0x148/0x380
   icc_get_set+0xf8/0x2d0
  ...
  Freed by task 1:
   kfree+0x1a0/0x4a4
   icc_get+0x2cc/0x380
   icc_get_set+0xf8/0x2d0

Fix this by replacing kfree(path) with the proper teardown function,
icc_put(path), which safely removes the requests from the req_list using
hlist_del() and drops the provider usage references before freeing the
memory.

Additionally, in icc_get(), ensure that the icc_lock mutex is released
prior to calling icc_put(path) to avoid a deadlock, as icc_put()
internally acquires the same lock.

Fixes: 3791163602f7 ("interconnect: Handle memory allocation errors")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://patch.msgid.link/20260416190840.1753468-1-visitorckw@gmail.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -508,7 +508,7 @@ struct icc_path *of_icc_get_by_index(str
 	path->name = kasprintf(GFP_KERNEL, "%s-%s",
 			       src_data->node->name, dst_data->node->name);
 	if (!path->name) {
-		kfree(path);
+		icc_put(path);
 		path = ERR_PTR(-ENOMEM);
 	}
 
@@ -748,8 +748,9 @@ struct icc_path *icc_get(struct device *
 
 	path->name = kasprintf(GFP_KERNEL, "%s-%s", src->name, dst->name);
 	if (!path->name) {
-		kfree(path);
-		path = ERR_PTR(-ENOMEM);
+		mutex_unlock(&icc_lock);
+		icc_put(path);
+		return ERR_PTR(-ENOMEM);
 	}
 out:
 	mutex_unlock(&icc_lock);


