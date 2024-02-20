Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4127152DE8;
	Tue, 20 Feb 2024 21:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464544; cv=none; b=Z3Ecm37EwrrwoALCYW1YCmZMObvIzZGZBZ7JbGMsQ3M/9arKyr8RkyBNbZe5AUBwZ/Yz6bYIhjJ58ekht16ZYSzXgRWdnDvvKcU4ngohdKcPE7PzMbyA0G1nwVMs+G4qbtV3r2EOhfHXeK/hRJYhcJ7Yxok4WXNA4IlE8TWz1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464544; c=relaxed/simple;
	bh=pJjeckggueP3kLDdf6wt7Wb3IUt1wML8GR4P/S1UvXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRGTOUiu/SyJ2Glf5SJ7L8dNeWy776PKvDnw10cBH/ox5aIh7DBn2v0nG+knLivFCWeFiyJxvw7KRE1XHuYrETjRGzvAJjkURbci52r3DZexWiDTwbug4GK92lD2dk7ZcEdxSLEe84SLDS7gQLnlxDcLYn48hF1rfXyfWHwSd5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdR6J6KJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdR6J6KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CA9C433C7;
	Tue, 20 Feb 2024 21:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464544;
	bh=pJjeckggueP3kLDdf6wt7Wb3IUt1wML8GR4P/S1UvXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdR6J6KJwhnMUqphtU2+WR9FD6zvBO6xymwj9yR7KeGL/PP9Sv05yC6k6Ve+BTULU
	 bkvDvAoyZhUrY8CrosDhvbqNOtLp79b8BjmODpRVv8c2aVXLHLS+cd7HI3NLudLWWr
	 gUuMOd4q4zLhnThBJzshqVw/gE8fWesslyrf40MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 057/309] nouveau/svm: fix kvcalloc() argument order
Date: Tue, 20 Feb 2024 21:53:36 +0100
Message-ID: <20240220205635.000882377@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2c80a2b715df75881359d07dbaacff8ad411f40e ]

The conversion to kvcalloc() mixed up the object size and count
arguments, causing a warning:

drivers/gpu/drm/nouveau/nouveau_svm.c: In function 'nouveau_svm_fault_buffer_ctor':
drivers/gpu/drm/nouveau/nouveau_svm.c:1010:40: error: 'kvcalloc' sizes specified with 'sizeof' in the earlier argument and not in the later argument [-Werror=calloc-transposed-args]
 1010 |         buffer->fault = kvcalloc(sizeof(*buffer->fault), buffer->entries, GFP_KERNEL);
      |                                        ^
drivers/gpu/drm/nouveau/nouveau_svm.c:1010:40: note: earlier argument should specify number of elements, later size of each element

The behavior is still correct aside from the warning, but fixing it avoids
the warnings and can help the compiler track the individual objects better.

Fixes: 71e4bbca070e ("nouveau/svm: Use kvcalloc() instead of kvzalloc()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240212112230.1117284-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index cc03e0c22ff3..5e4565c5011a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -1011,7 +1011,7 @@ nouveau_svm_fault_buffer_ctor(struct nouveau_svm *svm, s32 oclass, int id)
 	if (ret)
 		return ret;
 
-	buffer->fault = kvcalloc(sizeof(*buffer->fault), buffer->entries, GFP_KERNEL);
+	buffer->fault = kvcalloc(buffer->entries, sizeof(*buffer->fault), GFP_KERNEL);
 	if (!buffer->fault)
 		return -ENOMEM;
 
-- 
2.43.0



