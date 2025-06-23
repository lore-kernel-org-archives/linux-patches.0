Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD2A7482;
	Mon, 23 Jun 2025 21:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713351; cv=none; b=o3eHn8+oIq1H3IZYeoJ9FNG9y7O0AodV92oLM7obHJFwWE/r4+R+vuYh8NjtTtd+XYc7ZQsC/2qrbs22jb6vqtLebrE8M/LAAqrKANBHen3daROnrOa9xdhRrt6NiU3Gj9IiN1P37b1p0BOFXvSrcsyHLZJX1bABftoRinX3sN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713351; c=relaxed/simple;
	bh=lFFEEzl54Iueq9jfyKRRs9/1X6Xpc5BikOJjFNeP3NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMnSNwQepzPJf+g80Hh1aBVM5rlIrUXRlzkZKqtloZB34Vlef7//gtrjsKTGXycHIxply/YLM/YW25u1cc27Xod6kNgIgghVGX90xhH/t3ppn7oj3pYD961YfuJEI22NPBYYJAfp7kwBqbUP7ow9S+CiMV0wK8WCcl3ZQdG0eCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5f04ZwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5f04ZwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96D7C4CEEA;
	Mon, 23 Jun 2025 21:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713351;
	bh=lFFEEzl54Iueq9jfyKRRs9/1X6Xpc5BikOJjFNeP3NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5f04ZwGl5IcE5F7B8Z/VHQYmWVWBSV5JAGHCFOhk9T1eGkj/ot9ggg9ouCAJJ67+
	 U8MDITSbkYVSQkKNjG/Yl0fSBzJFt4Rz8vYLlvsO4h9MK3vydUGiUzdVBxcP95pQOV
	 +G6+V159d8hiBN7t6UHmCemO3hJsO7231DrEMHCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/355] fs/filesystems: Fix potential unsigned integer underflow in fs_name()
Date: Mon, 23 Jun 2025 15:05:40 +0200
Message-ID: <20250623130630.901255938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 90b8d879fbaf3..1ab8eb5edf28e 100644
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



