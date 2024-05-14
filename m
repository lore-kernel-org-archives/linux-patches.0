Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA7C13C66F;
	Tue, 14 May 2024 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683170; cv=none; b=b2Ufy9UPgVljsckw0c92dPInTMkjupiv28aoB0TSR48tWvcvT0QNTC33vSaSQeOpnHRK0atbRmrdB1gQNqDoA0JTLRZ5DscoygixQANItAbYvvx/+wlX4QPKT/Ve3LDEaoXtSug4aULM1wI9WHxxrMGKkSXN3cBRF0sTCUs3WLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683170; c=relaxed/simple;
	bh=XFELwXrOds7ENaf0OsnW4RXGEfpI9QX3IgI83CdQyIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMLDdM/1xizjlfHV/whdejuh2YkoUyKgdTPyPb9WfUU5w9MFkeVgq3pnh0FU2vaUHcHRqUML9OcmPru1ls23BYuhwdWnFr1weg+uxCPvuMX0D/lxVrKaaVd+O142AiGNl49yvDc5e/opcYWOwUbZfXN+RFdIKVi27NO/URXGCrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McWxSjXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McWxSjXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A75C2BD10;
	Tue, 14 May 2024 10:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683170;
	bh=XFELwXrOds7ENaf0OsnW4RXGEfpI9QX3IgI83CdQyIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McWxSjXF9Nnq+VHcV2dfAhbhF8Hdl8+KqsryruUEJCS+SdeIhrvra1rXMVzwiUJOs
	 PNg1dqHDKa6ZHiLgV1GB2vIm3emQGn9SWUr5gxM8PibWohwhxmQafVZIbnGmjkSCaZ
	 Pm6k46MB89Tj9l/TOTEhOYSdml345Oax8C58n81A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 146/336] nouveau/gsp: Avoid addressing beyond end of rpc->entries
Date: Tue, 14 May 2024 12:15:50 +0200
Message-ID: <20240514101044.112807840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 838ae9f45c4e43b4633d8b0ad1fbedff9ecf177d ]

Using the end of rpc->entries[] for addressing runs into both compile-time
and run-time detection of accessing beyond the end of the array. Use the
base pointer instead, since was allocated with the additional bytes for
storing the strings. Avoids the following warning in future GCC releases
with support for __counted_by:

In function 'fortify_memcpy_chk',
    inlined from 'r535_gsp_rpc_set_registry' at ../drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c:1123:3:
../include/linux/fortify-string.h:553:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  553 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for this code:

	strings = (char *)&rpc->entries[NV_GSP_REG_NUM_ENTRIES];
	...
                memcpy(strings, r535_registry_entries[i].name, name_len);

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240330141159.work.063-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index a73a5b5897904..dcafbb2004ca2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1112,7 +1112,7 @@ r535_gsp_rpc_set_registry(struct nvkm_gsp *gsp)
 	rpc->numEntries = NV_GSP_REG_NUM_ENTRIES;
 
 	str_offset = offsetof(typeof(*rpc), entries[NV_GSP_REG_NUM_ENTRIES]);
-	strings = (char *)&rpc->entries[NV_GSP_REG_NUM_ENTRIES];
+	strings = (char *)rpc + str_offset;
 	for (i = 0; i < NV_GSP_REG_NUM_ENTRIES; i++) {
 		int name_len = strlen(r535_registry_entries[i].name) + 1;
 
-- 
2.43.0



