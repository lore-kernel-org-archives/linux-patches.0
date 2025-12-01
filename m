Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78382550DD;
	Mon,  1 Dec 2025 11:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588627; cv=none; b=gTMd2xajxkpV1+CPfS5boOKAmjp0kcoLs3Gv0b5Ym5E81vdkoEuvvDx/8yNtukVUliOKUiM0M/moukBsawGDIbh1hriykxdXzm42zi22ogPJYW3hJY0KkeQC9MAFiqaSIdT9KoPqbwyP7RES6QnBQ3yYWHSY6bTLOgCGSaQzduE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588627; c=relaxed/simple;
	bh=8opLn6BQRTW/r9SpOzRLXS/reisZh/Tqy23rf2ipH/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Luae86zM8hIyYCifZSSenQbVXNMmk8u4LCJ91LcICEU0pWJp3uitr1uyOatU6ej4/2U0kx12wWyqIcrcQ+N26iTZNZCcuiAnH5ScBGV2CsmD15g2KhyCHuTLcOZORf6M5Up8wdh0wDKp6z5Xb2WPwlkgQCT41GhOWYVfpbmJ65o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OB1ZHPiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OB1ZHPiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E34C4CEF1;
	Mon,  1 Dec 2025 11:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588627;
	bh=8opLn6BQRTW/r9SpOzRLXS/reisZh/Tqy23rf2ipH/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OB1ZHPiLqPVf9awv8ICOID/dObrnH7lkp4lQYEOMnpRILYA/FTCzVQ86sODzgzvp0
	 O7cB3odpND48ZWy6s4pjSIeGveOnxtSMk1PKyl6+CSKzSI+sm2CrqerkG03tCY6tx7
	 b7pwZgnmnB6qwQ/rLrUMIyrea82m9YnhRX8Euxdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/187] ceph: add checking of wait_for_completion_killable() return value
Date: Mon,  1 Dec 2025 12:23:41 +0100
Message-ID: <20251201112245.314357664@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 544e9e85b1202..d93515c2fa56f 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -206,7 +206,10 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
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



