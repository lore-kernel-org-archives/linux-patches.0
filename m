Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590826;
	b=xRuelUxdMYbuj82XL7pon871Sb6kubfimAmlwfufC/855nrNry3ZW6xRDwd/LdaH4mVp
	 Cn3cJ40zFmE5ByOxf0tjFrODeiH7F0ItV9k0NUaKEv2sqLXlVqlPfr9Ozmaje/cAvnOWF
	 Uw4vIsaMZc982pwKbK7n2ATb+fvS1QJr8CAF21L1tnGv9s5NRLQ2lpjiGgBWO2wLgJRwJ
	 Nl14/+S0FKd5ffbnGjVG3AX4V2+5vw9h5qFvstSKVQRI+t4Lg/NE+PJGfXfjE2IHjqpwN
	 vMJpVc2r0iCkFXWNV2Dv/10PGAtv+OSfp2P2ZQktlt8Q/LhZVEcNReN/iuJ3iqkGaYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=co5Q5vOaF5rE9c+weAvOqHSJtvnzMjm0bKCuzkNM64A=;
	b=Qc3ImWrZChlZYCLDN5pqZZ5uzYtxls6m1ggVILPcXYJ67llZDElUaypHC4W2nwsIh4Hx
	 rh694fRpwBD1sN19pzQkvboUpE00DP8t2EGsPkr2dGKYfhuZaPAIM886c4S1LJMg9DY8H
	 8+3GMc92h2FMdcJG9GHnVCsv0elCD/1nbDosVc8mfaSf7fYQpoBGSUhb6SPwSnhHD99Dn
	 HpQ9MCXHyacOFWPCm/dCcJTKdCtcxfsup5YSnFWXwqJT9S39lXpa73szexSjy8HsYK9K6
	 M6vuoErA8uMTwXo6YHWfXK9ypqxhJiIEf4pQelM97611aqiXGyUktWpyA9L/j+zscEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4hgZmau;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04310607E066;
	Fri, 13 Nov 2026 17:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4hgZmau
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60131F000C4;
	Fri, 13 Nov 2026 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590825;
	bh=co5Q5vOaF5rE9c+weAvOqHSJtvnzMjm0bKCuzkNM64A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4hgZmauc2QDgDgh6CYamEr9S0kGLjdNILZsnWGj501z0dlOkQ2KxStwuAUysUFmx
	 0oX28acdRKgfLGJk3j7lqCkTbZP6moP69NNpVAiqdAMCynafRAW8vmFC1AGL528WSD
	 wXdNP9Rm4WfiTmFLVbdpcev7Q87g3w2RM06Zyhuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/670] nfsd: defer setting NFSD4_CALLBACK_RUNNING in deleg_reaper
Date: Fri, 13 Nov 2026 10:43:15 -0500
Message-ID: <20261113153812.225852954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 108969960dc54de673869814c5f37c22f6cf404a ]

deleg_reaper() sets NFSD4_CALLBACK_RUNNING before checking the
5-second rate limit and cl_cb_state gates.  When either gate fires
the loop continues without queuing callback work, so the bit's only
clear site in nfsd41_destroy_cb() is never reached and RECALL_ANY
dispatch is permanently disabled for the affected client.

Move the test_and_set_bit() below both non-queueing gates so the
bit is taken only when nfsd4_run_cb() will be called.

Fixes: 424dd3df1f99 ("nfsd: eliminate cl_ra_cblist and NFSD4_CLIENT_CB_RECALL_ANY")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-cb_recall_any_callback_running_stuck-v1-1-310011a028f3@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 9af39c0773ef ("NFSD: Send a meaningful CB_RECALL_ANY keep count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b9d3e134dc1b4..d2878bf1e7181 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7017,12 +7017,12 @@ deleg_reaper(struct nfsd_net *nn)
 			continue;
 		if (atomic_read(&clp->cl_delegs_in_recall))
 			continue;
-		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
-			continue;
 		if (ktime_get_boottime_seconds() - clp->cl_ra_time < 5)
 			continue;
 		if (clp->cl_cb_state != NFSD4_CB_UP)
 			continue;
+		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
+			continue;
 
 		/* release in nfsd4_cb_recall_any_release */
 		kref_get(&clp->cl_nfsdfs.cl_ref);
-- 
2.53.0



