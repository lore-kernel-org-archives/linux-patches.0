Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0DC7BB13;
	Mon,  8 Apr 2024 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584588; cv=none; b=UV4XS4uQQLslnBUsMGMnNHlJKZOxP/qJx3jlEwSoP75hMMlPFufbAo7XjjQ4R2cKlM+RV5lvtt+sAxC2WNZB372L8YsCFrEU8TtdXaRQuddK7UdgtyMIug+TGOIR9A/XYPguxVapqlJzF0tAvCP48D/nvKJEJA9Gvne68mgk12I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584588; c=relaxed/simple;
	bh=E8MXDFPVdk3S7W2l4cLL+0/QcwmZtl3qHXshvWvpDcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOfSkjvU8PXHa/O1BxgkPbfnqOLOnJ4SoLfKTMQaYKLA+MpqqZ+tm2DAoOxD9GCFTRr85UeP0DGyG50EXsrkJDcctb4MJG/c3bIb/Pj+HEnfK5DObkd1Wm2txJhr2sMLY3I4Tf8nVb/fzIBZnExmntu2ptBcYdyCLXZAgZpU5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTyDEit1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTyDEit1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6CBC43394;
	Mon,  8 Apr 2024 13:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584588;
	bh=E8MXDFPVdk3S7W2l4cLL+0/QcwmZtl3qHXshvWvpDcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTyDEit1zbtjLzcb1JSHrSbRYE9sZDzFR31D7NaE/xAJ73pwh0LB5CcOnpnoB5APG
	 6RulO0UpB1w5G9OJ04oPD0pwAy50W6GffQbls6ypgzR59v2s2QxDxyXPOFrSuBkoKN
	 jOllgasAn0D1rRZjbO9RPAXVcoHsnOZxUqMZxGpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 482/690] NFSD: Trace stateids returned via DELEGRETURN
Date: Mon,  8 Apr 2024 14:55:48 +0200
Message-ID: <20240408125417.098000192@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 20eee313ff4b8a7e71ae9560f5c4ba27cd763005 ]

Handing out a delegation stateid is recorded with the
nfsd_deleg_read tracepoint, but there isn't a matching tracepoint
for recording when the stateid is returned.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 1 +
 fs/nfsd/trace.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2f720433632b8..9351111730834 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6915,6 +6915,7 @@ nfsd4_delegreturn(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto put_stateid;
 
+	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);
 put_stateid:
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index d449c364cc76b..d55a05f1a58f7 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -604,6 +604,7 @@ DEFINE_STATEID_EVENT(layout_recall_release);
 
 DEFINE_STATEID_EVENT(open);
 DEFINE_STATEID_EVENT(deleg_read);
+DEFINE_STATEID_EVENT(deleg_return);
 DEFINE_STATEID_EVENT(deleg_recall);
 
 DECLARE_EVENT_CLASS(nfsd_stateseqid_class,
-- 
2.43.0



