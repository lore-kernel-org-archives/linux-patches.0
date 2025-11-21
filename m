Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F4E3502B3;
	Fri, 21 Nov 2025 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732533; cv=none; b=Ha9S6tmJW++ijkH4eDAfSSd9iEx2NPEJ0+jy9uv0VyxxcjY/nKt5ILM2Co3dHbiwx9VGXeWDAmFbq+CWtF7YQlLyCwi0ASlBBA8CdhGYKbKvPGVgC/6D8/LoRjNspI1bwUuupjk/Cg0Cyr+CjQhJic5vikNvYTmWqeH3U/Ul2Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732533; c=relaxed/simple;
	bh=ICsYJkkb3OKM+oSIsYn8QEruA6vEvdSAO1yPGiTrdyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDd6Q8LChf1+Ldso6ps3EUjnnyMqoJyJjgyYS7gZmu1ktX3XoBPtnS46Yffe1aKvIYztmteG0w2tRnvdrUJ8gKG706UOcuYv3jY8Xap/w+6FQpOAQVilDfPt6+kWUhrW6eEDniT6WpHOPHXFS84hecVbVRlOGgBi0aO1VfkkRUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmZ5P6Vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmZ5P6Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3394C4CEF1;
	Fri, 21 Nov 2025 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732533;
	bh=ICsYJkkb3OKM+oSIsYn8QEruA6vEvdSAO1yPGiTrdyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmZ5P6VfwlzfLpYxy85RYvxVpVUKTBG4JbDw9BbJzydkPXJ2bgGAox2Hck0nmQJK5
	 ygvi2FyhuQRDKabnzUEvrfVBRyIReT45WCeAUAppogKSKRKz8cdmRIMpJeXTdWWs5W
	 k5/+38gLYHkQxoVhJ5ThOV5TCOUpSaPBoY0eYKNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/529] char: misc: Does not request module for miscdevice with dynamic minor
Date: Fri, 21 Nov 2025 14:07:33 +0100
Message-ID: <20251121130236.498506624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ee78c76e8663..6f9ce6b3cc5a6 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -150,7 +150,8 @@ static int misc_open(struct inode *inode, struct file *file)
 		break;
 	}
 
-	if (!new_fops) {
+	/* Only request module for fixed minor code */
+	if (!new_fops && minor < MISC_DYNAMIC_MINOR) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
 		mutex_lock(&misc_mtx);
@@ -162,10 +163,11 @@ static int misc_open(struct inode *inode, struct file *file)
 			new_fops = fops_get(iter->fops);
 			break;
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



