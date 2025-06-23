Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CCE19C554;
	Mon, 23 Jun 2025 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714067; cv=none; b=kEA9L9nIOBmNiQ4PmclVwscf6F2uX0pL3e23zSJoiNTMmNsOIMVyfnEVklIa+YXTAbu/MzXuiYAoNSDyDJhb9ZI5urSw40cE0d0bOcJPPRKjGGtkMtkoRCQM+VQ4JFGx0v2efirfdRD46wUs9IP2ZfhSL2XVdVIut44JNpiLsDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714067; c=relaxed/simple;
	bh=H7wMhU1U96Z+AW0stYIeRuy/q347GKnX5vB8THidO44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjUo8fxKQiNOMsC5nqJy8els/fS/jnuxCX6JU+20qCEIgAuazi9cwf1OiUOjYcbo+UbNbUsQwxiXymnV12lUaK5uOBew1wY7hv9+cBRs58ZwSGftm7hlot2PXwDqQsI4n8qE9RhbDogimhXqBg7qBxIBTxlPimNIFgmMAzSlz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NaMgenbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NaMgenbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C333EC4CEEA;
	Mon, 23 Jun 2025 21:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714067;
	bh=H7wMhU1U96Z+AW0stYIeRuy/q347GKnX5vB8THidO44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NaMgenbwfNxQhPQ429KSDRGUS7FAbGXVtk/UfVpLAqw2A3XRies7L3RsQRLiAIjsi
	 A3Py/UlMxiJNYMIipUHvLDcuTZPBb3NAmjaZvoAllsPA9E7A++QR+mC2QkF7Wpa9MV
	 hWIj8l7uBVx/e7iII35edsvhVOq77chj4C0dYBsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/411] fs/filesystems: Fix potential unsigned integer underflow in fs_name()
Date: Mon, 23 Jun 2025 15:05:07 +0200
Message-ID: <20250623130637.755801712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 1363c134ade81e425873b410566e957fecebb261 ]

fs_name() has @index as unsigned int, so there is underflow risk for
operation '@index--'.

Fix by breaking the for loop when '@index == 0' which is also more proper
than '@index <= 0' for unsigned integer comparison.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/20250410-fix_fs-v1-1-7c14ccc8ebaa@quicinc.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/filesystems.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 58b9067b2391c..95e5256821a53 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -156,15 +156,19 @@ static int fs_index(const char __user * __name)
 static int fs_name(unsigned int index, char __user * buf)
 {
 	struct file_system_type * tmp;
-	int len, res;
+	int len, res = -EINVAL;
 
 	read_lock(&file_systems_lock);
-	for (tmp = file_systems; tmp; tmp = tmp->next, index--)
-		if (index <= 0 && try_module_get(tmp->owner))
+	for (tmp = file_systems; tmp; tmp = tmp->next, index--) {
+		if (index == 0) {
+			if (try_module_get(tmp->owner))
+				res = 0;
 			break;
+		}
+	}
 	read_unlock(&file_systems_lock);
-	if (!tmp)
-		return -EINVAL;
+	if (res)
+		return res;
 
 	/* OK, we got the reference, so we can safely block */
 	len = strlen(tmp->name) + 1;
-- 
2.39.5



