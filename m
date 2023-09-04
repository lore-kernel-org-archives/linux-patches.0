Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066BAC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA3CC433C8;
	Mon,  4 Sep 2023 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852303;
	bh=TNNy8Qjy57OkYRPEy89X89oWn1rE2hipgfzRTIUgSZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtnjzuUHm6l9aU3E/3MznFldJvLcOOlqfc39LjVMSMiNupn0IJgHyX8lZCs7MAfEA
	 REzMsPlYRu99EIq4uzNQkaeG3zBGDlvefxy+XIQR07lWPD0wu8vrqdWmpQVWxagxpl
	 vIF/atEjnjmRmZ6hdD7e8/Wtf0+HBxz/pgLnCRhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.5 04/34] ksmbd: fix slub overflow in ksmbd_decode_ntlmssp_auth_blob()
Date: Mon,  4 Sep 2023 19:29:51 +0100
Message-ID: <20230904182948.806499601@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 4b081ce0d830b684fdf967abc3696d1261387254 upstream.

If authblob->SessionKey.Length is bigger than session key
size(CIFS_KEY_SIZE), slub overflow can happen in key exchange codes.
cifs_arc4_crypt copy to session key array from SessionKey from client.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21940
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -355,6 +355,9 @@ int ksmbd_decode_ntlmssp_auth_blob(struc
 		if (blob_len < (u64)sess_key_off + sess_key_len)
 			return -EINVAL;
 
+		if (sess_key_len > CIFS_KEY_SIZE)
+			return -EINVAL;
+
 		ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
 		if (!ctx_arc4)
 			return -ENOMEM;


