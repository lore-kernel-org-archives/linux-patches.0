Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0796FC11;
	Sat,  3 Feb 2024 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933923; cv=none; b=mXA9uEErO2AJWHX07G3U/Zxo1g+7GTDryur8kz2oOr5subFsQiY9QoKOTQPHDzSVqhuTCAFlmd2bMSgqBYbhrohkOcpbPkvoxlQbbfOsXqrtEGaNuztyCBXb7DLsibZrm6BNDjXefbHPqmG/BcQwB+eJpPdwDW5D8JsI1g9C48M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933923; c=relaxed/simple;
	bh=FQ205kXC8XoN99GsUTK1A+Ig/U56vbsv3a6mGK8qVFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T86qNB5kDbI3ihvKY3hXN9Y1afs6eluLzZZYIJo0+cFjCiHyy0kdzZBrNIlaTcIHOcNErS6uUaJ7sOJDvKB3qe2NkcZsmTRzig07LJPrry4GYy11Xuc+nCK/uIr1w18NT1DBX9Ved6PaYieFxlo2mSAiyHvXDX4kZXIMdpcZ6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nX8xrEqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nX8xrEqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A420CC433F1;
	Sat,  3 Feb 2024 04:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933922;
	bh=FQ205kXC8XoN99GsUTK1A+Ig/U56vbsv3a6mGK8qVFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX8xrEqgg0BEpLbV+7SGMpDx9FfGZmIiaxnq+mm/09C9x24cwH9K340kjysl7jkSQ
	 DexodHPZYxyjzVv1B91PlcpupQdowuGlp+X7mRcb4sj10BSeKDBeQfG3Uj8vFZE500
	 b5KuFAukUQ8lokocz2JAwSeEOvbxj+OlMzXYxwTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venky Shankar <vshankar@redhat.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 278/353] ceph: reinitialize mds feature bit even when session in open
Date: Fri,  2 Feb 2024 20:06:36 -0800
Message-ID: <20240203035412.569571206@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index d95eb525519a..558c3af44449 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4128,12 +4128,12 @@ static void handle_session(struct ceph_mds_session *session,
 			pr_info_client(cl, "mds%d reconnect success\n",
 				       session->s_mds);
 
+		session->s_features = features;
 		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
 			pr_notice_client(cl, "mds%d is already opened\n",
 					 session->s_mds);
 		} else {
 			session->s_state = CEPH_MDS_SESSION_OPEN;
-			session->s_features = features;
 			renewed_caps(mdsc, session, 0);
 			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
 				     &session->s_features))
-- 
2.43.0



