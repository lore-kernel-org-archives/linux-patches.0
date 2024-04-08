Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459F179955;
	Mon,  8 Apr 2024 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584565; cv=none; b=ZILfaKcYw85nli/CyWRAhtO/6ZB4ZwNn/7p2keNWxdSRqqlmo/4K93g6QWRC/lD70VHMJJofKxf16gsGMG0K++CZckwzF8xSOYBDrvkakU1FaXqHryTR0X9qm5mz2Wi0FY3kxKMqkNIxmYoWrpK7329gqzIhDSF3RFW4fTRUsgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584565; c=relaxed/simple;
	bh=wMNyMdjz8bCLJR06HWA5o+kxzcbwvMtqF+e+uGHQ4bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/e7e3cuQIKT8C/Q/kYkAF6H/Gl27jP+LW6lwlDCgwuACC5nYRTlakNQLNMrDZWDwm8xZFYf285pu5PE2tt6IGmxDX437MWC0MuWH/fH/dVdeovL9+judO4WLdHOMOK0fsuTRGpR0qNskTdcjL1GaO1P/KKPx7MfYCJ/+XIGsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gC9nAX2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gC9nAX2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3987C433C7;
	Mon,  8 Apr 2024 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584565;
	bh=wMNyMdjz8bCLJR06HWA5o+kxzcbwvMtqF+e+uGHQ4bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gC9nAX2PtivnqFd2vfA4iMwTZD7XsVvW5d2FRK8CPhSuMg7BJjfSlS7n72TtgzS/T
	 iFzSWZspHc0eX5SrgyqFGXuMNJMmIOvPGkH25qLCbW1sV9KPI/zbf2jSD7obowgqVC
	 /C3cBJLVmm58nu+kfbL8ZQrIzbAqLWG5jCwEJqd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 480/690] NFSD: Flesh out a documenting comment for filecache.c
Date: Mon,  8 Apr 2024 14:55:46 +0200
Message-ID: <20240408125417.007929279@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b3276c1f5b268ff56622e9e125b792b4c3dc03ac ]

Record what we've learned recently about the NFSD filecache in a
documenting comment so our future selves don't forget what all this
is for.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 13a25503b80e1..d681faf48cf85 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -2,6 +2,30 @@
  * Open file cache.
  *
  * (c) 2015 - Jeff Layton <jeff.layton@primarydata.com>
+ *
+ * An nfsd_file object is a per-file collection of open state that binds
+ * together:
+ *   - a struct file *
+ *   - a user credential
+ *   - a network namespace
+ *   - a read-ahead context
+ *   - monitoring for writeback errors
+ *
+ * nfsd_file objects are reference-counted. Consumers acquire a new
+ * object via the nfsd_file_acquire API. They manage their interest in
+ * the acquired object, and hence the object's reference count, via
+ * nfsd_file_get and nfsd_file_put. There are two varieties of nfsd_file
+ * object:
+ *
+ *  * non-garbage-collected: When a consumer wants to precisely control
+ *    the lifetime of a file's open state, it acquires a non-garbage-
+ *    collected nfsd_file. The final nfsd_file_put releases the open
+ *    state immediately.
+ *
+ *  * garbage-collected: When a consumer does not control the lifetime
+ *    of open state, it acquires a garbage-collected nfsd_file. The
+ *    final nfsd_file_put allows the open state to linger for a period
+ *    during which it may be re-used.
  */
 
 #include <linux/hash.h>
-- 
2.43.0



