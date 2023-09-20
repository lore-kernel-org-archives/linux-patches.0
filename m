Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE07330F8E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3560DC433C7;
	Wed, 20 Sep 2023 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212193;
	bh=X2jkQ8xs2psq/wC8YgvCdTRB8DAuwEIR4gXiDAl7tCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dS8nAIDGmx6MjNSq/A6aRwOCz+RFrAyQ8dNJ9Vq9gNWfzyGprNojJpiCaUyqDEZBv
	 k1dgDUNVfOOgPOWWWIZ6C4OZ+IOd0glVMYzLGUQkNDq/p4n+6bfkgo68AqyZuhs7g+
	 ALlImeRWgl0ffIvKoQTdZ03m0Wz8+RghWhaHPmuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Marson <bmarson@redhat.com>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 4.19 185/273] dlm: fix plock lookup when using multiple lockspaces
Date: Wed, 20 Sep 2023 13:30:25 +0200
Message-ID: <20230920112852.229916024@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

commit 7c53e847ff5e97f033fdd31f71949807633d506b upstream.

All posix lock ops, for all lockspaces (gfs2 file systems) are
sent to userspace (dlm_controld) through a single misc device.
The dlm_controld daemon reads the ops from the misc device
and sends them to other cluster nodes using separate, per-lockspace
cluster api communication channels.  The ops for a single lockspace
are ordered at this level, so that the results are received in
the same sequence that the requests were sent.  When the results
are sent back to the kernel via the misc device, they are again
funneled through the single misc device for all lockspaces.  When
the dlm code in the kernel processes the results from the misc
device, these results will be returned in the same sequence that
the requests were sent, on a per-lockspace basis.  A recent change
in this request/reply matching code missed the "per-lockspace"
check (fsid comparison) when matching request and reply, so replies
could be incorrectly matched to requests from other lockspaces.

Cc: stable@vger.kernel.org
Reported-by: Barry Marson <bmarson@redhat.com>
Fixes: 57e2c2f2d94c ("fs: dlm: fix mismatch of plock results from userspace")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/plock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -469,7 +469,8 @@ static ssize_t dev_write(struct file *fi
 		}
 	} else {
 		list_for_each_entry(iter, &recv_list, list) {
-			if (!iter->info.wait) {
+			if (!iter->info.wait &&
+			    iter->info.fsid == info.fsid) {
 				op = iter;
 				break;
 			}
@@ -481,8 +482,7 @@ static ssize_t dev_write(struct file *fi
 		if (info.wait)
 			WARN_ON(op->info.optype != DLM_PLOCK_OP_LOCK);
 		else
-			WARN_ON(op->info.fsid != info.fsid ||
-				op->info.number != info.number ||
+			WARN_ON(op->info.number != info.number ||
 				op->info.owner != info.owner ||
 				op->info.optype != info.optype);
 


