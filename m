Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67BA2D9497;
	Tue, 11 Nov 2025 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825271; cv=none; b=j1l4NxYud6MYqhldGeeq5xBZOrM210YsAYkFQaQ9H1vCjUa857+nSHDwHNwtTvhdOFq2+voSBQwt3XXbaWtUYPgSdjEdXAmjnV2fm/LxFqpN7PW2+tUDNHrJLxBfJRQxYQgMg1R8Onimn4nqTAGH7PicbSN1p9ZgZ6BQ0FpYmdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825271; c=relaxed/simple;
	bh=hB581TaBkdp8UFx1DHM+UnZuGs0D+oDosQgjNBeES/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnkNnlopMZPAFeY5P5e8YH55+9CUcUsSAyRaR9uJlnL3HzfsQEztoRq3JGAA7cPRX55d7S29OV6myl/GGQoIBekjRD1AKLkRZKmhvRC0t79Vr08aix0MngQpKd94eze9MkAeqHlqFk5tGFbyznHLAGSfdUjVH2kYd95DrKhPyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huEz1V4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huEz1V4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F910C4CEF5;
	Tue, 11 Nov 2025 01:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825271;
	bh=hB581TaBkdp8UFx1DHM+UnZuGs0D+oDosQgjNBeES/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huEz1V4Tps0jswbc4KGqVXel2oa8T7RodMeN6CfROF3WJ9sLX7p1JpCJbtpEAejSt
	 SOjPyBxzvXoH73pAW4mMXDV7EWozAowY+sGRGyPSZ3jp4d3gf6+eZMP8vTKAkSXRdr
	 Dx3ZUXwucB8vh9kkLIOsszHJw5fAqvbXuhMtt3jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 733/849] ceph: add checking of wait_for_completion_killable() return value
Date: Tue, 11 Nov 2025 09:45:03 +0900
Message-ID: <20251111004554.158094581@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ebf4ac0055ddc..dd764f9c64b9f 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -221,7 +221,10 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
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



