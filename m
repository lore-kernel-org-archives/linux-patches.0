Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590829;
	b=Te3q93C9XHZdII2tdXaarkdKYl7saA6rZZYhq0E6R958mA66CoE4zwjzTrjv2+wSzO4B
	 nITWnJRFi1snIj1DCaaCtA8Io1TyIGOnERhfvLL9XkODRCtzYlGppMcDhGfOpFETy1mBM
	 IQY4DcPVBv1GQMUpkaAIhv5CPtBEfkrWHNm0wJKHP43eyxkw9Cl55GgzCGy06vajG2r4R
	 ooUcN5CLjoCB24xtD0a7uhu3sitKnhlYrq0OUJWngG+tNpFvsUCYlOJ6/AnMNnvaeFiL9
	 NKdpPGE4B1COOijG1WDRGfWUrLuatsmBFQsMNMOoZ4FeP9BeJLt6EoiH/HawHA0G/UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/F++TcTwXSNaVcymEXMiRCKRd8HbtwrHWOLQWDCRJIw=;
	b=SXNegYwN11icZbawNR37zk9VB+sHtnM2w7NNFiavmjTJ6ih7GOHzUYuEG9oxWsKTzq6c
	 8okETAMgHA5y25CK3UD/JatSuQWLMb60K14ZByh4lpyoxkHv4zxf5a402k8tAXARPeJJD
	 8XAEPGKfxEut/LLrYyw9+xpuwqpaOlOeW1+7yh7y35bmj3l6hssQ+0ywMTH7K+UEvEEqu
	 9kXX7MrE+IqKKJ+v1eVWAQrzyg4GOUsWzDKeYH97giIZW+MBGT3RgdV+oocw0nWFoJI09
	 aeBOyw1gLnkqXjclM7nCckDJIG33sdOslgGDTYHuZy42BaEWASACR8PYeDPCi7+rUKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vf0OVV33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4162607E073;
	Fri, 13 Nov 2026 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vf0OVV33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF011F000C5;
	Fri, 13 Nov 2026 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590829;
	bh=/F++TcTwXSNaVcymEXMiRCKRd8HbtwrHWOLQWDCRJIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vf0OVV33LC7st5cCuWF+NFSb1Qo3MUho4XQ13giVt8sORoo7pUnllhHgO60uwdL0C
	 L5wVIn/MAnpfSCyUa/+XrmvLjzsCGoTWz7xjyzGi774L+rI5RtRssCAsdo+90ucM4a
	 fvtiaDqRBr+0TP8Ox0ufdXF9Q60Kn3oV5SKLGqBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/670] nfsd: clear CALLBACK_RUNNING on failed delegation recall queue
Date: Fri, 13 Nov 2026 10:43:18 -0500
Message-ID: <20261113153812.314069231@linuxfoundation.org>
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

[ Upstream commit b036727d334b1b7cd4c1f1fba3b59ba93a6bbe96 ]

nfsd_break_one_deleg() sets NFSD4_CALLBACK_RUNNING via test_and_set_bit
at entry to serialize recall work, then calls nfsd4_run_cb() to queue
the recall.  When the queue attempt fails the refcount bump is undone,
but the RUNNING bit is left set.  The only site that clears the bit is
nfsd41_destroy_cb() (fs/nfsd/nfs4callback.c), which runs from the
workqueue and is therefore unreachable when nothing was queued.

The bit becomes a permanent latch on dp->dl_recall.cb_flags: every
subsequent break_lease() on the same delegation hits the early-return
guard in nfsd_break_one_deleg() and silently skips the recall, so the
delegation is never broken and the conflicting open or lock stalls.

Fix by clearing NFSD4_CALLBACK_RUNNING on the !queued branch alongside
the refcount_dec.

Fixes: 1054e8ffc5c4 ("nfsd: prevent callback tasks running concurrently")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-cb_recall_any_callback_running_stuck-v1-2-310011a028f3@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c79b7ad28f3c4..061ce98eb414f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5494,8 +5494,10 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	refcount_inc(&dp->dl_stid.sc_count);
 	queued = nfsd4_run_cb(&dp->dl_recall);
 	WARN_ON_ONCE(!queued);
-	if (!queued)
+	if (!queued) {
 		refcount_dec(&dp->dl_stid.sc_count);
+		clear_bit(NFSD4_CALLBACK_RUNNING, &dp->dl_recall.cb_flags);
+	}
 }
 
 /* Called from break_lease() with flc_lock held. */
-- 
2.53.0



