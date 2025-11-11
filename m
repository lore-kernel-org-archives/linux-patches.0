Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D3214210;
	Tue, 11 Nov 2025 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824650; cv=none; b=tA4zZP37+ZKm98fOCErxsqtGyuvP+Ov+tMPoPAcq4+uN8XBbXHPA5gKU1CTQFn3m1APbiwug8gwN/4yWsw37vDaI6RUTMNUr6cl+s+fLw35tPX+lNl+sw3gI/wUWFByTBFZG+u3dAVOiF9QmltS3z1hPDN/HQ+PzFn9yHH+VSXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824650; c=relaxed/simple;
	bh=1oEudp+LF4LFQhdNR4QKGXHcgipflWPlok5ytgza38U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2YWRMQTjitYKh/OTbAkNOE2Wr6B6B1IiWqKSesLftUI6aMSW07L7txpSznWfVobcdFowTaiO+Z27+gTz6LX8+WgWKL5cGjSEO6viha4lLkQFcRzb5M26tEpcoA+pGkfNUixXBclKMlsMlEBXGivQldozOPviVy05WYIsqGTTis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR3hxTkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR3hxTkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B3CC116D0;
	Tue, 11 Nov 2025 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824650;
	bh=1oEudp+LF4LFQhdNR4QKGXHcgipflWPlok5ytgza38U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR3hxTkPOFzUbNYBPdpuEjU8ILOUq79Yp1odAqJUaXO3UF/2RfbZOEa86sqvgwYO+
	 hOzt2ni/zYs3zWadO+JkEtWT2XejGCEfmtnO0meaDVzCM7k+hUY4JSnqp4mq2GPIib
	 0vPbJrvbMSqewAO/XO+47bDm5h/1C9rycsvSbDMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 492/565] ceph: add checking of wait_for_completion_killable() return value
Date: Tue, 11 Nov 2025 09:45:48 +0900
Message-ID: <20251111004538.001948937@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



