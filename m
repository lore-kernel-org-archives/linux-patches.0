Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD447E0E8;
	Mon,  8 Apr 2024 13:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584060; cv=none; b=g3OYiAAd3dRA2IfkZRqu0iz5r37Bx4igDAIIbMM+TU+jgRM+gHesAyapURPVXip/lboop2pUVyA7QrG3lzdIM2lKyHLNe868aBbq742wb8wJHFQFjYZ7Me8+2p2puLxayApHw2mTRNjgrod7MWL5t5OX8UMQASstVgCcIkZ21KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584060; c=relaxed/simple;
	bh=tvtxMN9mJpyUB0FziMfqpdqjkz/Hk53Es0aTyzvccIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crqtaK9xaWb2zttvK1ekBldUb+RrJuu1/4JDwRreQbTO8y2SWgwXo/JOpG6pbvhXcxxZbLC3IhO81tN+nJW2d4aynDVS1WSRX0hViz/JiTqZBNFE0RlB7bI4A1Qhj3Q9GgN5DkYVWVgPUi/Wm3RHoYhxSpXK5BcZgJnyDY55ojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyT9x2TF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyT9x2TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D2DC433C7;
	Mon,  8 Apr 2024 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584060;
	bh=tvtxMN9mJpyUB0FziMfqpdqjkz/Hk53Es0aTyzvccIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyT9x2TFRVgoIxu7jgRhwsFro2qpIEN4ORG0vYZXf8rWQUpUkTVt8WhiTAEMXF0TU
	 MUdsx4Nad7+loQr72AsURCcf28rjx999EF3mzAm5hgjUzS0op7U4/CYFTqcguIHtax
	 wqknIVqU04yUxnhuuvoAjfVe8xZ2y71LjnCh6GP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 255/273] smb: client: fix potential UAF in is_valid_oplock_break()
Date: Mon,  8 Apr 2024 14:58:50 +0200
Message-ID: <20240408125317.366102188@linuxfoundation.org>
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

commit 69ccf040acddf33a3a85ec0f6b45ef84b0f7ec29 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -484,6 +484,8 @@ is_valid_oplock_break(char *buffer, stru
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;


