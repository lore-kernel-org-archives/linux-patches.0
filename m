Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C65A10A1C;
	Sat,  3 Feb 2024 04:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933456; cv=none; b=G0W36dFTg+FxGU4dfdVDxbg7sKPVggYW6wv7L+GYij+JAhGlcxbzN2Ths6sXigEHffvHm6yus/FeU2f9V9/2TVZFguXZa+4NBN9omsd6KzELxGPa9pIk8AB0F/GLwC5wBQ6Nc4hM4TQCoEmqJWZW3HLNukQZXE2yBDgOTBtPgEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933456; c=relaxed/simple;
	bh=KcYpidkrKnEKDsS7BKC3GXmuXlOiC8Huil0J8B000tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdYq069OmJHFzAeWkWyjEfg0xoeTniurwuC0OuFWQbS/7UQaME+dCDFkZxx3NnapWidwB2LMAOheIug3yBUTuiwk7JI3vSt5KBocAWH9JsWPsNauM1c2o/trsg1Xi4Bf/LhV7J/fSExBphFIdZQL+EkaT34QcJyM7WdTgpqn3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+ykXAVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+ykXAVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342BBC433C7;
	Sat,  3 Feb 2024 04:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933456;
	bh=KcYpidkrKnEKDsS7BKC3GXmuXlOiC8Huil0J8B000tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+ykXAVt4nLYcZ2XGCmuyJlSDaFGgs3EQLTx/TEQWT7vMBy4Splmh6tuQQje7UARt
	 Zt6b/DMF5DnNLvZ2Jm4ztmg26h7ScU/xOu7cLx9oc0R/ylDRW6cUNY0s3BNcH74/+V
	 hBaDt3mYZhrPyt26bqsLCloQGCl8dF+VxOgp7Pwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/219] ceph: reinitialize mds feature bit even when session in open
Date: Fri,  2 Feb 2024 20:05:48 -0800
Message-ID: <20240203035341.296723321@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venky Shankar <vshankar@redhat.com>

[ Upstream commit f48e0342a74d7770cdf1d11894bdc3b6d989b29e ]

Following along the same lines as per the user-space fix. Right
now this isn't really an issue with the ceph kernel driver because
of the feature bit laginess, however, that can change over time
(when the new snaprealm info type is ported to the kernel driver)
and depending on the MDS version that's being upgraded can cause
message decoding issues - so, fix that early on.

Link: http://tracker.ceph.com/issues/63188
Signed-off-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 82874be94524..da9fcf48ab6c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3650,11 +3650,11 @@ static void handle_session(struct ceph_mds_session *session,
 		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
 			pr_info("mds%d reconnect success\n", session->s_mds);
 
+		session->s_features = features;
 		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
 			pr_notice("mds%d is already opened\n", session->s_mds);
 		} else {
 			session->s_state = CEPH_MDS_SESSION_OPEN;
-			session->s_features = features;
 			renewed_caps(mdsc, session, 0);
 			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
 				     &session->s_features))
-- 
2.43.0



