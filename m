Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A3523026D;
	Mon, 10 Mar 2025 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628051; cv=none; b=AFDJMTA0xPLYuKDUoG7fBscX4pOFHphdi6sBvl0FHw053hVeGDRrzPNFVQSmV+CqwXKDB0BdMZTHSgooYDk1k4677eLgodSsqdSpEvVms6wSms/DetOMZWBreul1VjB31CiFG36AuGge5pMWb5rel53DFXeveOs/jS+rfy2jfWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628051; c=relaxed/simple;
	bh=cdrLt2cNEocFNrhNTlQ1SEr65qSHTvk0iae1awzP5aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwlifXRjHkLJ5U3IhcOVWycZxR9oAiT/Vln6Iv/FOm/IW8/ZHFz3/X95cu2aKAiZmoOh9mOxN58J4a+GEXiC4fPw89PeDXNDcTID5Mrw7vuJ2b7fkdiOZDpnLbM6//bq3WXKpUrfEntIwvkh5gswRnuI3gN6Ia4ESdQ9hbf9L6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyKDLziv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyKDLziv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D48C4CEE5;
	Mon, 10 Mar 2025 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628051;
	bh=cdrLt2cNEocFNrhNTlQ1SEr65qSHTvk0iae1awzP5aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyKDLzivfqk83NfiVnJUnJTN+b1eiWFHGZtLYzUwu7UGcDvL0SaOlAVhDoZKqalGn
	 OpNa+VHIP19sYA/z5F26U8gZro4Ck8sp0jvOx/LiUh1XmSbZRMCMhC4iZU4nYKxCOP
	 GU7AXEo8JncNKnfTfOOC8wHfW/D21OHeUdjP5/pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 029/145] ksmbd: fix type confusion via race condition when using ipc_msg_send_request
Date: Mon, 10 Mar 2025 18:05:23 +0100
Message-ID: <20250310170435.912788689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit e2ff19f0b7a30e03516e6eb73b948e27a55bc9d2 upstream.

req->handle is allocated using ksmbd_acquire_id(&ipc_ida), based on
ida_alloc. req->handle from ksmbd_ipc_login_request and
FSCTL_PIPE_TRANSCEIVE ioctl can be same and it could lead to type confusion
between messages, resulting in access to unexpected parts of memory after
an incorrect delivery. ksmbd check type of ipc response but missing add
continue to check next ipc reponse.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -267,6 +267,7 @@ static int handle_response(int type, voi
 		if (entry->type + 1 != type) {
 			pr_err("Waiting for IPC type %d, got %d. Ignore.\n",
 			       entry->type + 1, type);
+			continue;
 		}
 
 		entry->response = kvzalloc(sz, GFP_KERNEL);


