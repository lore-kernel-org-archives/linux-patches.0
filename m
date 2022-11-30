Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5176FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38FFC433C1;
	Wed, 30 Nov 2022 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832796;
	bh=ex35Ym+SjGq5A08TtxO4bLLtXTo7vLymLfxusPR0OHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIMxKTNT3JRxOwCi3SOEPX7f6f+Uo6K8bxKu+JOQRemu4ZDg4Q90Bxi7Vjp15zYuz
	 fd/rumNDbsFNW/Z2UZS/FhUze5Mgsk8Vc5GxstpzIauVwwkbgfNts82hQVuUSUewZV
	 3jD6SQSprr0tI8+EVOE3COyIYWzPHuuxtYnyyy0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/162] ceph: avoid putting the realm twice when decoding snaps fails
Date: Wed, 30 Nov 2022 19:21:35 +0100
Message-Id: <20221130180528.881085274@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index e779f0e2bdb8..734873be56a7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -697,7 +697,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_mds_snap_realm *ri;    /* encoded */
 	__le64 *snaps;                     /* encoded */
 	__le64 *prior_parent_snaps;        /* encoded */
-	struct ceph_snap_realm *realm = NULL;
+	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
 	int rebuild_snapcs;
@@ -708,6 +708,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	realm = NULL;
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
-- 
2.35.1



