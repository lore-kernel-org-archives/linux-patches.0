Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6293E3C462
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8TyCONC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7ACC433C7;
	Wed, 15 Nov 2023 19:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077501;
	bh=6LwYQ5uai5ky5pU6LR2auuVtXG8Lbk2ljJ747SSqdVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8TyCONChqM80RBYbpWM1QQ3pWVAjF/miwjcWZitdTIUOe1n6Tw/57ZnOLAAM0iUd
	 2eKBvAALm5EvAkpSu75VgvI4Tw2AFQ+pjjId+tmTwRXtxTnl9Oho+OM609opxc08P4
	 m6iWKLN9Zvdz21EEf67ny/WJMcrvCqO0cLSPCd4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 341/603] crypto: ccp - Fix sample application signature passing
Date: Wed, 15 Nov 2023 14:14:46 -0500
Message-ID: <20231115191637.115712327@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2ad01eb5fad24627ab4e196dc54a220753b2238b ]

When parameters are sent the PSP returns back it's own signature
for the application to verify the authenticity of the result.

Display this signature to the caller instead of the one the caller
sent.

Fixes: f40d42f116cf ("crypto: ccp - Add a sample python script for Dynamic Boost Control")
Fixes: febe3ed3222f ("crypto: ccp - Add a sample library for ioctl use")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/crypto/ccp/dbc.c  | 1 +
 tools/crypto/ccp/dbc.py | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/crypto/ccp/dbc.c b/tools/crypto/ccp/dbc.c
index 7774e981849fa..a807df0f05974 100644
--- a/tools/crypto/ccp/dbc.c
+++ b/tools/crypto/ccp/dbc.c
@@ -68,5 +68,6 @@ int process_param(int fd, int msg_index, __u8 *signature, int *data)
 		return errno;
 
 	*data = tmp.param;
+	memcpy(signature, tmp.signature, sizeof(tmp.signature));
 	return 0;
 }
diff --git a/tools/crypto/ccp/dbc.py b/tools/crypto/ccp/dbc.py
index 3956efe7537ac..2b91415b19407 100644
--- a/tools/crypto/ccp/dbc.py
+++ b/tools/crypto/ccp/dbc.py
@@ -57,7 +57,8 @@ def process_param(device, message, signature, data=None):
     if type(message) != tuple:
         raise ValueError("Expected message tuple")
     arg = ctypes.c_int(data if data else 0)
-    ret = lib.process_param(device.fileno(), message[0], signature, ctypes.pointer(arg))
+    sig = ctypes.create_string_buffer(signature, len(signature))
+    ret = lib.process_param(device.fileno(), message[0], ctypes.pointer(sig), ctypes.pointer(arg))
     if ret:
         handle_error(ret)
-    return arg, signature
+    return arg.value, sig.value
-- 
2.42.0



