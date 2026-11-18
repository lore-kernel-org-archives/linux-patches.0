Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057919;
	b=EZZfGRVQte9WkVqFQqn+oHOde33tSLNXsgHNRDKRwHcxkL8p1XgUoD2uCB+3zhwviyeI
	 MRvY+volYgI3/ZRrHdze6ydY28bn0ywZtNJCslr8nKc8Zqm1svu3XbJ+oBRWbaIdkS6Af
	 SmRVI2dyX00N4PY4w/vhq9tGb93qGKl/UC89dsWKjsH1TIxt3VdMiSAnr7tBRjg5BC3ut
	 BtbeRdr2o03PjwrQixo5Ilkc0JFS95xuJA8e1AHMrk4hrZj04scVX/aG/GFxXk/oqGjfm
	 NrRPKFf+cSf60KgofaAqnXmqBzheUY5bawCIViBTK/BoWhnjVZXhDxsJxD1feD9HLWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbvxsMCAwo9NI7K0h9neuvO/1AE+bwUg+ei+2cLsNCw=;
	b=ujAqWpbyYYcgM7hhfBQeJJLYDgQ+pZkpmZdya4bCpMiLbQHuCkTE5PnPNgCNk3giJv5M
	 SJgQyx9jXeyxbImbd7qctIoynMSH3yxo/rF4yy46cKgA6pc9HOfluCcBK+ewX1Q679Dmf
	 axr5i4ESRAZK0IVAwXx7jtAe7JhryfLotAAoBMslSB0HWrB2NbuRq7N1FpkDAfoC/JtpD
	 vGCDTCOBB++g4NQw5ECFZoA248ldflFa0ZQAFE/cSfsm2m+3jCQG7w7T2cnExrjnxBy1H
	 r18suby9m2nk7jA7XAasZVFNPjAdjdkm3vx79T9+T+VMTMOw5QPw+2E5Foei3lq+RIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTU2Iax9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB76606A320;
	Thu, 19 Nov 2026 03:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTU2Iax9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3401F000C4;
	Thu, 19 Nov 2026 03:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057919;
	bh=tbvxsMCAwo9NI7K0h9neuvO/1AE+bwUg+ei+2cLsNCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTU2Iax9T+vZD02A+MhUWPy7sedpS9RgPU/rrVOUPCkHHrlwPWSwNGNLyA0emdJ3I
	 E01A5DlmMUNHxkD3FfDlcXqf7M1Q1a1AGwGP3KohuzgFA4M5k50N8BmIyfrVtHwtd4
	 mO6QhO1uBNpS/kB5ddJipSqZ/ssKvSDN9keMLJDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0300/1848] SUNRPC: keep the first error in svc_register()
Date: Wed, 18 Nov 2026 15:38:58 +0100
Message-ID: <20261118145924.638291384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1100,13 +1100,16 @@ int svc_register(const struct svc_serv *
 
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


