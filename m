Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B80126FD9B;
	Mon, 29 Dec 2025 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025178; cv=none; b=vFvjw+sJHw8tXsqCP1MBKhDqabKXp16SXQpiNotuwZVc6o2AN2eRV4ljVyL0oSW479Fb8bvqfVbBG8yRdfS9+IODCbKYIBfcCVpgun4YyQoIvUrk1PX4VAc/Pfv186xRI44mnD1MWDB1Qv4PLtP3kkOzXbqqJtck5TnJ9L3uy44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025178; c=relaxed/simple;
	bh=YSRMIRB5NiIAPXTu5L4AVPpe0akpcw1NbmJ2HwOw9ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DL+AJ7gxiLmFbJqoMkrPHJhfQkWZbTe81S9LRszuYegYKY42QsfIf+BeiYEUH2UaEbE+bqb77ryeJFU451G1ON4ooaw2fVNhUR+TPH6bzvOgBJ6zG64HVqahIavwgIQj+VUCEoajde469y9piIZcyWGhultBX1oPy3xe98yf0Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqQ4FIJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqQ4FIJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79952C4CEF7;
	Mon, 29 Dec 2025 16:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025177;
	bh=YSRMIRB5NiIAPXTu5L4AVPpe0akpcw1NbmJ2HwOw9ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqQ4FIJgdLI5BsRCGLD/7ADe0JE6x102COry6lxJjTxcRR26BmZAkTduzggzZoUA/
	 41rn3rIC6qE3mMoVY0oVcF3BG6CkoO+tttBMN/GNVr0MpuKtnsCzkXX7g63/zUwVWd
	 eI8/SV60tONm7YTjHCVLetjixZDfltUZpq7jeryE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/430] drm/xe: fix drm_gpusvm_init() arguments
Date: Mon, 29 Dec 2025 17:08:43 +0100
Message-ID: <20251229160728.819107293@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9acc3295813b9b846791fd3eab0a78a3144af560 ]

The Xe driver fails to build when CONFIG_DRM_XE_GPUSVM is disabled
but CONFIG_DRM_GPUSVM is turned on, due to the clash of two commits:

In file included from drivers/gpu/drm/xe/xe_vm_madvise.c:8:
drivers/gpu/drm/xe/xe_svm.h: In function 'xe_svm_init':
include/linux/stddef.h:8:14: error: passing argument 5 of 'drm_gpusvm_init' makes integer from pointer without a cast [-Wint-conversion]
drivers/gpu/drm/xe/xe_svm.h:217:38: note: in expansion of macro 'NULL'
  217 |                                NULL, NULL, 0, 0, 0, NULL, NULL, 0);
      |                                      ^~~~
In file included from drivers/gpu/drm/xe/xe_bo_types.h:11,
                 from drivers/gpu/drm/xe/xe_bo.h:11,
                 from drivers/gpu/drm/xe/xe_vm_madvise.c:11:
include/drm/drm_gpusvm.h:254:35: note: expected 'long unsigned int' but argument is of type 'void *'
  254 |                     unsigned long mm_start, unsigned long mm_range,
      |                     ~~~~~~~~~~~~~~^~~~~~~~
In file included from drivers/gpu/drm/xe/xe_vm_madvise.c:14:
drivers/gpu/drm/xe/xe_svm.h:216:16: error: too many arguments to function 'drm_gpusvm_init'; expected 10, have 11
  216 |         return drm_gpusvm_init(&vm->svm.gpusvm, "Xe SVM (simple)", &vm->xe->drm,
      |                ^~~~~~~~~~~~~~~
  217 |                                NULL, NULL, 0, 0, 0, NULL, NULL, 0);
      |                                                                 ~
include/drm/drm_gpusvm.h:251:5: note: declared here

Adapt the caller to the new argument list by removing the extraneous
NULL argument.

Fixes: 9e9787414882 ("drm/xe/userptr: replace xe_hmm with gpusvm")
Fixes: 10aa5c806030 ("drm/gpusvm, drm/xe: Fix userptr to not allow device private pages")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20251204094704.1030933-1-arnd@kernel.org
(cherry picked from commit 29bce9c8b41d5c378263a927acb9a9074d0e7a0e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_svm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_svm.h b/drivers/gpu/drm/xe/xe_svm.h
index 0955d2ac8d74..fa757dd07954 100644
--- a/drivers/gpu/drm/xe/xe_svm.h
+++ b/drivers/gpu/drm/xe/xe_svm.h
@@ -214,7 +214,7 @@ int xe_svm_init(struct xe_vm *vm)
 {
 #if IS_ENABLED(CONFIG_DRM_GPUSVM)
 	return drm_gpusvm_init(&vm->svm.gpusvm, "Xe SVM (simple)", &vm->xe->drm,
-			       NULL, NULL, 0, 0, 0, NULL, NULL, 0);
+			       NULL, 0, 0, 0, NULL, NULL, 0);
 #else
 	return 0;
 #endif
-- 
2.51.0



