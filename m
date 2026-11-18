Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034551;
	b=xJS4H2rHD79ANihW5d9JOlqL51+zOyecPeUQX3oYIYqWnaoBVp88dJwekyv/WqBnE8eM
	 jIBqgBrLzTu4rOSrrNjHerownPUfR5VCkzkbdBonMzUvKseRTk50yWKOItIwLKGId5SKD
	 Tny/ZMUG/uqrqYeI4HZ2Q31Q9SkQVDGAMQRGRzZrSHZy3QB2cQ4kNtR6MybIlw5jXXe2u
	 zJIqCmwK0VIiLms2XE7hKFarXnL1bDPq40bCXyoSis2D+iw+M311qdQX1oJCntf0UqgmD
	 yyig/Pn1T/3KBzpkNJTJ9xOTxMxopCR5O4QuWTLDGsqFWCsXyRLw+xnOCikHGyBKh3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0XNg0xVXav4oc93zCZzN7Cbj5JPCe8337mZ4l6/EMmU=;
	b=1JdmJ77jMiLIVWq/amPUTtXF1oAXGSf0i2XhFvnVoBgunZmWHrV8UCn3lvwMookz0w0f
	 25JB/PshX+0zTlz7ihua38m5JVRNqnfQzRfDjCXjpz8InWD7DJ6Eg/nRQPJ353D9D78hw
	 eLHg+oBobE9JeMOm+LvnDC1/rnMN79unbSLYrhNE4pvReJIKjH2DwX5eJZdytCP9ITf+/
	 Wfg1hhLxS6oLEQMN1dO0qPA2eGh88OJ7Fy8Z33JjMDrgTsQZQW7SQ6zi5wjvyOq2pLFdi
	 /XrEtIxcWzdpjIfTp2GIX3GHMbvz2IErrz8BFMx5THWHvISxdsw/z90z/iFtrmOMdlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wq9i8SzK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C58606A31C;
	Wed, 18 Nov 2026 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wq9i8SzK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1461F000C4;
	Wed, 18 Nov 2026 20:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034551;
	bh=0XNg0xVXav4oc93zCZzN7Cbj5JPCe8337mZ4l6/EMmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wq9i8SzKT4qsyvxRzF0j2TRw3jVr7THzyuocKEdCHm4b1w5kVjU/U9AbqOeRQOsGU
	 cdZHrTUn21CoAxYbxm4IisijlIzhyNj2vP+V14tpe7W1+sTw679ZUO9SyKcRf6vC45
	 X4pHorbwWh5bFxWgxVudQcqLWT7QbkdmY+KvoSaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0409/3318] nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update
Date: Wed, 18 Nov 2026 15:17:11 +0100
Message-ID: <20261118150328.746974280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 0a5a548861ab09e79a6b3062ac17e410323af3cd ]

clients_still_reclaiming() uses separate test_bit() and clear_bit()
calls on NFSD_NET_SOMEBODY_RECLAIMED. A concurrent set_bit() from
the OPEN or LOCK reclaim path arriving between the test and clear
is silently lost, causing the next laundromat tick to end grace
prematurely.

Replace with test_and_clear_bit() to make the read-and-clear atomic.

Fixes: 8c67a210c90c ("nfsd: convert nfsd_net boolean flags to unsigned long flags word")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-13-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b9e51526c895a..e2e622b74532f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6103,9 +6103,8 @@ static bool clients_still_reclaiming(struct nfsd_net *nn)
 		if (atomic_read(&nn->nr_reclaim_complete) == size)
 			return false;
 	}
-	if (!test_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
+	if (!test_and_clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
 		return false;
-	clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags);
 	/*
 	 * If we've given them *two* lease times to reclaim, and they're
 	 * still not done, give up:
-- 
2.53.0



