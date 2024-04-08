Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE902DF73;
	Mon,  8 Apr 2024 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584034; cv=none; b=l/SDKvHndDl38brNEefGKwGIszEPrBfgPGn/+RXWBS51BMyY102YVbJKIsvCT761fMOhVRyp8mZFp1F9P1XpvS0yDaC04VUDKFC6jrDVCYGl4s/es0iF+56ZNJsUOib270Py6YksFEg7JI47v1Hmi7041laIssfpxiPjsxhd1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584034; c=relaxed/simple;
	bh=d/PYt8f3H859hVfDLtA4qtjSC11F/AktlrrKDUN7KmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgXrFBuotYDbbDCt3oQZelzV9k7eIPUA0vZPKJsdXt/8fT0zC1tcCuMEPRCqv9LKF/92TNRxWVS5C4MtmXuIV7uc9ORzwpAVa5eIbvEXb5Av32mOouigAcJHpAMjM+ELBdUGvHAwHksCy/akbTqDGKUEnruRV2d9zVVqmNAkM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/5DAhPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/5DAhPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A5AC433F1;
	Mon,  8 Apr 2024 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584033;
	bh=d/PYt8f3H859hVfDLtA4qtjSC11F/AktlrrKDUN7KmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/5DAhPQcFf3dWzqJjFW04TWUT2Z+b/Be2XqCJ4iYq6WszX6Ts65uI1KEdfuhpZhy
	 Pt+Srq5JSngZfQ53zcSOcO1YlJo5oik+hbWz0p+btGVe1t5TWDKiDEgszzZgvGfWhP
	 FGd9y5Lyyvpl62O9ow9U3lBHIp1teIbgCOUlNTco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 251/273] smb: client: fix potential UAF in cifs_stats_proc_show()
Date: Mon,  8 Apr 2024 14:58:46 +0200
Message-ID: <20240408125317.244328339@linuxfoundation.org>
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

commit 0865ffefea197b437ba78b5dd8d8e256253efd65 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -739,6 +739,8 @@ static int cifs_stats_proc_show(struct s
 			}
 #endif /* STATS2 */
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				i++;
 				seq_printf(m, "\n%d) %s", i, tcon->tree_name);


