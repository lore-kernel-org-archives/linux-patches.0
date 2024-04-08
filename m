Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E457C09F;
	Mon,  8 Apr 2024 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584066; cv=none; b=jH4RkgC1phBVKldEeNgDpnwre0BNp1MeoK8m6ckUC11uQqMb5yko4hn+UBCxLvRZBI+mAOEr9lddo5l+G6yw0A4I3bsvVZ8XPCsRSX25ihjllyqVWCrsx8WnpCcS/haiKZikffSTCHEvnRWD8aQuCixdky3vFNIt5jpeb2dpTFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584066; c=relaxed/simple;
	bh=FFOHxYn6rBMm1nqr9E40rE6UzGIfy2vaZblcFuODqAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnaZpDoF2RWal+1KsEAan4xb7Vo5Gdq5Qm5nrwPtvHuN4zut/bf0i+rjSRj++spMgNo80+zU8nyRQS2ynR/kJPqz9nG/GCDG+J5wwGX1qvk1/myciwK7jNlfYvJcIxCcVFBboWGlRTVUpbCVyFiyf5wSaQbXkcaRX6DgeAzquoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU9tmJau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU9tmJau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A4CC43394;
	Mon,  8 Apr 2024 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584066;
	bh=FFOHxYn6rBMm1nqr9E40rE6UzGIfy2vaZblcFuODqAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU9tmJauBCkDUsEdoJjPfJuvZrBIlm10Zxiz/oNLEBU4PbR2OwkE4NbawNiIyeV74
	 +ZcW7/EVmFftM1wceIMf56eSzrHmn/X7OSJuBr4hRukuruhcqt3sb8BrMQ7L/uOLl5
	 TCrjrTgFwhO6SiZrQu5iYbYTkELzr0ruacV3cPLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 256/273] smb: client: fix potential UAF in smb2_is_network_name_deleted()
Date: Mon,  8 Apr 2024 14:58:51 +0200
Message-ID: <20240408125317.403662345@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit 63981561ffd2d4987807df4126f96a11e18b0c1d upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2480,6 +2480,8 @@ smb2_is_network_name_deleted(char *buf,
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				spin_lock(&tcon->tc_lock);


