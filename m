Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EE9235061;
	Mon,  2 Jun 2025 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872979; cv=none; b=nPSP26f6h5V5TLqVL5jg0Oy+6TTDpGnkQzFJzHaNEkc78ptQlWm6WTvY9wMtpD12QQJjNf55bjZU2ld3TTUTrvhPmOiYOWgVsHAYuhWkChukpReA+az1e5/pzQnhCo/XJ+lWQ4z6nVGIEvpY7HX17K/8nxWG9pzUAqrxILPMSlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872979; c=relaxed/simple;
	bh=yGEXisPko5+PnaMR00b3V66jFaHp6TT57hwnxVU1d2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiOQgMQzIaCjHldJphbD/yqnZLhw/IWrcAn9KmGyR0FG/mjuPi5DHRlWIv6yGYZdVvYrne/RWpGlvmVwouV2a0Uz15v0HP2uQGjsTb8o7qsh9o/UcPfudQU3tE4ROR0x11/FwDcJ4xrrJn/SEKHvvtVX03dGmT5cemZL4toX1WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN9eCoLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN9eCoLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE918C4CEEE;
	Mon,  2 Jun 2025 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872979;
	bh=yGEXisPko5+PnaMR00b3V66jFaHp6TT57hwnxVU1d2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EN9eCoLOOASTghk80KFkjkbkG1ZnucjAdHneQLabcNFQ/Oi+GqkP+8OUmsA7Gsebq
	 dlfu8e25pukv2M5abPflP17RiTBjrK48xGpnBXPVYmZTywYebsreRT2rSZ9XhvAEa1
	 4b/xGmQlr0SJlxp7zFCMFkSpUoBy9mg0wactKXUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 55/55] ksmbd: use list_first_entry_or_null for opinfo_get_list()
Date: Mon,  2 Jun 2025 15:48:12 +0200
Message-ID: <20250602134240.441210028@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 10379171f346e6f61d30d9949500a8de4336444a ]

The list_first_entry() macro never returns NULL.  If the list is
empty then it returns an invalid pointer.  Use list_first_entry_or_null()
to check if the list is empty.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 03f606afad93a..d7a8a580d0136 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -146,12 +146,9 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 {
 	struct oplock_info *opinfo;
 
-	if (list_empty(&ci->m_op_list))
-		return NULL;
-
 	down_read(&ci->m_lock);
-	opinfo = list_first_entry(&ci->m_op_list, struct oplock_info,
-					op_entry);
+	opinfo = list_first_entry_or_null(&ci->m_op_list, struct oplock_info,
+					  op_entry);
 	if (opinfo) {
 		if (opinfo->conn == NULL ||
 		    !atomic_inc_not_zero(&opinfo->refcount))
-- 
2.39.5



