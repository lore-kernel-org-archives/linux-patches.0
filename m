Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B636A352;
	Mon,  8 Apr 2024 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582758; cv=none; b=mc0R489FR56fh1o2TaVZg7FujLCHFb0U2mNAN/cy/SnGYP75m6Xeg5Y/PeV4H91AiJXJTqeH7beKhiwpXylDfadBAsQBLCj34UQjQsgUnwFm2TJQVznuSnBz8NLOgwOUG6SPBKu6Mt5LAkdtFzpnicI+BGMfEqKavpLPLyynp2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582758; c=relaxed/simple;
	bh=Wsx+szq+UDIgdXZZMS2oh8pcvCME6MRj7sgDOHOuu9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZeyC6nOHqFVRiwZL6VxK6WYMhL3HEQLyVqFbNweQtAo+S/nRwy6EC5R/hgfXLx+3TjWfPB+1sQ+KjluWaUwin5pjgzr/MP6xu8f5306IRE6l0+RKH6/5++74+YFmL8u/LCP5ZFIPdRHZhTOW7hzMWQAU5Cs8b42dz6kYZ/137Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhqPtiM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhqPtiM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D04DC433C7;
	Mon,  8 Apr 2024 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582757;
	bh=Wsx+szq+UDIgdXZZMS2oh8pcvCME6MRj7sgDOHOuu9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhqPtiM6trxg0jrLDjAh6YIiTurcZbWHSblWR7gLpmEJHThuy6N+WA+TFzx5OFw5Y
	 Jccmn/bz+Y49/LYRVIwAKE2yZAxZ1yJtChoAA0UmjqW9+0/YYiU+7CPbAYM4+uz/6q
	 MsIsu3nVGqAghtoHZO75BsvjkVgVttup1B3ZnAAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 131/138] smb: client: fix potential UAF in is_valid_oplock_break()
Date: Mon,  8 Apr 2024 14:59:05 +0200
Message-ID: <20240408125300.305101844@linuxfoundation.org>
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
@@ -476,6 +476,8 @@ is_valid_oplock_break(char *buffer, stru
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;


