Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3984140F754;
	Fri,  4 Sep 2026 05:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498656; cv=none; b=e5cbbgdWteze8VFbsSHFNApDLvl/dw/p3pQM+X1irU03oAmKX4oRrXsCswrBDs6nEzt32KE6rMF7UzXw3Oi4rnewREOKq3DdRI2edhgJAjrMxn3dHeKL0VOGZ5MdEcz3oYHY3MiofQtFtv0QUmkkYbYD2vsyq0/wlyQzVliVxxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498656; c=relaxed/simple;
	bh=7xz8y3YpzKVpL6YPtylLgeEv9cJ1vfatLc4Mn3gc0p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJHoHK238AsadqG2bYYxQl+e6priSuBYX52YW+IMLHjU8DLg+iosE9ef/q7XD9iDbrja9r2BF0kPczWFZofZNiUwaLXFoaQvKEs72G0r4AClvYzdPBWIR2VnewnT+fOIbiUHsW9Ddmo1idlZWbKXQszKWe4gKYenF4Bc6lBRsm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKQNmmTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKQNmmTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924691F00A3D;
	Fri,  4 Sep 2026 05:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498655;
	bh=+YjXa8Ctxflq815dmOdIG7/HtWOIUS0ASzKKMCrFbaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKQNmmTdXaIeoKHF3EHkye9JSw/ubZvw8E1wMv2Gjx5VScrPqMgIgioyAS/YqDVXR
	 ynOatKxvcFB8P7YtLihAch7MBhLACBvj7LAolYrRWrVJKKjMmmICAr9xocuf4rck/I
	 n2eJ6VkPoRjSJ3uzEqNVx6dLdtqRiRz7F8GZlWRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 141/713] NFSD: fix up error returned by write_threads()
Date: Fri,  4 Sep 2026 06:51:49 +0200
Message-ID: <20260904045806.989846030@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

commit 75e620912c815801ea241e133ba34c9e8cf2cbb1 upstream.

Previously, writing 0 to /proc/fs/nfsd/threads would return 0 if the
NFS server wasn't running.  After commit 14282cc3cfa2 ("NFSD: don't
start nfsd if sv_permsocks is empty"), -EIO is returned. Existing
scripts don't expect this behavior.

Add a check to bypass the call to nfsd_svc() when newthreads is 0 and
the NFS server is already stopped.

Fixes: 14282cc3cfa2 ("NFSD: don't start nfsd if sv_permsocks is empty")
Cc: stable@vger.kernel.org
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260608131402.95625-1-smayhew@redhat.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -420,6 +420,7 @@ static ssize_t write_threads(struct file
 	char *mesg = buf;
 	int rv;
 	struct net *net = netns(file);
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	if (size > 0) {
 		int newthreads;
@@ -430,7 +431,10 @@ static ssize_t write_threads(struct file
 			return -EINVAL;
 		trace_nfsd_ctl_threads(net, newthreads);
 		mutex_lock(&nfsd_mutex);
-		rv = nfsd_svc(1, &newthreads, net, file->f_cred, NULL);
+		if (newthreads > 0 || nn->nfsd_serv != NULL)
+			rv = nfsd_svc(1, &newthreads, net, file->f_cred, NULL);
+		else
+			rv = 0;
 		mutex_unlock(&nfsd_mutex);
 		if (rv < 0)
 			return rv;


