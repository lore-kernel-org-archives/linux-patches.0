Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F281420F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780DDC433C9;
	Fri, 21 Jul 2023 19:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967446;
	bh=1i2FOhYFo2yxVMwN7eIXPosGo0H08fgwxF877f2JEfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhPez6dOqWbe3GyKVnbH0HNt4hL2192fZQBXl/WRTnGCya2kB+8V8QNJhMnWakDhp
	 IuT7cOJN3Xm9pI4fNrbIobeaAjSFNeQ4O+N5EPi4TmHtUpw02sWvY5pYUpTF875vsv
	 GTcePCXHxO/p3ebu7rG6yUq+xyPFiUR6zrZmRDXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 165/223] ceph: dont let check_caps skip sending responses for revoke msgs
Date: Fri, 21 Jul 2023 18:06:58 +0200
Message-ID: <20230721160527.912109359@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit 257e6172ab36ebbe295a6c9ee9a9dd0fe54c1dc2 upstream.

If a client sends out a cap update dropping caps with the prior 'seq'
just before an incoming cap revoke request, then the client may drop
the revoke because it believes it's already released the requested
capabilities.

This causes the MDS to wait indefinitely for the client to respond
to the revoke. It's therefore always a good idea to ack the cap
revoke request with the bumped up 'seq'.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61782
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3561,6 +3561,15 @@ static void handle_cap_grant(struct inod
 	}
 	BUG_ON(cap->issued & ~cap->implemented);
 
+	/* don't let check_caps skip sending a response to MDS for revoke msgs */
+	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
+		cap->mds_wanted = 0;
+		if (cap == ci->i_auth_cap)
+			check_caps = 1; /* check auth cap only */
+		else
+			check_caps = 2; /* check all caps */
+	}
+
 	if (extra_info->inline_version > 0 &&
 	    extra_info->inline_version >= ci->i_inline_version) {
 		ci->i_inline_version = extra_info->inline_version;


