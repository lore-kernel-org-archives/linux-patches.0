Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02053309EFB;
	Mon, 13 Oct 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368670; cv=none; b=ht3xwxEfhySIPTyU0gj/lcTYWoGf/JCZ6AT3sLFBIKq9JrnBLfRr9wPELNefMdE1SJw+9gJ6Iv5rTFeVN5QCcdZq/slpKs2+G164M0P8f187fQ3wlCkYTb0IooRLY6/AoHhaH144SClTPte5AuJbk1WQbWD3zF65rCDULl1ct1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368670; c=relaxed/simple;
	bh=xLi/MnsewopkYbgdb04AaLD89EieCnHYB2xrjY3w8Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4DoM5BMOvJjwHfhst8fUEYPFra0IY6OH+CKYt1Jn2NsB6qszFTvQpqDqst2YlPoytdSMEUn51QVY0wUTJIA+/YxzghKaLCFkqU0vcZ/pjG6pr5nHGMa/0UiR/lGN4aq7pMSJPBjO0oaAwtiUf7qmohegVi1j/HwqYuYZUxV2e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKjT4ntW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKjT4ntW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22633C4CEE7;
	Mon, 13 Oct 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368669;
	bh=xLi/MnsewopkYbgdb04AaLD89EieCnHYB2xrjY3w8Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKjT4ntWAUeHRbc8koYYD8tViy+0Hl6mYGpKoJ4LtHiNaozYTowiCCVNn5KpTHlK9
	 Z4qB4KTQxEskGIWFdEEWtY0ueh5MrfsmiCrkyQi5k+FYApVtGsKxcrw9ag6d/QijPc
	 D9DYBmS/Aa/maO8smaKRGEjOk/QgeOx0hneW+ZVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 240/262] ksmbd: fix error code overwriting in smb2_get_info_filesystem()
Date: Mon, 13 Oct 2025 16:46:22 +0200
Message-ID: <20251013144334.881693368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

commit 88daf2f448aad05a2e6df738d66fe8b0cf85cee0 upstream.

If client doesn't negotiate with SMB3.1.1 POSIX Extensions,
then proper error code won't be returned due to overwriting.

Return error immediately.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e2f34481b24db ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5600,7 +5600,8 @@ static int smb2_get_info_filesystem(stru
 
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
-			rc = -EOPNOTSUPP;
+			path_put(&path);
+			return -EOPNOTSUPP;
 		} else {
 			info = (struct filesystem_posix_info *)(rsp->Buffer);
 			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);


