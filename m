Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253DA342CAF;
	Tue, 11 Nov 2025 01:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824655; cv=none; b=IHV2lbTRviB+RXes+qXdD8IjG5MOcjlxiLbXrvNz7Lqel4hAehelLVW1tJZ5meonjZEdyRB8ctNPk7m4wpQt1YtTr4OpGPzUXj5HwqFXKrMAZWfxyJsYCr3QjYRXAfEubEBQhqMWCirx1yj/lFH7VhMxudiGo+UXfIju8gWcz4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824655; c=relaxed/simple;
	bh=RAWj0yeuDOC1ALKlnUNGg8cqR5aSEJ6B5gM+EOe6sgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otXzXUBvC6158eXAsRKlfpwBNMk1j0OqjaPcbK0yaKBoFrhlw3JLjlqp4B2KqPOcR//I9PIn1PGy9r0DMCGlmFHLpGpbPXMS5EJcb4bkMUxo/9tFhB9wJw0OvZcI+fRMm0hu96qb7kn88SECdMUpyCGX/HYorVkRqM22uQDFlIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3bU1g20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3bU1g20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BC2C113D0;
	Tue, 11 Nov 2025 01:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824654;
	bh=RAWj0yeuDOC1ALKlnUNGg8cqR5aSEJ6B5gM+EOe6sgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3bU1g20LGgb0b1VWJZjRnzsVK/gkLU3l2s5G1/mhUsmBsWxbj8LzKjBRH+VmbGUl
	 AiFrWncReQnBUejQmD8mVjwznPDIAULxaqMIwEzpV8e9oELM5tP/uCE0CqemGX/uaE
	 5sUMtrWiUdvDsNj4ERI1c3WZn9SMdmD2fStxtWTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 493/565] ceph: fix potential race condition in ceph_ioctl_lazyio()
Date: Tue, 11 Nov 2025 09:45:49 +0900
Message-ID: <20251111004538.023992037@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

[ Upstream commit 5824ccba9a39a3ad914fc9b2972a2c1119abaac9 ]

The Coverity Scan service has detected potential
race condition in ceph_ioctl_lazyio() [1].

The CID 1591046 contains explanation: "Check of thread-shared
field evades lock acquisition (LOCK_EVASION). Thread1 sets
fmode to a new value. Now the two threads have an inconsistent
view of fmode and updates to fields correlated with fmode
may be lost. The data guarded by this critical section may
be read while in an inconsistent state or modified by multiple
racing threads. In ceph_ioctl_lazyio: Checking the value of
a thread-shared field outside of a locked region to determine
if a locked operation involving that thread shared field
has completed. (CWE-543)".

The patch places fi->fmode field access under ci->i_ceph_lock
protection. Also, it introduces the is_file_already_lazy
variable that is set under the lock and it is checked later
out of scope of critical section.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1591046

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/ioctl.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index e861de3c79b9e..15cde055f3da1 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -246,21 +246,28 @@ static long ceph_ioctl_lazyio(struct file *file)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_inode_to_fs_client(inode)->mdsc;
 	struct ceph_client *cl = mdsc->fsc->client;
+	bool is_file_already_lazy = false;
 
+	spin_lock(&ci->i_ceph_lock);
 	if ((fi->fmode & CEPH_FILE_MODE_LAZY) == 0) {
-		spin_lock(&ci->i_ceph_lock);
 		fi->fmode |= CEPH_FILE_MODE_LAZY;
 		ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++;
 		__ceph_touch_fmode(ci, mdsc, fi->fmode);
-		spin_unlock(&ci->i_ceph_lock);
+	} else {
+		is_file_already_lazy = true;
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (is_file_already_lazy) {
+		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
+		      ceph_vinop(inode));
+	} else {
 		doutc(cl, "file %p %p %llx.%llx marked lazy\n", file, inode,
 		      ceph_vinop(inode));
 
 		ceph_check_caps(ci, 0);
-	} else {
-		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
-		      ceph_vinop(inode));
 	}
+
 	return 0;
 }
 
-- 
2.51.0



