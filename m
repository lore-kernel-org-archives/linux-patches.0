Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398FA7E0E8;
	Mon,  8 Apr 2024 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583766; cv=none; b=Rl8vcFpr5m39JUuoQEbd1h/xSrB9qtCih6YKxgGHZWjG3C6UQ+EQax2KgLqzJBinBUQyiUZEnLOT6k2WhJ7dlDWskP8hrClyLjPn7EKVcwq1xZQrdi+dI4aqB+jSFISKB68HhSA1o8DiOlieLOeSXGqxLe/LmiRDQkvKhNaAr7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583766; c=relaxed/simple;
	bh=GFnEyf05pp/8sRv/No2JapBeR6ydVLJLrJy/pY3lEP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqDUcS3dCUeGkcFoOPBR2ZE1rFpESh2X13ub4cn20wFKbiP/beIXRao2Iga9zl2yJbQqZa1+xAYWP70rg8IKdIue63YysUVCB8y+EhstClB/o4TeJUJzIhDMamuQfnyLTs1zSDn/xPMV2aQYzzdyGUJjHiSpAgV5YZiEX2YjDcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly0SQHRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly0SQHRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F18C433C7;
	Mon,  8 Apr 2024 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583766;
	bh=GFnEyf05pp/8sRv/No2JapBeR6ydVLJLrJy/pY3lEP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ly0SQHRCtzHsg62Yl5beKP4flLg6vyNncnXWiAdF1dnGHNgytFuo7vE1YmqdaDRoB
	 V4VMv+LxOP2ouMrdbPrm77Fw7tEnc6QVLoiMmrPlB09RWqEHoOMZGIL0Qz3CJbUCgN
	 lq5V7iUh1zohOJkCMYrSB/GNYWWPRHJV9Lv1c3rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 231/252] smb: client: fix potential UAF in cifs_stats_proc_show()
Date: Mon,  8 Apr 2024 14:58:50 +0200
Message-ID: <20240408125313.824099039@linuxfoundation.org>
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
@@ -736,6 +736,8 @@ static int cifs_stats_proc_show(struct s
 			}
 #endif /* STATS2 */
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				i++;
 				seq_printf(m, "\n%d) %s", i, tcon->tree_name);


