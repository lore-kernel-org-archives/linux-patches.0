Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737687BB11;
	Mon,  8 Apr 2024 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583937; cv=none; b=fxn0ATKSXb5CksUH+Imuo4daLveFHl5rpyLpbV7z6avMBn/3LhD8TmcSpfGXlk70LueivGiuSLmZZU/2xAG7w8KqXvGrnHIpo69danXvqBKFqdg48zeT0zUgnUt2Ktku878tLE5DG9qFQs7r3z88cm/yrX+vYq+QdwnzUEIDY3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583937; c=relaxed/simple;
	bh=KWxUKeNLYb+X3/UV0Yt9IY21zIxFDM4Ta2Xw9pl+E5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF+lYvr8NRik81ilVTln9+OXIylMYRxEJNBmyGz0H4nd+pRcNMhXgMWnH1Pu+PmSHSKydMf80N/F0lSBBbZsgaQRfnGNln8AUjjMtWCLGRCzMKUj1Mh/qB2DZg0Zy7Hzg3O6lxtT3N/Rs/CZdBX1ZJU1hjRhqGvQIQpF/RovXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EL9QhUvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EL9QhUvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07CBC433C7;
	Mon,  8 Apr 2024 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583937;
	bh=KWxUKeNLYb+X3/UV0Yt9IY21zIxFDM4Ta2Xw9pl+E5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EL9QhUvp67PU0MRH2RLsD5rAMIAg/NKUi/DmyzA6JEtAl2Iyc8scR+7vWLK+0EdwR
	 q/931hKamWuAsMOVpEHM3s6qmDh9wDRrtMQYmJaptTn4Xrwfbl3ZihIiw51Nivmmup
	 FmDPUuvxvBzmszPa83pImbK/rkZ+hIx7qOgJ0I4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 236/252] smb: client: fix potential UAF in smb2_is_network_name_deleted()
Date: Mon,  8 Apr 2024 14:58:55 +0200
Message-ID: <20240408125313.976895194@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2430,6 +2430,8 @@ smb2_is_network_name_deleted(char *buf,
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				spin_lock(&tcon->tc_lock);


