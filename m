Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9ED74BE1;
	Tue,  3 Dec 2024 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242127; cv=none; b=T2/nc1wVKTURNJCVoYeWbqcYid+2etoyUx++K9ZYpAq6CSkVVU1O4t79B9b1vxS/pIo6fj8/dSms6qFpS5i5Oczh3IH3WecBdaYjA9J6sjv7u59yBf9BpxYCMagN628/y84AnjcjsRM/YITHPncLKya9JTDY6Sx7bU34L5ySkYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242127; c=relaxed/simple;
	bh=B+EPGesaW7Ysa4RAkwOa0ePrFs0wWNyRasCT+b2jCiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzVlABaSRgRjj9sHRONY/M4rxEVlSOaa6mZwJ7BMLeQ8iBCKePDHdbeke5MNtu2FoMIZDyj2AKpv7QL8bIPnyw2SjJfV1Addpm5E346RKIgqy16GMNM7eZcL5kx2c05S5BiCBh5c7rk2qspJCPvE/RpsMrr2aPwoAP8B4sw85OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F065wzl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F065wzl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53361C4CECF;
	Tue,  3 Dec 2024 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242127;
	bh=B+EPGesaW7Ysa4RAkwOa0ePrFs0wWNyRasCT+b2jCiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F065wzl1Wf8DfQjtp3K8obChAHdN08ZDfouV1dMGATQK+yGqetG8yuKz+ih67hpwI
	 ZNnBjm6IzsnFAefE3oRtVUWn3Un12gOkmkqHKMWXJhrWTEs1W6g7ZQx3Rz4W0ykQgF
	 KN2jPr331OWfZPVZoo6JnZk9/kk6QkjNU6Thq9Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 585/826] llc: Improve setsockopt() handling of malformed user input
Date: Tue,  3 Dec 2024 15:45:12 +0100
Message-ID: <20241203144806.569877571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 1465036b10be4b8b00eb31c879e86de633ad74c1 ]

copy_from_sockptr() is used incorrectly: return value is the number of
bytes that could not be copied. Since it's deprecated, switch to
copy_safe_from_sockptr().

Note: Keeping the `optlen != sizeof(int)` check as copy_safe_from_sockptr()
by itself would also accept optlen > sizeof(int). Which would allow a more
lenient handling of inputs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: David Wei <dw@davidwei.uk>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/af_llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 4eb52add7103b..0259cde394ba0 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1098,7 +1098,7 @@ static int llc_ui_setsockopt(struct socket *sock, int level, int optname,
 	lock_sock(sk);
 	if (unlikely(level != SOL_LLC || optlen != sizeof(int)))
 		goto out;
-	rc = copy_from_sockptr(&opt, optval, sizeof(opt));
+	rc = copy_safe_from_sockptr(&opt, sizeof(opt), optval, optlen);
 	if (rc)
 		goto out;
 	rc = -EINVAL;
-- 
2.43.0



