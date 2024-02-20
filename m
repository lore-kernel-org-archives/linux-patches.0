Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE6C612D7;
	Tue, 20 Feb 2024 21:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463457; cv=none; b=XEWHYe1EvQH3pUimfC2kqEezPlsqksVqzLGeUl0j0sQVfH8W+gMQkMdrHkl5MfpDYgh8NViJk6sCP/39rRYGvIZ1u7PQgu75nHGOXrPIAmsrXdZay6+NunHDzlI/qXu70GmFIfK3jh7Z7yYGJjEvOAEiXWJcEJWYlzWlO8QO5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463457; c=relaxed/simple;
	bh=Do0e5y9DnPUEvZfrSuP7RTRyvHX3+IePGgvaLUc2rJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=if4TJthqhrGCrSGpKE63YepCMy01kjnYTHj03PmTV48uOBakZrJTPf60QuV0PBSLLLRAzqzpwf6YupvgI7WvgkTg4Grd60GpgpCosaXcnrRJIsrogIOYr1kj2rSeWJCAS9tIxeiFo0IDJD+sbHUyhBRCVgWzRv2qG2VvZucfWB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnCb9Rou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnCb9Rou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49C8C433F1;
	Tue, 20 Feb 2024 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463457;
	bh=Do0e5y9DnPUEvZfrSuP7RTRyvHX3+IePGgvaLUc2rJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnCb9Rouj9yfyVpv8kx4657Hngm4Gbluatwzy/w7uXnk+KEF0WC7Y3tzHgNPxEN5u
	 YZv7lhxQWGzAdlwW5vndaORKipAcIGINYDFIKfPGhFmcD91XICnSWrUWjIaqWrVQOd
	 rzWHtQ44Av2311cmCy0K1E9XczP/BBVwjwNDhjv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/331] nouveau/svm: fix kvcalloc() argument order
Date: Tue, 20 Feb 2024 21:52:45 +0100
Message-ID: <20240220205639.137450910@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 186351ecf72f..ec9f307370fa 100644
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



