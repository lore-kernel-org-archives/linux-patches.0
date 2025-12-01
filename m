Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3100826AC3;
	Mon,  1 Dec 2025 11:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588473; cv=none; b=PcK8oIM6vaMgLcrZun7ChR6rh+WQv7hzpZpzCmb3zOeNz+1mY6yFFjdj2dmYUmuicZ58jfM2n7FeAg8eMmLSpbgoQYfMmRcs0CwxCn1EdnDjEqkbd4BBDoOHc1KlYEoE3DDwrTbKbwcg/uRcRTzUQ4bZ0fP9iUG/dKbTMdL+wws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588473; c=relaxed/simple;
	bh=q3K6gQVe9/YXWIhDu23LNrcUZc5Y/wjKJLkRekiQPLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugZs7eeCrpE9ooKtuSLTqNmCypAKtdGCKQVUf2UZgaawKw6ar5EIL/2vFa+LnnK6YAowyhNJjF5HkBsx+18NrMq0b9oxMj5h1XMAnkSv+0aUvmehLAXh2t3oy3atAl92BN4xTyhqyMuy83LWGs17uZgMyTAvB5IuHwXwuo7Gp1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVup4oJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVup4oJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9C4C113D0;
	Mon,  1 Dec 2025 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588472;
	bh=q3K6gQVe9/YXWIhDu23LNrcUZc5Y/wjKJLkRekiQPLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVup4oJFKs9lm/r/mJOrl6tNzdGusxTqTwiN2OAzJknN9xTK8EDm29zvt8mL43jlm
	 d1zWZY8qHRd5kla9O0yNo4AzHs8OMqRop2t4r3/9m2RCS9vX35vDILH0t7OFoSXwit
	 Z3BKNq8zKVg5YeJf2Q4Kg1NY0FDi0QZTpTYTUdJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/187] char: misc: Does not request module for miscdevice with dynamic minor
Date: Mon,  1 Dec 2025 12:22:49 +0100
Message-ID: <20251201112243.446144803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 1ba0fb42aa6a5f072b1b8c0b0520b32ad4ef4b45 ]

misc_open() may request module for miscdevice with dynamic minor, which
is meaningless since:

- The dynamic minor allocated is unknown in advance without registering
  miscdevice firstly.
- Macro MODULE_ALIAS_MISCDEV() is not applicable for dynamic minor.

Fix by only requesting module for miscdevice with fixed minor.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250714-rfc_miscdev-v6-6-2ed949665bde@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index f6a147427029a..cbe86a1f2244b 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -113,7 +113,8 @@ static int misc_open(struct inode *inode, struct file *file)
 		}
 	}
 
-	if (!new_fops) {
+	/* Only request module for fixed minor code */
+	if (!new_fops && minor < MISC_DYNAMIC_MINOR) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
 		mutex_lock(&misc_mtx);
@@ -124,10 +125,11 @@ static int misc_open(struct inode *inode, struct file *file)
 				break;
 			}
 		}
-		if (!new_fops)
-			goto fail;
 	}
 
+	if (!new_fops)
+		goto fail;
+
 	/*
 	 * Place the miscdevice in the file's
 	 * private_data so it can be used by the
-- 
2.51.0



