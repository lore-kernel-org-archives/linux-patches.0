Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93D36D4F0;
	Fri, 21 Nov 2025 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733030; cv=none; b=bA9SEyCHUaW/m6MbQjdweG2gCdAVKXg/1yigpJmlba6EHdJKesLkp0ZWoaYSQ/7L02zc1vhKSAQWSn7fp9hfAnhsiXfqnNKOICteMs/3d7I3Q2PvIYu9NM2BRdtyjDeEteleaVQ/XjQ0mBGmFmBcFNaMGTx2WN4o5zLRaWxUeMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733030; c=relaxed/simple;
	bh=geyb733oI7ZFL4JXYDK8ueS4VqLp4LuHE1s+g41CXxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4Fgj9uy2ITSLGwJB26vz3med5IMQKY7NiylOKQLZemd/LhqfQdNk4fnutcViVwBJGW7JkCaFtWgx7DEzQPK21VblyDSez+cY+uG8Dq3iTMeltf6xxuKJkbf3WvXtChcUnh+YMV7BmC2LBjmS9vCt7OwB4nuwA3E4aMgcsiHHfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEJeHLuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEJeHLuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA09CC4CEF1;
	Fri, 21 Nov 2025 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733030;
	bh=geyb733oI7ZFL4JXYDK8ueS4VqLp4LuHE1s+g41CXxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEJeHLuGxwmbiHwTp/lS79NQO3i7loNZPU9BeSSZoQ+5VWA74vb5Vlgs5h3/9AkA1
	 efLIzCmwetABrGMm06CB0tieNB7UNMi0MyMZtWgtcJA0l7Fcxb3FQvxyuidAQKsID7
	 2O+/g7Kf04PKkzDHAMZnADPBAVpb96VshIq4p6Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/529] ceph: add checking of wait_for_completion_killable() return value
Date: Fri, 21 Nov 2025 14:10:26 +0100
Message-ID: <20251121130242.663386470@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

[ Upstream commit b7ed1e29cfe773d648ca09895b92856bd3a2092d ]

The Coverity Scan service has detected the calling of
wait_for_completion_killable() without checking the return
value in ceph_lock_wait_for_completion() [1]. The CID 1636232
defect contains explanation: "If the function returns an error
value, the error value may be mistaken for a normal value.
In ceph_lock_wait_for_completion(): Value returned from
a function is not checked for errors before being used. (CWE-252)".

The patch adds the checking of wait_for_completion_killable()
return value and return the error code from
ceph_lock_wait_for_completion().

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1636232

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/locks.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index cb51c7e9c8e22..02f5fbe83aa46 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -219,7 +219,10 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
 	if (err && err != -ERESTARTSYS)
 		return err;
 
-	wait_for_completion_killable(&req->r_safe_completion);
+	err = wait_for_completion_killable(&req->r_safe_completion);
+	if (err)
+		return err;
+
 	return 0;
 }
 
-- 
2.51.0



