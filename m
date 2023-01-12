Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1284D749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E2AC433D2;
	Thu, 12 Jan 2023 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532408;
	bh=YiyV8zWoNEHoS6O2/wYwT2h5G7m0Wj9gvhJbJaeFG2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fMM/i+MNeNXr5+8WmSlxikbQ004WMrQAk+Js2eRWlqxu1hzF5e9O0ot/ODf019zP
	 dRXSJ0QPIIU5Hr3HLn4e6qOEyWcFEhh75Ygo6ON1uHFYR7v7Y2Mm61MLoYVslw7nMu
	 oQnhD/WSGBrH7oHkGdRuDhW23WXWLXxnkv8AUVTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GUO Zihua <guozihua@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/783] integrity: Fix memory leakage in keyring allocation error path
Date: Thu, 12 Jan 2023 14:47:49 +0100
Message-Id: <20230112135531.442734600@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 39419ef7af0916cc3620ecf1ed42d29659109bf3 ]

Key restriction is allocated in integrity_init_keyring(). However, if
keyring allocation failed, it is not freed, causing memory leaks.

Fixes: 2b6aa412ff23 ("KEYS: Use structure to capture key restriction function and data")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/digsig.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 0f518dcfde05..de442af7b336 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -120,6 +120,7 @@ int __init integrity_init_keyring(const unsigned int id)
 {
 	struct key_restriction *restriction;
 	key_perm_t perm;
+	int ret;
 
 	perm = (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW
 		| KEY_USR_READ | KEY_USR_SEARCH;
@@ -140,7 +141,10 @@ int __init integrity_init_keyring(const unsigned int id)
 	perm |= KEY_USR_WRITE;
 
 out:
-	return __integrity_init_keyring(id, perm, restriction);
+	ret = __integrity_init_keyring(id, perm, restriction);
+	if (ret)
+		kfree(restriction);
+	return ret;
 }
 
 int __init integrity_add_key(const unsigned int id, const void *data,
-- 
2.35.1



