Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1030E84D;
	Mon, 23 Jun 2025 13:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685706; cv=none; b=PCs2Fp0mQpOkp0FiEw6tXV2aFwbcUe8q+90kNwdpuUQfyZSNslHhKP2jwGvAJHwG7SHoAPzBzV8Jk0Ho24v+IyDe7q4A0C0UPNjVnmn5dBgAjtq+EE4+YptmZB/lHvewBsaqZOJ7xM2uwhGfCUuKRXJICa3D4AZ7qPWlVFL0MQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685706; c=relaxed/simple;
	bh=jBU4ObT3cerIaka4g4gJgz59uaOkSOEiNyRHxDbj9fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW3taUXP0yhfgL9XBtaQXAERa7MG8yb6H1EB0V8cRuaEu1Qwni0VZyEXSzSJr5zqF2Aahuiyrx2dt83s+P901OjnhmhOoUqLQUFrIkG6Cwk9Egng1VzcDaYBxWPNS+YJOEILNqIH/XT9SK5iX0XwwSDnGIc0rDcfLUh+jSSzvHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcuFsGIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcuFsGIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9226DC4CEEA;
	Mon, 23 Jun 2025 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685705;
	bh=jBU4ObT3cerIaka4g4gJgz59uaOkSOEiNyRHxDbj9fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcuFsGIlVBBvQ4BakA9S8WgETGAikOEoZ1zUWDyYMVJMmOJZ69mu49CNude/PwnhK
	 w1J0pcnmVFt+Xwxngq4wW1c0lbs7bR622crvqaYNMuTKgWMExHMW/KfkC8k789cm+j
	 MHbtA8lWgSkNBQH9QZ+B1VlWRV4C2yz5kPtCE8RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/222] fs/filesystems: Fix potential unsigned integer underflow in fs_name()
Date: Mon, 23 Jun 2025 15:07:12 +0200
Message-ID: <20250623130615.025290070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 fs/filesystems.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -155,15 +155,19 @@ static int fs_index(const char __user *
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


