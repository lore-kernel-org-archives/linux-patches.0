Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5196303C91;
	Wed,  3 Dec 2025 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776350; cv=none; b=LKc0zsJkLS7EG5ZqL+M+7UgKMuBbq4ANEyLwps2Dfukhqf08nS26L64Be1Dhq8ICfJTZPoE6MYxLqq7AgW8VDMqn5RbwHDDK3putqgMKbl8NPW7am8HEVzB/fK9FxT4rODKNtysbJQ93YQftghLlV7M4mUq2zj9iGgoDzE1EJQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776350; c=relaxed/simple;
	bh=VeYYyj6gRHBy9urlgqmLi8spTG2hRmC87yDKDgjULBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRY74Pai3ocPvAdLQ11SNxwWJ2/qywswtH5AN5crQ5G/S6KWXL7RMAOKBH+VzZmMRFMQw0Arq1mUJ4CvTUgD/b3YSATHDxmPQTTSmlHIBg89j4g6HqmtuZZDQnwGwcnK+GZOLmH+mTPpmgUVooNOG/y4aqHB9rB93KU9P3FuOTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIhikIVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIhikIVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FC2C4CEF5;
	Wed,  3 Dec 2025 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776349;
	bh=VeYYyj6gRHBy9urlgqmLi8spTG2hRmC87yDKDgjULBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIhikIVd9i8VLBEbTgHwHzUnxQZxJ3Ank4bJZzugfqZ/pMF60waNpMWLePEl872aN
	 sdzDcTVm0o5NHgSCe05/Ln914sm4Zew8gmK5+Nmp2G2KzOClzG/rS52wAcetb9ADYz
	 tAjFHN5y4V12ONMOUr+Ep/2OIIuZBh9z77BMLYXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/300] ceph: add checking of wait_for_completion_killable() return value
Date: Wed,  3 Dec 2025 16:26:00 +0100
Message-ID: <20251203152406.397438748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 674d6ea89f717..642582a642a3a 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -202,7 +202,10 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
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



