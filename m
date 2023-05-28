Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CCD611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B3CC433D2;
	Sun, 28 May 2023 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303148;
	bh=SKnT9DdmycCLFVp9Sa4n1Kw/lLPO+McGuDN4gPJE4qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRSyQ9Igv4Kr6Mf+vUO7XS5Zl2Enid8pWyg/+UG668PX9wXRViDsjYjRFUO7vg2Qh
	 c2d+1n3TFxL7rVdc5ainZv/kSbPsC9y10yRt9IblB6FrtqL2mOqYmuPh1o6GMxqyie
	 GCbVGc4VnVa2o6gVPstomOqpmEIi2yakyo6QINU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Schilder <frans@dtu.dk>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 146/211] ceph: force updating the msg pointer in non-split case
Date: Sun, 28 May 2023 20:11:07 +0100
Message-Id: <20230528190847.139549261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit 4cafd0400bcb6187c0d4ab4d4b0229a89ac4f8c2 upstream.

When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
request may still contain a list of 'split_realms', and we need
to skip it anyway. Or it will be parsed as a corrupt snaptrace.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61200
Reported-by: Frank Schilder <frans@dtu.dk>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/snap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1008,6 +1008,19 @@ skip_inode:
 				continue;
 			adjust_snap_realm_parent(mdsc, child, realm->ino);
 		}
+	} else {
+		/*
+		 * In the non-split case both 'num_split_inos' and
+		 * 'num_split_realms' should be 0, making this a no-op.
+		 * However the MDS happens to populate 'split_realms' list
+		 * in one of the UPDATE op cases by mistake.
+		 *
+		 * Skip both lists just in case to ensure that 'p' is
+		 * positioned at the start of realm info, as expected by
+		 * ceph_update_snap_trace().
+		 */
+		p += sizeof(u64) * num_split_inos;
+		p += sizeof(u64) * num_split_realms;
 	}
 
 	/*


