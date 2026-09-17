Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D893CF1F1;
	Thu, 17 Sep 2026 19:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671849; cv=none; b=SiEqO9MT6QFSpThC1OpGwvpWfH6e/yIIj/m7xecrhe6w6OIMhJ6CbM9Hv4tt0ytwriOztqNeVR715/E8TbUi/Djo6o5HFVOtyG3Tvt+zxpIk1u8rPiM8uo0dR/xfDg7e8D65GybwNWam3t9GRBsKA5wJkH0GvYbb3Q1Nsm3fa64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671849; c=relaxed/simple;
	bh=1bXmjsR2HNBTVuLoAe6rC6/DnOqta1PFcXiLaSGf6vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwJ0ONj2AwMgIvSLcKuMzJpLfYdND5aDKObpTAV3xEMWAH1bV0sZka/viKLIXMjcGN40WvxwaHL74M4wqTdMwsFr/Yo3HaA35mA1cyO3idW/AZmUYNGRltxTCJ+GhFXE8EKJhOsSv7HgBdoqu/40L+9fE6ZREZAsgspXWDlAvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJRR8d1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJRR8d1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8881F00893;
	Thu, 17 Sep 2026 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671848;
	bh=xoQz54iDOJz5De2GZvCAeJOQ/A81TxkIGldm1wTkQNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJRR8d1S/NGkiNWFz3lYyKoxWf1aiNYoCrDhKz7uGG+unfMuFkKp82uYfUPHcpwci
	 +LaebTPZetQGQkIFmc/eSWt9eYOScUd8ORVuOyhshzbm+Yr9VOM7i/4LWhYVjd5qph
	 8eRqBjg+4MunFy6D47vAhdv3o/1x/biLCuG6LXu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1092/1102] sunrpc: Add a helper to derive maxpages from sv_max_mesg
Date: Thu, 17 Sep 2026 16:17:15 +0100
Message-ID: <20260917151608.276638910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit eff042ddf4b9587fa7394d502b93e06ec6015177 ]

This page count is to be used to allocate various arrays of pages
and bio_vecs, replacing the fixed RPCSVC_MAXPAGES value.

The documenting comment is somewhat stale -- of course NFSv4
COMPOUND procedures may have multiple payloads.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 9808eb765666 ("svcrdma: Reject Write/Reply chunks with segcount 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -163,6 +163,23 @@ extern u32 svc_max_payload(const struct
 #define RPCSVC_MAXPAGES		((RPCSVC_MAXPAYLOAD+PAGE_SIZE-1)/PAGE_SIZE \
 				+ 2 + 1)
 
+/**
+ * svc_serv_maxpages - maximum count of pages needed for one RPC message
+ * @serv: RPC service context
+ *
+ * Returns a count of pages or vectors that can hold the maximum
+ * size RPC message for @serv.
+ *
+ * Each request/reply pair can have at most one "payload", plus two
+ * pages, one for the request, and one for the reply.
+ * nfsd_splice_actor() might need an extra page when a READ payload
+ * is not page-aligned.
+ */
+static inline unsigned long svc_serv_maxpages(const struct svc_serv *serv)
+{
+	return DIV_ROUND_UP(serv->sv_max_mesg, PAGE_SIZE) + 2 + 1;
+}
+
 /*
  * The context of a single thread, including the request currently being
  * processed.


