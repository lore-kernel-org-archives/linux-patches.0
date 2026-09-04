Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28156348C47;
	Fri,  4 Sep 2026 05:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500752; cv=none; b=YZ7V80aprn6yX15E3DsdLS4wXExoN46e5wjcBmKcb3lX4vOTd0VvOPvoJdRNnG0CbYZ0elnJli+nVW7QxEUEP9bSZkkr8sfAkueWaLJpwo6aPQfoOE7jKPo3u32ANmbez0jFzg1h8MRR8vzs0ir6vkXeBnFMX+u36kEpbbPkgSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500752; c=relaxed/simple;
	bh=b04w9GeTN5froKzVTZIiPjneVfFXXuHDytpFnaUkm68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/KYy8i8OV5xuHL4ETeNH/gRQiocTMEbS8Z8rB8ZOEOBZo/DYHzsZwQov4R1nYoHWts8umtVOlH7INhV7F31XKLmKr785xeY0pSEYExbtRbo8FzPKx8Cv4wG9oLmPcufIyz4LyO7IqwDYXZoloFRthJgVojozvu4feAcEsPDVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS4jTeVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS4jTeVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806481F00A3D;
	Fri,  4 Sep 2026 05:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500751;
	bh=Z+RDAW3gmqgqotPWFpfP4kgcS3ZTQu2A01Fo9UY3E90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sS4jTeVkvGo5xDgzRlAjVUJNhX21N3sLkQ7rGuceV6K+z5w8nkJVKfJVxly1DfhTe
	 hSljewfN4GA/GEonl14G/vOjX8UelS4hpKNO1hJL6EBW390oG0URW9X2QIYUgMkcVt
	 WZQN1F7jpw/hLvF7jGoxKIowxVJZVqk4v0G9lf2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 124/552] nfsd: defer setting NFSD4_CALLBACK_RUNNING in deleg_reaper
Date: Fri,  4 Sep 2026 06:54:41 +0200
Message-ID: <20260904045750.926212836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 108969960dc54de673869814c5f37c22f6cf404a upstream.

deleg_reaper() sets NFSD4_CALLBACK_RUNNING before checking the
5-second rate limit and cl_cb_state gates.  When either gate fires
the loop continues without queuing callback work, so the bit's only
clear site in nfsd41_destroy_cb() is never reached and RECALL_ANY
dispatch is permanently disabled for the affected client.

Move the test_and_set_bit() below both non-queueing gates so the
bit is taken only when nfsd4_run_cb() will be called.

Fixes: 424dd3df1f99 ("nfsd: eliminate cl_ra_cblist and NFSD4_CLIENT_CB_RECALL_ANY")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-cb_recall_any_callback_running_stuck-v1-1-310011a028f3@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7083,12 +7083,12 @@ deleg_reaper(struct nfsd_net *nn)
 			continue;
 		if (atomic_read(&clp->cl_delegs_in_recall))
 			continue;
-		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
-			continue;
 		if (ktime_get_boottime_seconds() - clp->cl_ra_time < 5)
 			continue;
 		if (clp->cl_cb_state != NFSD4_CB_UP)
 			continue;
+		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
+			continue;
 
 		/* release in nfsd4_cb_recall_any_release */
 		kref_get(&clp->cl_nfsdfs.cl_ref);


