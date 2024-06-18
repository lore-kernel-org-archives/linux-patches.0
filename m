Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3626213AD07;
	Tue, 18 Jun 2024 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714914; cv=none; b=jk6xf0a3RR7S7ZcEe12wervI7PbKTlvBJHMuA7uWfDDvVPv3Ws85bPzlwi09DGaebOnP33CMy5ExxSQuqMxmmIsoeqnmgzCgHgQgSlAPpIL5CAXcZcmu3P+LaKrPyuovTb/APfl3WXvo0OeqyioqA9cIxYPR4cHeyhKuNQguAzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714914; c=relaxed/simple;
	bh=vUcJZEqaksnwKjpAcldgAaF80sf2htI1AVni4nOrYrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8qwMSqJs1hSXDnRjnRXTMz/IqBN1qNpz2B4IHe1tf0ShpnxlrdqyBOodaEbGHPM5RCQkUhHhQjAPA+STwYq/Zpf91BU3jC85/7eXD0P7P9RE+OxtJuheRa/DlBu+m3gAbKeZGYKaK4AejThALG82HfK8DhhQmCplPvYahpsHRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqkzkXoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqkzkXoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE9DC3277B;
	Tue, 18 Jun 2024 12:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714914;
	bh=vUcJZEqaksnwKjpAcldgAaF80sf2htI1AVni4nOrYrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqkzkXozlmkuY3WFOTlifp8CKYggYUrFPlkgqh3WTmk2ZPKAQdt49t5xFXaD7OWAA
	 +cNxVV6hqPXb9tuwPSPX6Yid5wjROJvLyMM1SVteL1txnyciMNMPapPQPYM66Uu+vp
	 AIA1HrkIgeh2bsyqo+poswLw7HfUb5P/qTStZsNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/770] NFSD: Fix sparse warning in nfssvc.c
Date: Tue, 18 Jun 2024 14:29:44 +0200
Message-ID: <20240618123412.333836188@linuxfoundation.org>
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

[ Upstream commit d6c9e4368cc6a61bf25c9c72437ced509c854563 ]

fs/nfsd/nfssvc.c:36:6: warning: symbol 'inter_copy_offload_enable' was not declared. Should it be static?

The parameter was added by commit ce0887ac96d3 ("NFSD add nfs4 inter
ssc to nfsd4_copy"). Relocate it into the source file that uses it,
and make it static. This approach is similar to the
nfs4_disable_idmapping, cltrack_prog, and cltrack_legacy_disable
module parameters.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 5 +++++
 fs/nfsd/nfssvc.c   | 6 ------
 fs/nfsd/xdr4.h     | 1 -
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 6b06f0ad05615..1ef98398362a5 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -50,6 +50,11 @@
 #include "pnfs.h"
 #include "trace.h"
 
+static bool inter_copy_offload_enable;
+module_param(inter_copy_offload_enable, bool, 0644);
+MODULE_PARM_DESC(inter_copy_offload_enable,
+		 "Enable inter server to server copy offload. Default: false");
+
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 #include <linux/security.h>
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 3fb9607d67a37..423410cc02145 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -33,12 +33,6 @@
 
 #define NFSDDBG_FACILITY	NFSDDBG_SVC
 
-bool inter_copy_offload_enable;
-EXPORT_SYMBOL_GPL(inter_copy_offload_enable);
-module_param(inter_copy_offload_enable, bool, 0644);
-MODULE_PARM_DESC(inter_copy_offload_enable,
-		 "Enable inter server to server copy offload. Default: false");
-
 extern struct svc_program	nfsd_program;
 static int			nfsd(void *vrqstp);
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index a60ff5ce1a375..c300885ae75dd 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -568,7 +568,6 @@ struct nfsd4_copy {
 	struct nfs_fh		c_fh;
 	nfs4_stateid		stateid;
 };
-extern bool inter_copy_offload_enable;
 
 struct nfsd4_seek {
 	/* request */
-- 
2.43.0



