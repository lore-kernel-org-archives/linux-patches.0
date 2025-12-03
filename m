Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6743AA1A2;
	Wed,  3 Dec 2025 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779585; cv=none; b=ehwYpVUjLuFB2mvIAfqczNOn1Lu1jFhGWWG1fCz2Tn/Q7IwsNl30WRCHYxsWsH+6x9WdIPvXlT+bxWd1I+//NsglldIjTPYKvNJYblFGShk0JSqYd1Wub0w09ejSde+6xpi8hBiVLoyeRgQSjT0QUBv+B1HMiG7iYNzN4iIObh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779585; c=relaxed/simple;
	bh=ZWvZqTeuyHqyedB//DcMDFVtOTMmCY5573u8MZjq2sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGcIeSFO9hJ21e3DVMa6bzEB1AzBVP3dtWE9D8tnRVySe43elYWupgwxeDNt5zyojJUC2nldUKnjKmAxs0n0A28sQiFiZNEHRPRbkUqN8i5+KvOnUpv8FiX4R+yN9v8aygDuA8pWfMzd9ikcuS3re1xcEC8/G/FP7qYiVqb4AFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUos6Hs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUos6Hs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D686C4CEF5;
	Wed,  3 Dec 2025 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779585;
	bh=ZWvZqTeuyHqyedB//DcMDFVtOTMmCY5573u8MZjq2sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUos6Hs5IBb3PwiZiupW7eE//4Lq35qh8eT8eRcgt8A4T8mlHu+s15+hMYe6aZJW+
	 JiobAKyVvfqgHP7i5hc5bSgQDTKU5083tggLbd+/fwySMWdEjKMQ42pVBJmOuzXMB4
	 G5hprPBNHFrUMd3C5rA4qQSCWnnn4ATmJt3t5D8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 301/568] ceph: add checking of wait_for_completion_killable() return value
Date: Wed,  3 Dec 2025 16:25:03 +0100
Message-ID: <20251203152451.730991674@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b191426bf880c..3da9e53f80918 100644
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



