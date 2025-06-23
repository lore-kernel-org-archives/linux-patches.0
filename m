Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA621AD3FA;
	Mon, 23 Jun 2025 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715812; cv=none; b=VVKfZnErrIrpFAcLMZuYx7jon1WZya7IkTJdNxp+CMM7Ie+1Qxzd8MhtalXiw7PBby1BAvkewPiSXcFhsEVMXWmarb68wcGQexLVjv+dTEY7EoZi9/jtL98gdXSDlN1tXrwkIIu211zG2gePyaYFhmmyNtMwkPblxhy1ekqYd9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715812; c=relaxed/simple;
	bh=iP1lvqWEtLgW4WJFisZvsOM3fRm0YqKH6lEhqvX+iJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVzks0Y6vZEO5Ormn8kyUdvnI/3RPjnK9NQtTOyAkES0aE5oSd2KpgUu6alAG2greR7n2D4ceqe0NTIncXJjqsFibQgtNk/fTjinG6glrcQt8LDKMNdGP1QCYABmjXh/uitgM1p0HT5WCPsr3QkgVS3bZadkfgd/9EQcVMlvnpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pejXEkFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pejXEkFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC954C4CEEA;
	Mon, 23 Jun 2025 21:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715812;
	bh=iP1lvqWEtLgW4WJFisZvsOM3fRm0YqKH6lEhqvX+iJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pejXEkFU2uGd9WMLghu0oKtnZWHfQG7cvHeJBE/XcXF3k989vfqiLoLCWdCJCVup4
	 IIBVzYOGid6aPf0BlFebc6vowEXTa2pHkqzB5EXAex7jdD99iOCuLZ7b7tBowgvc7t
	 Twp6JsdkAbU4ncJJn14BkRq0+7wcI/osye6yrHPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	xfuren <xfuren@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 243/290] smb: fix secondary channel creation issue with kerberos by populating hostname when adding channels
Date: Mon, 23 Jun 2025 15:08:24 +0200
Message-ID: <20250623130634.238623418@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

commit 306cb65bb0cb243389fcbd0a66907d5bdea07d1e upstream.

When mounting a share with kerberos authentication with multichannel
support, share mounts correctly, but fails to create secondary
channels. This occurs because the hostname is not populated when
adding the channels. The hostname is necessary for the userspace
cifs.upcall program to retrieve the required credentials and pass
it back to kernel, without hostname secondary channels fails
establish.

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reported-by: xfuren <xfuren@gmail.com>
Link: https://bugzilla.samba.org/show_bug.cgi?id=15824
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -558,8 +558,7 @@ cifs_ses_add_channel(struct cifs_ses *se
 	ctx->domainauto = ses->domainAuto;
 	ctx->domainname = ses->domainName;
 
-	/* no hostname for extra channels */
-	ctx->server_hostname = "";
+	ctx->server_hostname = ses->server->hostname;
 
 	ctx->username = ses->user_name;
 	ctx->password = ses->password;


