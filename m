Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0961AA1F4;
	Fri,  4 Sep 2026 05:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498715; cv=none; b=QJzzcF9O9LsA2QxdOh9Ct7NhrMOrkPxqlh3SQ5oaZsXklGvLtvuEXJYImY5GO9fJquYJTn5BLQ/eZFqVqVM1n7GXBFCAU/7RR58bVhKQ3Ax1kZrQQn/rdG1Nn7egt6c//b0lvF9G4cq5J7k0qUoPC3azOnDRyyOasvl3U/CQa2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498715; c=relaxed/simple;
	bh=6z5cKAB5Bp39MOlqmnyejHOjabFzyed8DPnXCK8HM88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwrCD/o1HhJQV9JjW8VEPFYul/OFVVsNN0dOHPRVJzwnsInkmsm2ko7tpW31Cslm8oSM08mbDh8+c3Bqouz3Wq/qRBDQGbYjC2GajDWqDjoX+zbHpDVyi5V4S3biJ/BTr1qp7nBJbjINe/kLAWcblfd/E3hYw0elbAyqP+2cx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uP01NDli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP01NDli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993E01F00A3D;
	Fri,  4 Sep 2026 05:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498714;
	bh=z6PT4cl31x7aI5RBAOsvu+I5+qLjZpt9XM7RuRfpU5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uP01NDlie7ajWyJkqSF1o+Yd9YjqjdqDhiLNigpo/jkIhNFpS7iibb0Aks78t+0JM
	 ZyJGciyLON+p0HADBqUTFk/bfJSZIMmIjixD5sjqDiyKzYO9EPXNYTulzRxFCPDpZW
	 aQTstuxc0EHfwNQX2dX8Es7Q1Ex2fzKVBqEEOYKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 160/713] nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()
Date: Fri,  4 Sep 2026 06:52:08 +0200
Message-ID: <20260904045807.410539179@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 4e475be769aa9f7a2c1ce55a2b8592cfccacddcc upstream.

The BOTH_TIME_SET branch calls fh_verify() early so setattr_prepare()
can inspect the dentry. This causes nfsd_setattr() to skip
fh_want_write(), so notify_change() runs without a mount write
reference.

Add the missing fh_want_write() call after the early fh_verify().

Fixes: cc265089ce1b ("nfsd: Disable NFSv2 timestamp workaround for NFSv3+")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-11-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsproc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -82,6 +82,7 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		.na_iattr	= iap,
 	};
 	struct svc_fh *fhp;
+	int hosterr;
 
 	dprintk("nfsd: SETATTR  %s, valid=%x, size=%ld\n",
 		SVCFH_fmt(&argp->fh),
@@ -117,6 +118,12 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		if (resp->status != nfs_ok)
 			goto out;
 
+		hosterr = fh_want_write(fhp);
+		if (hosterr) {
+			resp->status = nfserrno(hosterr);
+			goto out;
+		}
+
 		if (delta < 0)
 			delta = -delta;
 		if (delta < MAX_TOUCH_TIME_ERROR &&


