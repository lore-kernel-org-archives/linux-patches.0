Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5EF151CCD;
	Tue, 20 Feb 2024 20:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462769; cv=none; b=fPjA/68ne62l523J4HRgOoYW0kuTFIkyHBHr5ibTAM4Ya6IzLb2ehmiWFad3kVqQy3kPWliQnW/ORHvL0uITB0O0fVxpn3brUwc1GsxgrrE7guLeoL68v44FMz632YIBMs74MEROCKQh7QNJPcLdwv+fMMYxeyH8Q+/t4YQEHio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462769; c=relaxed/simple;
	bh=q/3fQOA0VqG+2kxqfWTxXy781zwVeRlsrzHz/KMpZYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHxBdqj6E+ilam+8gjwYWXQ8szkcAbrMFfKvvtWegen/yoBGc60ZrI0cY9jeP5m2/J4uFFFZQBHEplaeetAY/WNzw4SnoeBxr0SygHvEez9qTfLwwzfRCUdQFAwyGNLx1HDPKts+83XtKbj1QRGdknWciojHvV9kDWUYQ1PLPTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDNNmm7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDNNmm7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BC6C43394;
	Tue, 20 Feb 2024 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462768;
	bh=q/3fQOA0VqG+2kxqfWTxXy781zwVeRlsrzHz/KMpZYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDNNmm7zrwGMJebRthb0v9WOb82YuOEUaVdT3C7umgez/55LVkdprJCNurvTjVauQ
	 meeMZdR89+FdKfmSlnVJtHMgBdGP7Q/iYCN5ymO9oI3fLsofG6uH8HVmZc6yjU/QGA
	 mFLy2tuo1UkxTrVjbX0hyK4FcZQveO7y/lSY/dhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/197] nouveau/svm: fix kvcalloc() argument order
Date: Tue, 20 Feb 2024 21:49:49 +0100
Message-ID: <20240220204841.982517021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31a5b81ee9fc..be6674fb1af7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -997,7 +997,7 @@ nouveau_svm_fault_buffer_ctor(struct nouveau_svm *svm, s32 oclass, int id)
 	if (ret)
 		return ret;
 
-	buffer->fault = kvcalloc(sizeof(*buffer->fault), buffer->entries, GFP_KERNEL);
+	buffer->fault = kvcalloc(buffer->entries, sizeof(*buffer->fault), GFP_KERNEL);
 	if (!buffer->fault)
 		return -ENOMEM;
 
-- 
2.43.0



