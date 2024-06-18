Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747041552E4;
	Tue, 18 Jun 2024 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715372; cv=none; b=jSXpmQmwKK3ulvVoKmGiuzqkcmHXBITfCaVunn2EBj80mHTVFP5aVeUTswfmk/QtvYT48klW48VfihcIypi06gNXUCv7jcDezHyun4T0TX7ci7w+S3pILm7XxjaVSHGCTeZnWqHXEJd2GwtKK7IpaeFZWMiStXIu9c4ZOaR1L9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715372; c=relaxed/simple;
	bh=8Hnr39c6T7Yn46Ol1o11sf9SjBA2bNDDZLfD4NXX7gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajDHs0ApJC6LUX9ZZsJswr50AUgDFevGvVRyKIMS/2rlZxFCK2XWMBIlAVlmYpVUW0VosHaPOCvauxOXGN9iTFlq11S+/zReBD+R1tgV6zG8HHn0Xcsqr3dUBapG3zIl+tzVJSNSdm5fyMaDsjklJJttHM+de4okTfyZIjoLCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwmjAyce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwmjAyce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D52C3277B;
	Tue, 18 Jun 2024 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715372;
	bh=8Hnr39c6T7Yn46Ol1o11sf9SjBA2bNDDZLfD4NXX7gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwmjAyceIhcXd/kS5kN6b7dPmNQ1ZqCZIKMYRgiug8GHqxHxOgJQmIqsNkAC6VeaQ
	 IFsXluHkz0bxywXbT1cx/PtJhwKsJnIYT7Yhr9jS6/M34dfHQqJBi44lW93NuKSw5V
	 mBrjjdrqIk5//rkcyF5UOwJ7QUFuQ0rC/xJarzog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/770] NFSD: Add an nfsd_cb_probe tracepoint
Date: Tue, 18 Jun 2024 14:32:20 +0200
Message-ID: <20240618123418.342135170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4ade892ae1c35527584decb7fa026553d53cd03f ]

Record a tracepoint event when the server performs a callback
probe. This event can be enabled as a group with other nfsd_cb
tracepoints.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 1 +
 fs/nfsd/trace.h        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index fe1f36b70fa03..453f60b127ebb 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1000,6 +1000,7 @@ static const struct rpc_call_ops nfsd4_cb_probe_ops = {
  */
 void nfsd4_probe_callback(struct nfs4_client *clp)
 {
+	trace_nfsd_cb_probe(clp);
 	nfsd4_mark_cb_state(clp, NFSD4_CB_UNKNOWN);
 	set_bit(NFSD4_CLIENT_CB_UPDATE, &clp->cl_flags);
 	nfsd4_run_cb(&clp->cl_cb_null);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 9061fd28c996d..4361a0807f070 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -910,6 +910,7 @@ DEFINE_EVENT(nfsd_cb_class, nfsd_cb_##name,		\
 	TP_ARGS(clp))
 
 DEFINE_NFSD_CB_EVENT(state);
+DEFINE_NFSD_CB_EVENT(probe);
 DEFINE_NFSD_CB_EVENT(lost);
 DEFINE_NFSD_CB_EVENT(shutdown);
 
-- 
2.43.0



