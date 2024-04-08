Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2383A08;
	Mon,  8 Apr 2024 13:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582731; cv=none; b=hvkdXpC5rMQMzpHgEAgB46NGwTG/p75SgMaqApS3FZEr1EW2wnva12kYNq5Y2qghdQtCigtlnB1gQUJUQCP+X4cGvJMw5bIAW9nGVqGGVykVEtyoe66ylcCoryX/1+fTA/WV7W3zxwvCh6znK8a4hEZ8jHEwxz2R6Zp6B1VxnDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582731; c=relaxed/simple;
	bh=wiMKKPx9Zb1tVPoVTc7c5vQNPvYqgt5W3aAipyTiwjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEKZ263rZrxUDpoWmAbpufOTUsNHo4lHvN+P3Iq4UxaFKpROZd5eBHw90XJNoo5kZ4ZaIfZnKhyzVezvHa/htOaulTzpn3nFG2PrRkiUVOQvTX76K5K0NzMGW6wExsXEtxzm8W5QTXuWCfaF6YavQNQoe+dqJ7dV2IX0ZoPzjIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsmeQfNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsmeQfNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A358C433C7;
	Mon,  8 Apr 2024 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582731;
	bh=wiMKKPx9Zb1tVPoVTc7c5vQNPvYqgt5W3aAipyTiwjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsmeQfNbRhSRMn8OUwN2GcEdy+cCeRza1kWdJ9d5MT3y845sorpuTg6cIdpkYBGuc
	 KhH/ibi0hjSv6Vx2yxSvjKLJ/RYMof2C09cGEDer0QS/wmSnxEelcTNhUxijqe1Ax7
	 ed7Nnmq/2HXLQu35PftvszxOo4XD5gvpX9ND0xn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 129/138] smb: client: fix potential UAF in smb2_is_valid_oplock_break()
Date: Mon,  8 Apr 2024 14:59:03 +0200
Message-ID: <20240408125300.243956086@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 22863485a4626ec6ecf297f4cc0aef709bc862e4 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -697,6 +697,8 @@ smb2_is_valid_oplock_break(char *buffer,
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);


