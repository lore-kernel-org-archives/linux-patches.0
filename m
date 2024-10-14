Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA51AB535;
	Mon, 14 Oct 2024 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916092; cv=none; b=UdRMuOvaOw72I012tYWwWJoe8ae68STO51mEgS4C62f7cnbgs+OEK0Ra2EQMCrT98ydfv0GFJCq0mkqCfDMDHr2ogwUSwOFYDXhVXoT44Yl90vBACOn/qX3GZ756Oskypwn6i4I3Lqwe9ChvSvgd3MfxSm4Vc3I+DFwIBBQMB2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916092; c=relaxed/simple;
	bh=DYDfd2W5n5JzFXrYNYeHDXswy4b/fK58hXIXJSRt2uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+tsUwsYD4LTfEtPRwm8yQy78HG4alBRBWjM6lHOA4/Vyf5mpDiji8xzNKUEA6kgf1QVnxDBktW1jj4HKH8FZKTAB+hsXg4W03PyfWLfkXxY0PbWNMct24e1TT3BNVSH2OmXTABm/8YKnrijfscM5psPo0b07P4DNFWs6MC6Vbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdoTjETT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdoTjETT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A56C4CEC3;
	Mon, 14 Oct 2024 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916092;
	bh=DYDfd2W5n5JzFXrYNYeHDXswy4b/fK58hXIXJSRt2uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdoTjETTjxfyjW1vsY9XomUPuE1vMTJWddo+7MjUBoUr0SPyf311MPPe1AM39DMGc
	 xxriQT/pvG5p9Txs9tw22TI3ji7EGTm6ga3pJe9dWD6nCoqPRYGuvzb8NaTaV06SH+
	 MtL/1mgRLwABF1UbxIsSR6rJwIhClMkjy1nnROoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 082/214] nfsd: nfsd_destroy_serv() must call svc_destroy() even if nfsd_startup_net() failed
Date: Mon, 14 Oct 2024 16:19:05 +0200
Message-ID: <20241014141048.191782323@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 53e4e17557049d7688ca9dadeae80864d40cf0b7 ]

If nfsd_startup_net() fails and so ->nfsd_net_up is false,
nfsd_destroy_serv() doesn't currently call svc_destroy().  It should.

Fixes: 1e3577a4521e ("SUNRPC: discard sv_refcnt, and svc_get/svc_put")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8103c3c90cd11..58523b4c37de0 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -449,6 +449,9 @@ static void nfsd_shutdown_net(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
+	if (!nn->nfsd_net_up)
+		return;
+	nfsd_export_flush(net);
 	nfs4_state_shutdown_net(net);
 	nfsd_reply_cache_shutdown(nn);
 	nfsd_file_cache_shutdown_net(net);
@@ -556,11 +559,8 @@ void nfsd_destroy_serv(struct net *net)
 	 * other initialization has been done except the rpcb information.
 	 */
 	svc_rpcb_cleanup(serv, net);
-	if (!nn->nfsd_net_up)
-		return;
 
 	nfsd_shutdown_net(net);
-	nfsd_export_flush(net);
 	svc_destroy(&serv);
 }
 
-- 
2.43.0



