Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A34223316;
	Mon, 23 Jun 2025 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715792; cv=none; b=OdlyhmG5cLd41CGENzuOLr70aO4CvcuXPj1oX7OW5hpBfCvX2t1rxwiIKwYGHQ6oXG2LScrDf4RZ2Xh5ToU5e4IVuQZChA/TLdLgZkwiJhYaVTygmKEKaaAqPQGM12C8SAf3jVTiS9/M1w+ID6O08Lf8aqTUNThhIMRKIBYp+Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715792; c=relaxed/simple;
	bh=vxC2j17ATF4vODoDiWczFriEN0cgmoNQqA4Hen51yNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxtPZrBiRsBS/CqtKYX8mc6H4sD2SKTpuSMaZyKFoR6x3RjoXMyPWEfqynqJ7jbNJuiXaAjle7w1PfxJK744RZiUxXe7kChO9tdQwjtNOtPyWBzvgTjjh7Kp/1j/0mgGCtkADhw+TJpBsBf3WChbKDmQvAvf4ai1AhtiLrxvhmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yMY/Lua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yMY/Lua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E160C4CEED;
	Mon, 23 Jun 2025 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715792;
	bh=vxC2j17ATF4vODoDiWczFriEN0cgmoNQqA4Hen51yNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yMY/LuaohlT0HPlxkDN5lwjeGvLd/tAOe0DJ9BTyWgkEKbS+kbaIYwLgwm9Et+8A
	 XhiZa1/l5L6i0n3/HaSoDMBjtRzg/EDqlw28oN12R1GwAO491PNtHNVSFa3gDrygET
	 U9g8SwptD4PkzlH3232k/c2EuZL3a6pCz/4bTIzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/508] fs/filesystems: Fix potential unsigned integer underflow in fs_name()
Date: Mon, 23 Jun 2025 15:05:07 +0200
Message-ID: <20250623130651.693425759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



