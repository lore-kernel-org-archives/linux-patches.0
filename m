Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324B926FA67;
	Tue, 11 Nov 2025 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823489; cv=none; b=Ggy8sOMnlblixk+LkdV36DQdhhC4y9cnM14qgcTwe7VEHbSTa91QJkd5/TQrGG4wwDTUgWu6npkKswQvvk3hkRVYYQZDD+8/pjaM0YbNNlIr90ytkb2AVi5bLg6at9zp0Ws5rfw3VZnVGyKWXR9ReKffKFD4w0z+qHy18NaJip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823489; c=relaxed/simple;
	bh=XLFXVozV0fj0ysJ6xjRxwUrMrx4nvEKOvxwDAndJHjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggcrvL7amHDugkd+eJU8RV//Y3/MBYF6/PSBFW1/NryFrBTe6qhVKUeb6mC/oWz07HDmDtY4czB15ivR11yFlIDtVSKx4VqlW93qfhinNsQtWc9Fm01E9rgTAGUW6rL9EW8T9XIBU5oygTANpogExxgkb26QPp9fU6ZwIjTUYAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgqYCo7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgqYCo7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ED9C4CEF5;
	Tue, 11 Nov 2025 01:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823489;
	bh=XLFXVozV0fj0ysJ6xjRxwUrMrx4nvEKOvxwDAndJHjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgqYCo7suuoiObGK2LQcOtG+tTst/6+4PV2wOkB0NbZfc9oVDSSjSwEPoLxsjssPD
	 CMiDA0DAxjzQ2g60JnjFfwY9qPkfyRY1nx+7EPU917bCW8BaHZYIrmOcf2MIsN2fG8
	 7X/OlOHLCte4janJs1Li7rWOQhVos4tq4bLJQ3PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/565] char: misc: Does not request module for miscdevice with dynamic minor
Date: Tue, 11 Nov 2025 09:41:30 +0900
Message-ID: <20251111004532.178275959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



