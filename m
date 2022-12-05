Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD0615C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA44C433C1;
	Mon,  5 Dec 2022 19:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269313;
	bh=hMnFi563Q7zI1SLcghywFimFNZIsurw6QH/j1hM878c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzL/VzBmkVcTxFpHebj0fTk8pCl+VWzl4Enyy7YuiRH8h4CQa26A40n+36BBaLlpz
	 D7f965kU+BGXFYxGuOzEFN6roT2c6bDRt+NaQU6tfT8FuHp9bEQJz51oukudRbdqkL
	 12XDoV3bAi2tQ5tgv0GaVSAz92Ms5TLQbaBxG190=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/153] ceph: avoid putting the realm twice when decoding snaps fails
Date: Mon,  5 Dec 2022 20:09:38 +0100
Message-Id: <20221205190810.270202990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

[ Upstream commit 51884d153f7ec85e18d607b2467820a90e0f4359 ]

When decoding the snaps fails it maybe leaving the 'first_realm'
and 'realm' pointing to the same snaprealm memory. And then it'll
put it twice and could cause random use-after-free, BUG_ON, etc
issues.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/snap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index f2731f9efc31..97ce1bd13bad 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -694,7 +694,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -705,6 +705,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
-- 
2.35.1



