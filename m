Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4944434B419;
	Wed,  3 Dec 2025 16:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779124; cv=none; b=eGqxQjYZFUBcD+SUmDUB3vtZEbKRH+Ca0IO3V2i+X9PKEDDKf+xcK+mR4zCMq02MA+edGHRO6D7l6sgy1K6iST0iMduDrAZyTbVq2mpoXU3orH2Gy4Tb7zTNmvlxjgSK3b9U1PG6wIfzx0npehYIHKsEg45KmqyOoP2LSz77nYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779124; c=relaxed/simple;
	bh=Kd0edrNUr8qslfSUhObP9zCK2+xc+wXroTBo8LFcHxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8UcZLNSKM7fJ4vI9laasXqz+PiZQLTSv+ca9Vi9TLkkPBkmjcMSGL8EbGgGwC2fk9VGeMs47BxIBmzmTS7LeMwriwLsAwje4h7T1SYetCeVGLLui1sWRxj8YUUxaYKAfxPP7z3155JJqmczne87PvdWFHS4tJ1/U+FG2gjqXHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mzo66f1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mzo66f1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5BBC4CEF5;
	Wed,  3 Dec 2025 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779124;
	bh=Kd0edrNUr8qslfSUhObP9zCK2+xc+wXroTBo8LFcHxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mzo66f1YR0b6sIpBkDvtvN1aYWcxBX5kOzjwSvQEyR1jPNbPJz662KzWX99QJDgwS
	 avXwEbteQgcJdm/V5/iaO3J6eVL7UkfFDAVXsWA75hv7coBwCGVbSx39DHAmjFcfKU
	 Z6x8MiIeieKNWbyRu02BbQvFJqrMbHVLckzcehM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/568] char: misc: Does not request module for miscdevice with dynamic minor
Date: Wed,  3 Dec 2025 16:22:44 +0100
Message-ID: <20251203152446.656906574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cba19bfdc44dd..b5dd944d0282d 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -114,7 +114,8 @@ static int misc_open(struct inode *inode, struct file *file)
 		break;
 	}
 
-	if (!new_fops) {
+	/* Only request module for fixed minor code */
+	if (!new_fops && minor < MISC_DYNAMIC_MINOR) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
 		mutex_lock(&misc_mtx);
@@ -126,10 +127,11 @@ static int misc_open(struct inode *inode, struct file *file)
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



