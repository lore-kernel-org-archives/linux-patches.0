Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242DEC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500BBC433C7;
	Mon,  4 Sep 2023 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852555;
	bh=D1M75R9RoVXwLz+mwAUonWEFESUioxM2yYwcib54U68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXmB+G1cHHHOMr5iVCWESewdxJIcuFqoTVJLbb/tAJQGuoKqPNGz2h9Y9T/kJrWuf
	 uq4TkYUTLZncqHjoAEI/E9qZKMx5nhDjPiF6pcWWeLKI4XXaywdWioxJg2WB6BkpCL
	 LkauczL3FJAX3KxdJn5fK/dFJbKvsggiJLwJPDYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 02/28] ksmbd: fix wrong DataOffset validation of create context
Date: Mon,  4 Sep 2023 19:30:33 +0100
Message-ID: <20230904182945.298741789@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>
References: <20230904182945.178705038@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 17d5b135bb720832364e8f55f6a887a3c7ec8fdb upstream.

If ->DataOffset of create context is 0, DataBuffer size is not correctly
validated. This patch change wrong validation code and consider tag
length in request.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21824
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1485,7 +1485,7 @@ struct create_context *smb2_find_context
 		    name_len < 4 ||
 		    name_off + name_len > cc_len ||
 		    (value_off & 0x7) != 0 ||
-		    (value_off && (value_off < name_off + name_len)) ||
+		    (value_len && value_off < name_off + (name_len < 8 ? 8 : name_len)) ||
 		    ((u64)value_off + value_len > cc_len))
 			return ERR_PTR(-EINVAL);
 


