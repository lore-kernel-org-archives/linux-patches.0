Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6212843B6E0;
	Tue, 21 Jul 2026 21:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667603; cv=none; b=lFIx6iPHce2DcfnLj/IziQq3CyxXqzgJtskyrqcA+nwN98wZDHKY5inSixsYGQLIaGUG9Fo0JEMr0berktSxiLh3p3yGS3NU+mLSKB2MTwWdODW5fG4O/CNaoHdzKCWzTCrzxw0ME/IW/VjjYeWmiweN2CyP4D9EG03jUNRCMas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667603; c=relaxed/simple;
	bh=JzFXrKDAFWJhUFzA0we24qNh/gqUSFtmIsTyEb4XS1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOAm+7tiInWIcJ7IoU/l9Z0PBeE6zy3W14Il6JJo+9RL+/2X5k+p1V68IGB+jOfl4n0K3uc0w/u2a/BjDdkNjPpaEk4WvDmeHkv0PgiunOX2diVQ7Kb6hcYekOqU7Fdnod+4PWYcdJgYKT7HY7REHA92Joc2zR+nquIAyjfMXJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9XIQAFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9XIQAFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC161F000E9;
	Tue, 21 Jul 2026 21:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667601;
	bh=gp2+ledm9D1q34JNkJuyMGP9p9dK7e7IFMRudMCqTlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9XIQAFSDu/0ZS4w+InUPF85Y72XNjwgN4g1VgGGk8prMw96sFMkTR18BpX+f68Pl
	 btQiLZGhg4VrKlvLdCfLabkCqVDen+wwwPkRnJ27rWP623oRORx0xPwo7Dku7UMc7y
	 ZGon59+1/8qzGFCvzeyfQaMonLOPW+v7AeRu23nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Crystal Wood <crwood@redhat.com>
Subject: [PATCH 6.6 1123/1266] tracing/osnoise: Call synchronize_rcu() when unregistering
Date: Tue, 21 Jul 2026 17:26:00 +0200
Message-ID: <20260721152506.928177439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Crystal Wood <crwood@redhat.com>

commit fe58f457ad8d0a2bef4e053cfecca4b5cd266b1a upstream.

This ensures that any RCU readers traversing the instance list
have finished, before releasing the reference on the tracer that
the instance points to.

Cc: stable@vger.kernel.org
Fixes: a6ed2aee54644 ("tracing: Switch to kvfree_rcu() API")
Link: https://patch.msgid.link/20260609045430.1589786-1-crwood@redhat.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Crystal Wood <crwood@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -159,7 +159,9 @@ static void osnoise_unregister_instance(
 	if (!found)
 		return;
 
-	kvfree_rcu_mightsleep(inst);
+	/* Do a full sync to ensure that tr remains valid, not just inst */
+	synchronize_rcu();
+	kvfree(inst);
 }
 
 /*


