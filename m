Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8A824DCF8;
	Mon, 23 Jun 2025 13:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684359; cv=none; b=hD4FjNi2ez9toTbJ5k7y+XlchhYJFW3OYerulc3Rf9a1Sf8eSkRI61OkMncJ04En41KNNLLPiwsOdtrOUvKaO8pvrLtPOIZdkcFM1T3ySzBK9s9OsCiJH9PHAOrqihQP7ypUOejup6PSrFngZ9DoDvsZRUhuhgcqEaJZMjsGR3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684359; c=relaxed/simple;
	bh=V+7lnHcITiyZc/5pBMk/qnSdeiLsiuTu06vvY6anQ3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIerNxWsCgulA1PVJzSH8wxCTYn+o8/2h/TPfFK0KCE8RE0r78UkBUj5j5W6dsDfcPLRKhWwwRWAnJgfGEEyF65URkC19HkV4U638Y6aqwm6t8ukvBBhhK5+OKxHkvoeVUVwTaOvqaxfO+tkFw7soVMvTGnaI/g7HO8UyDUANqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSPqTH4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSPqTH4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31203C4CEEA;
	Mon, 23 Jun 2025 13:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684358;
	bh=V+7lnHcITiyZc/5pBMk/qnSdeiLsiuTu06vvY6anQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSPqTH4g5Sc/UhCtMMg7ufECbM+c4aQdA1il0Bo78G4BOZ4XTZq9YvD9VMyY7halx
	 mf4mSk6v5k9eMqVwCZDLoKkyjG2BanQppccTFn1Qd2amq12TyQ9kiiz9nY0jB4RjEs
	 q9gy2US0r+RnrUksCjtuXIZRhcugKJhmLnDaiiRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maninder Singh <maninder1.s@samsung.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.15 039/592] NFSD: unregister filesystem in case genl_register_family() fails
Date: Mon, 23 Jun 2025 14:59:57 +0200
Message-ID: <20250623130701.174291178@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maninder Singh <maninder1.s@samsung.com>

commit ff12eb379554eea7932ad6caea55e3091701cce4 upstream.

With rpc_status netlink support, unregister of register_filesystem()
was missed in case of genl_register_family() fails.

Correcting it by making new label.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2305,7 +2305,7 @@ static int __init init_nfsd(void)
 		goto out_free_cld;
 	retval = register_filesystem(&nfsd_fs_type);
 	if (retval)
-		goto out_free_all;
+		goto out_free_nfsd4;
 	retval = genl_register_family(&nfsd_nl_family);
 	if (retval)
 		goto out_free_all;
@@ -2313,6 +2313,8 @@ static int __init init_nfsd(void)
 
 	return 0;
 out_free_all:
+	unregister_filesystem(&nfsd_fs_type);
+out_free_nfsd4:
 	nfsd4_destroy_laundry_wq();
 out_free_cld:
 	unregister_cld_notifier();


