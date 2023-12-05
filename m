Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1F46AA0;
	Tue,  5 Dec 2023 03:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBv8AqfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCBFC433C7;
	Tue,  5 Dec 2023 03:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746506;
	bh=/bRLi6YCP1EirsaQFImgpbLHsaL+BAgO8ly3r6WC/tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBv8AqfIBvqidyFFfpi8Qbt372UwXZ5zkPjGTdkFeYMfKgTbNw4yvvIVT6QyOsloA
	 CVVbPl56JSvf5cut5/7BlKjNGJoaPk/A95mxZ8H0VgRvA9T8A1EY5GKIeogM29ObHQ
	 IF5hqxjQbUmLzP71aJ1xnMwNIa2XizTUoUAg6fJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.6 048/134] dma-buf: fix check in dma_resv_add_fence
Date: Tue,  5 Dec 2023 12:15:20 +0900
Message-ID: <20231205031538.634713653@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 95ba893c9f4feb836ddce627efd0bb6af6667031 upstream.

It's valid to add the same fence multiple times to a dma-resv object and
we shouldn't need one extra slot for each.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: a3f7c10a269d5 ("dma-buf/dma-resv: check if the new fence is really later")
Cc: stable@vger.kernel.org # v5.19+
Link: https://patchwork.freedesktop.org/patch/msgid/20231115093035.1889-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |    2 +-
 include/linux/dma-fence.h  |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -301,7 +301,7 @@ void dma_resv_add_fence(struct dma_resv
 
 		dma_resv_list_entry(fobj, i, obj, &old, &old_usage);
 		if ((old->context == fence->context && old_usage >= usage &&
-		     dma_fence_is_later(fence, old)) ||
+		     dma_fence_is_later_or_same(fence, old)) ||
 		    dma_fence_is_signaled(old)) {
 			dma_resv_list_set(fobj, i, fence, usage);
 			dma_fence_put(old);
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -499,6 +499,21 @@ static inline bool dma_fence_is_later(st
 }
 
 /**
+ * dma_fence_is_later_or_same - return true if f1 is later or same as f2
+ * @f1: the first fence from the same context
+ * @f2: the second fence from the same context
+ *
+ * Returns true if f1 is chronologically later than f2 or the same fence. Both
+ * fences must be from the same context, since a seqno is not re-used across
+ * contexts.
+ */
+static inline bool dma_fence_is_later_or_same(struct dma_fence *f1,
+					      struct dma_fence *f2)
+{
+	return f1 == f2 || dma_fence_is_later(f1, f2);
+}
+
+/**
  * dma_fence_later - return the chronologically later fence
  * @f1:	the first fence from the same context
  * @f2:	the second fence from the same context


