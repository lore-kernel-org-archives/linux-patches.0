Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512041D22C;
	Fri,  4 Sep 2026 06:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502786; cv=none; b=Q+CzkOwUIR8xff9cKanh8pbWlViFdKbZQaOYBkVI3NkNLZMqS4yqbhU3m8hsmwVCVT1bK11HWSUO0A9vSWdSBXVkyZmpamHCsOIBzh58ZP+Tla8qf/PAnWH74tayJ6ZFgSANG4JuIGgoMa7iOFikuk0kcBFUGrPIHn/4tBtKoFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502786; c=relaxed/simple;
	bh=At4EwaErFibsqap8wdMzaj2agZJzuaOhHJEC98C4Aic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZSa4AQfG3imfI4kW1g03lqBs+M6d0GFRhWgziHBjeM5LtTRC236UMvAJT3ldIul5yVLnIcLBZbB+etn+3XsM8S93qwSuV8HdIwt/S3CeT4zuBDdYipayJTb+Of5G4IgPWuvIIvidAYTAMEk6dklbqPSYm6FYI88MSd2p37IeEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SO0+Prkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SO0+Prkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606471F00A3D;
	Fri,  4 Sep 2026 06:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502784;
	bh=MD2FnIC5rEVHjmCozIEFae5+yHMz7eBMdoi+EYqi/sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SO0+PrkwJHkLkG6NZUs0Yolj/UZ8JJ+UOvbOEfZcUrolaKebAjNTLh2gQEmNBT+y1
	 IigpF/SDTZkn2OwORxwtsMl8UQIiMBbek2nHdP16/Gs3pnmyaLtLnAaXj6zsnfXyHG
	 5DM6fSHjju4fohsN02l1hiHepegPbN4BPnZT/kx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.12 330/403] interconnect: Fix use after free in icc_get() and of_icc_get_by_index()
Date: Fri,  4 Sep 2026 07:02:13 +0200
Message-ID: <20260904045742.331418110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -526,7 +526,7 @@ struct icc_path *of_icc_get_by_index(str
 	path->name = kasprintf(GFP_KERNEL, "%s-%s",
 			       src_data->node->name, dst_data->node->name);
 	if (!path->name) {
-		kfree(path);
+		icc_put(path);
 		path = ERR_PTR(-ENOMEM);
 	}
 
@@ -624,8 +624,9 @@ struct icc_path *icc_get(struct device *
 
 	path->name = kasprintf(GFP_KERNEL, "%s-%s", src_node->name, dst_node->name);
 	if (!path->name) {
-		kfree(path);
-		path = ERR_PTR(-ENOMEM);
+		mutex_unlock(&icc_lock);
+		icc_put(path);
+		return ERR_PTR(-ENOMEM);
 	}
 out:
 	mutex_unlock(&icc_lock);


