Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9915FA85;
	Mon, 27 May 2024 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836396; cv=none; b=b1UGTIUML8+1wgQ3FeGiIBtgIvM4AWmWdVNjAi0OYP2kmoULuRWg/JE7opNVYvEzC/P6eoFzbErafYLFBunlBL4qYcrSfFG9rKVJLI+1sAFThmIKXkzAqJQhmZB7tTSNMdkZxtkqSMPY+wN2bLGu/R6RpT9QjpUBMPc+eclzMoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836396; c=relaxed/simple;
	bh=TFWZVYU0zpp24g2JnSb5L8X4sPeWUgruo6TekkRAxKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAWthwnCy7d6sOPRiNCDsSUh/muv2Ba6lYWvTq7QTokmBY1/rd/V426kmJLZz4llipw3sppZLgnovQ7a3UjjpY7G+W6Rf2kHKjdJ6cHvtUcAsIyslAV9eWFVeTXDyleTst2ntCcHShlWFiHmb8D69JAsTaXlUZSXoH0iLa2XPAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znt7oAWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znt7oAWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2F2C2BBFC;
	Mon, 27 May 2024 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836396;
	bh=TFWZVYU0zpp24g2JnSb5L8X4sPeWUgruo6TekkRAxKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znt7oAWzqqD8jWlY4oC7+tCLLMxs4hTeg3QBANQDVEWmYixrGnSgMBZFcqrNOfJyY
	 10WLJEZIpDgzjg5kwZLa7ZSTtyVjcZ+LSG8TZU5P4TqepuvALia35vw35O9jEJh52C
	 e5LwVvd34BXwluW/ZzCG+tLCCi0MmlZmKw460G0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandor Kracser <bonifaido@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.9 036/427] ksmbd: ignore trailing slashes in share paths
Date: Mon, 27 May 2024 20:51:23 +0200
Message-ID: <20240527185605.040443000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nandor Kracser <bonifaido@gmail.com>

commit 405ee4097c4bc3e70556520aed5ba52a511c2266 upstream.

Trailing slashes in share paths (like: /home/me/Share/) caused permission
issues with shares for clients on iOS and on Android TV for me,
but otherwise they work fine with plain old Samba.

Cc: stable@vger.kernel.org
Signed-off-by: Nandor Kracser <bonifaido@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/share_config.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -165,8 +165,12 @@ static struct ksmbd_share_config *share_
 
 		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
 				      GFP_KERNEL);
-		if (share->path)
+		if (share->path) {
 			share->path_sz = strlen(share->path);
+			while (share->path_sz > 1 &&
+			       share->path[share->path_sz - 1] == '/')
+				share->path[--share->path_sz] = '\0';
+		}
 		share->create_mask = resp->create_mask;
 		share->directory_mask = resp->directory_mask;
 		share->force_create_mode = resp->force_create_mode;


