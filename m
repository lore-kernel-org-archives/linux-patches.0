Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02711200D4;
	Mon,  4 Mar 2024 21:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589034; cv=none; b=Qh+ML7FoPrI7/af5RnjHHmZSKroTMOg/nTj9o3oj1HFKBPMhOyo9xoI26+5u/f4fMQDs9zKN0vAf8nQG7nXaze1WP3Uso6pWMhG2GVl0Xvni6WF8xDfcgQ6PHDUED0iyaLe1K+vuQTCK+35OR3O1upX5977P5eWSMPb8pup44u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589034; c=relaxed/simple;
	bh=xLV5G/oaIo3T26XcxqeRAovSzU52MBrchdQqK1c8KQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4HO4mRHqXO7nbah44wi3zli8eJm69M2AL+0VBiyUlsmTtO5ahT8nQ9ZPz4+CaD5UMH8u5fVabZGqA5bNdkceppZUt0s+KP82cJ1FL09AXwZCwdEdKaMJN+jJk1EkPWki7/NLvgPDRb3GJHe6XKTV6I9PBgQgkSX/PZrEmBGEM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhpEjCcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhpEjCcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8833CC433F1;
	Mon,  4 Mar 2024 21:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589033;
	bh=xLV5G/oaIo3T26XcxqeRAovSzU52MBrchdQqK1c8KQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhpEjCcuHA72H1xguK9Ukrn7LtHHOIf5knXKS43n7yTevRAdfeC4zfi4QZX6z9kR3
	 EmgY4wjUWDZlFNx8GcQTYCxUDXJkP6w8SEcgIC9po/DhHA0c4L/7zUFQCE+62K/jI/
	 R9KuGhGo9A0DV8VRVAWjyKWEUKmmN7u+LOIfBgPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 151/215] NFSD: Trace stateids returned via DELEGRETURN
Date: Mon,  4 Mar 2024 21:23:34 +0000
Message-ID: <20240304211601.809671990@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 20eee313ff4b8a7e71ae9560f5c4ba27cd763005 ]

Handing out a delegation stateid is recorded with the
nfsd_deleg_read tracepoint, but there isn't a matching tracepoint
for recording when the stateid is returned.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    1 +
 fs/nfsd/trace.h     |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6935,6 +6935,7 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);
 put_stateid:
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -604,6 +604,7 @@ DEFINE_STATEID_EVENT(layout_recall_relea
 
 DEFINE_STATEID_EVENT(open);
 DEFINE_STATEID_EVENT(deleg_read);
+DEFINE_STATEID_EVENT(deleg_return);
 DEFINE_STATEID_EVENT(deleg_recall);
 
 DECLARE_EVENT_CLASS(nfsd_stateseqid_class,


