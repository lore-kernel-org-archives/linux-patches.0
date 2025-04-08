Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5531263C6D;
	Tue,  8 Apr 2025 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110605; cv=none; b=agui1GY85/jmU+ya+zs/3vCRUPac53I61I++IyoY5h7B5mjwjBVsDlm9pBAmmgCNByht4RyPzP2eWVrIwvlOKvZ2/tzt2XYNaZP5ekUYolrPYf2qwWBxJwaPcwBI0cYvK56Hwv7lM8Ef6xFZEzDv8qQp1bXI1KthhFKcltK+XSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110605; c=relaxed/simple;
	bh=xmJfekEDyxy4HoXyyJqfYHw8tnB9+pCd8s0B8VQm6AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7vG/dHt3VXBdSlKqmcwHPAokuvYu3+77NStIFhWHnGh9voAs70Eg7onLYI7IMsEKdg7Txf8AlUm7Ulp5/V4c53GFauY5mqblLrdwptVLjOSZzWGUkPqiDX6A5X3CrJd483uhAKGL4UZE527VJYMgjyd2F92rxvKpdkQLrQv4u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8R2Z88+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8R2Z88+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAC8C4CEE5;
	Tue,  8 Apr 2025 11:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110605;
	bh=xmJfekEDyxy4HoXyyJqfYHw8tnB9+pCd8s0B8VQm6AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8R2Z88+nHPW4wjP9EdLUFOtQ31CuqeiSJ2EFiNvdhEn07gF7AKOePjUYxk2QkNAv
	 dy4aE2zOqDiWW0Lc8U2OTn/3mwRpAExZxodCMmxyuOaXCsGUi0ouy1xpUzGOihl9BC
	 IXkviANI979qCmM+ncQ9azcEpNhTYDpb00Jg0OD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 087/731] dlm: prevent NPD when writing a positive value to event_done
Date: Tue,  8 Apr 2025 12:39:44 +0200
Message-ID: <20250408104916.293009611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 8e2bad543eca5c25cd02cbc63d72557934d45f13 ]

do_uevent returns the value written to event_done. In case it is a
positive value, new_lockspace would undo all the work, and lockspace
would not be set. __dlm_new_lockspace, however, would treat that
positive value as a success due to commit 8511a2728ab8 ("dlm: fix use
count with multiple joins").

Down the line, device_create_lockspace would pass that NULL lockspace to
dlm_find_lockspace_local, leading to a NULL pointer dereference.

Treating such positive values as successes prevents the problem. Given
this has been broken for so long, this is unlikely to break userspace
expectations.

Fixes: 8511a2728ab8 ("dlm: fix use count with multiple joins")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 8afac6e2dff00..1929327ffbe1c 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -576,7 +576,7 @@ static int new_lockspace(const char *name, const char *cluster,
 	   lockspace to start running (via sysfs) in dlm_ls_start(). */
 
 	error = do_uevent(ls, 1);
-	if (error)
+	if (error < 0)
 		goto out_recoverd;
 
 	/* wait until recovery is successful or failed */
-- 
2.39.5



