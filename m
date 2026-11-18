Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044584;
	b=aoDpgFLVQnFsPG6yiHyAEbrqjIRLQD9Zzku40MmZCEjBTubWXTC2hXu9QFkBM5VPdIBN
	 VfJjsEPVXm75fyCH3N/6cWrGiJLAiWD+N8AHd+FeHCTZVftzEyLTkn1BXE8pgfR6QewSg
	 xENGRJuLF0lxjnOnaPJ0F+qTKrbUeYAjsci9mQOLWtJL2T8Pq9DQCGubHWUs+zigX8aFC
	 UG5LEy2whDXVENH0qgx79LC8cKZQ/plVK/Lzh7sO2X1902DPXC5rO6v/O1sgp0VqnJ7vY
	 4vfJlWjDbYRY0rPMSm2khCXWk0DsKOnk9ptOEsae+dTL7xIf4teARS8AQzhVrCdqLfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iy5r50J6ALtVNIXxap9UcMP0JZZ8ob4Jcve/ggTui1U=;
	b=XHPpL1esMCtQS2hHMW8tW2k7XH72MjHqewbRBCXh9wFEpNUnIet8U76ip7Zz0/IbZv5+
	 0nfrRFMzeOiYfkuIBp22Z9nwzzo/55JRRk7yMH1ieRJ1QgoBTelY7XevqWG2pBnFAlqQz
	 NF5jL+tfbpW+93qHu71UM+UKM3K2KjGQYkeKIwPa6e+xrAyAk3YjRDs7/ti0ifbmtZXMS
	 10ju/0oeeKe3f9W/QIOhfOSBhFwvPKkijidB9YN+WMF8nhPg15y4H0jATSai6wwHkiqFM
	 mT+zZmD+fMwp/m4B3nyBh3jPZ4sxhIhM6+522Q25t2EBlWj4CocvENNaEma/J1rwxhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1zHCO4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D34A606A32F;
	Wed, 18 Nov 2026 23:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1zHCO4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A521F000C4;
	Wed, 18 Nov 2026 23:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044583;
	bh=Iy5r50J6ALtVNIXxap9UcMP0JZZ8ob4Jcve/ggTui1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1zHCO4eR4vfttvdshzXfgr82G3mnuqJ6DoSvohWy3z5PXSH88bTijaV+5nJpS62H
	 KVs0p9dKnuFhAOqi9epL+GMwv5GKzfrewNtD4vsJTIuh24DZsNoyjB/ShpSyFLnrWr
	 qIW9XfVyjV1BWpXxa2RW80TgIwBBCr9xw09NB/yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0617/2857] SUNRPC: keep the first error in svc_register()
Date: Wed, 18 Nov 2026 15:27:31 +0100
Message-ID: <20261118150223.708722126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 9ed91d7c4698e611ea5bfca45076008def831fb3 upstream.

svc_register() assigns every pg_rpcbind_set() result to the same "error"
variable and returns the last one, so a later result erases an earlier
failure.

Keep the first error instead of the last.

Fixes: 642ee6b209c2 ("SUNRPC: Allow further customisation of RPC program registration")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-3-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1115,13 +1115,16 @@ int svc_register(const struct svc_serv *
 
 	for (progp = serv->sv_program; progp; progp = progp->pg_next) {
 		for (i = 0; i < progp->pg_nvers; i++) {
+			int ret;
 
-			error = progp->pg_rpcbind_set(net, progp, i,
+			ret = progp->pg_rpcbind_set(net, progp, i,
 					family, proto, port);
-			if (error < 0) {
+			if (ret < 0) {
 				printk(KERN_WARNING "svc: failed to register "
 					"%sv%u RPC service (errno %d).\n",
-					progp->pg_name, i, -error);
+					progp->pg_name, i, -ret);
+				if (!error)
+					error = ret;
 				break;
 			}
 		}


