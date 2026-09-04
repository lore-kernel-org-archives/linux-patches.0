Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A4F414DF6;
	Fri,  4 Sep 2026 05:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500002; cv=none; b=bJdrYmd4d+KXbOn4d9OS2uFUsdUMT2PYFWTNRARjWG+E0r7Fb211x63lw+bmVpHAnuQP0zks8vNRgBupUAvkiWnDz6SYuTQVO3BSr1Rjr9iI95T3kEXUqSo++3Wo9S45kWq3sPtqJ6R85TEtLc1IUMDaG3VNnr+Y/NvY+wTK+sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500002; c=relaxed/simple;
	bh=nMI2hWVyamkHxGOSBsqNmeUT4ezNYDDL0eO/90HUC8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PC7EgctaTpOcuU9Wysgl01yvZYYuR2AT8iVsFaQ8ibQdzOSR5+ag3bPAFhNHVPUCN5ve9jzaFOFdwyLRoZjIygoMew3W0gf5x5oJP5zqC9ZEPDwIBxksaekXAZ12Alv+Ey7QaRv+Nq+dU11qFPgiRhu2DauRkVNwiL4YNsTLTeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkKsaUbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkKsaUbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110C21F00A3D;
	Fri,  4 Sep 2026 05:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500001;
	bh=+1HnHPOrVUAshOahmvQHf5xU7sUH3LYvEeotI6a3oZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkKsaUbbWFCJc+7qVAEsTfqXVIbXXnHJLBfV+89pZlpAa3HvD2qz0K+Gz95CEWKq2
	 l4WcUiELvtPoTJMYRrJeVbvgrfUT7ii9B5liEvmPdcLqy8+E4D2lueb5+78LcCCGok
	 OcfArsQ0WRjVBoMAbmbS0FAyCSn7jY81yFzA4ES0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 7.2 589/713] interconnect: Fix use after free in icc_get() and of_icc_get_by_index()
Date: Fri,  4 Sep 2026 06:59:17 +0200
Message-ID: <20260904045817.021686367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -548,7 +548,7 @@ struct icc_path *of_icc_get_by_index(str
 	path->name = kasprintf(GFP_KERNEL, "%s-%s",
 			       src_data->node->name, dst_data->node->name);
 	if (!path->name) {
-		kfree(path);
+		icc_put(path);
 		path = ERR_PTR(-ENOMEM);
 	}
 
@@ -646,8 +646,9 @@ struct icc_path *icc_get(struct device *
 
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


