Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2A5370E4
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DB4C433EF;
	Wed,  7 Jun 2023 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171814;
	bh=eL550BBh8IY2byjPiqFShEUDyXJ3Lg1EcgNmyYJtSQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHgQvwBTELBRWei88fZm97PyYC0kCyqdplqHK3TK6GArl6AramCJ7zdue03E+lcRx
	 AMouVE6+V1Z/9S3EhRAkIJVkURoqif1mYl5IYrUJ5S0FDII2EEFGAshQgM3zFBDAsA
	 3J4xcur9bZYYghDhMfjr/bm50F1OH3ncvSFpVlXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 144/159] ksmbd: fix credit count leakage
Date: Wed,  7 Jun 2023 22:17:27 +0200
Message-ID: <20230607200908.381111650@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 84c5aa47925a1f40d698b6a6a2bf67e99617433d upstream.

This patch fix the failure from smb2.credits.single_req_credits_granted
test. When client send 8192 credit request, ksmbd return 8191 credit
granted. ksmbd should give maximum possible credits that must be granted
within the range of not exceeding the max credit to client.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -338,13 +338,9 @@ int smb2_set_rsp_credits(struct ksmbd_wo
 	if (hdr->Command == SMB2_NEGOTIATE)
 		aux_max = 1;
 	else
-		aux_max = conn->vals->max_credits - credit_charge;
+		aux_max = conn->vals->max_credits - conn->total_credits;
 	credits_granted = min_t(unsigned short, credits_requested, aux_max);
 
-	if (conn->vals->max_credits - conn->total_credits < credits_granted)
-		credits_granted = conn->vals->max_credits -
-			conn->total_credits;
-
 	conn->total_credits += credits_granted;
 	work->credits_granted += credits_granted;
 


