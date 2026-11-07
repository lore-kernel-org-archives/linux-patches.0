Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061744;
	b=jzExnyuorP7DzhfAv03RRCJrZ5fdOzvadB801PuFjPSs0Ec2JbJr8fyi0Qc6PX9I89CS
	 yC1jwLuqdkRcvvwnDSFYVDIJVzMZnpDZ6eZ1sKjyr829Jc0CvpQrB4tyYkSXf3ji5oYd4
	 Xm+snKHXPCyAPZeQavdaV5M+gWJAuSb/31E3aYmyXDtM/MXhOGvmoWuwtWGCirNpffLuF
	 GEpbl5rzHVaBr/VxE26nMjzdErcEEolz55H/+tbuxaPVMmGVRSK6+ahbn0AezwngKVZYy
	 wHX/mLdaF/Yy2Hr2DHte+uoqWyJ9G70Mx5L8X7Wz6+/ZZw6wE29dQyT1wwKLNm3Coww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r9axXoodB+mv2NtqsxH2d1wx7qOX5BOH0k/xSqVv3m0=;
	b=pEOrEbGwkqyxtXBBpDgGgrDpoaL8VvcVKM11N22DKKLdx5NGzSuN4gMhQmQVwsqOHJgi
	 WtB+q/Ou/t/GOnbfVN0XJCy4YBvxtzOxE1b4Kyckr4Ply9mQ08uHf9z4syabcbd1JliDc
	 yonR5MmzU9PxkU625j/E9/vU38OdzjbghiOxDTW4YkYSLvh3fWi06d5kF2iOXR3fulLRT
	 kGCFrsgasZj5Cjw4ZMu6vEDzEHYVXEPfqEeXSVMTog4wiuy/FYLC0OJM1q3PYZSfFO9Go
	 tT5RkSrQ+F6ETzQIcA7l4QQC8AqTiO/D/VTfSEyoD+bKeDTZ/3l+IMhFo3c0z7baWtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVJaBnNS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3C7606A326;
	Sat,  7 Nov 2026 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVJaBnNS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD49B1F0089F;
	Sat,  7 Nov 2026 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061744;
	bh=r9axXoodB+mv2NtqsxH2d1wx7qOX5BOH0k/xSqVv3m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVJaBnNSyvHsGpnLieQn1gdw1gAnjQRlR9aOPF91oZ9rblxnYwwiNlL7JCGw2J8ch
	 PTUCygLcu6TET/dUxsOxeQDhYYURCPonqZjkuCHgtnibwCQirWOKwFP8PoueFUjtGs
	 PNlsqaZFyzhD3QUhAXq3dLOvczTTYt7zrVdDTf28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0782/1536] SUNRPC: keep the first error in svc_register()
Date: Sat,  7 Nov 2026 08:46:38 -0500
Message-ID: <20261107135019.503823355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -1233,13 +1233,16 @@ int svc_register(const struct svc_serv *
 		struct svc_program *progp = &serv->sv_programs[p];
 
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


