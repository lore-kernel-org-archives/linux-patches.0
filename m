Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951658F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184E1C433C7;
	Sun, 16 Jul 2023 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538699;
	bh=TPpJtr88JygWYQhE9d1M0J5jdnZNZFcnn2edHqU9sPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyhW0+GD61VjZ8PdF/ZewxBRS3EDhO1R3mP3sXW35O1lJNmESo7xaFIZyW4zhv+cz
	 SVba8w3WS/s36WUHXiLAeH4yBE4j9wIe7X2RBnw5YK3wb0tLu65xH4MWts1MbR5q/m
	 lpb8WQU64qxbDwX3rWfzwH/v9CV/hF/neAAyei4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 545/800] ksmbd: avoid field overflow warning
Date: Sun, 16 Jul 2023 21:46:38 +0200
Message-ID: <20230716195001.751586484@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9cedc58bdbe9fff9aacd0ca19ee5777659f28fd7 ]

clang warns about a possible field overflow in a memcpy:

In file included from fs/smb/server/smb_common.c:7:
include/linux/fortify-string.h:583:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
                        __write_overflow_field(p_size_field, size);

It appears to interpret the "&out[baselen + 4]" as referring to a single
byte of the character array, while the equivalen "out + baselen + 4" is
seen as an offset into the array.

I don't see that kind of warning elsewhere, so just go with the simple
rework.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 569e5eecdf3db..3e391a7d5a3ab 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -536,7 +536,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 	out[baselen + 3] = PERIOD;
 
 	if (dot_present)
-		memcpy(&out[baselen + 4], extension, 4);
+		memcpy(out + baselen + 4, extension, 4);
 	else
 		out[baselen + 4] = '\0';
 	smbConvertToUTF16((__le16 *)shortname, out, PATH_MAX,
-- 
2.39.2



