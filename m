Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82D01BC4E;
	Mon, 27 Oct 2025 19:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593113; cv=none; b=GR2lH7MTJ+zTuZDx5AnQKuHNfQZu6Py3KoDlWXaJgGlzu8mq3FMxM60p2ZoJCC87mYK6o010+jO6UaaWugvsEMuzrABi/MFamm0XnZTyeSmnvcslZBWuIRc8ujyVDm99vu9PQsnNYEzv77r6NQSUSXl0sYpSzOP4tY0+tlCywHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593113; c=relaxed/simple;
	bh=UFji515DdRn7XtDgMWKDitQbmqJ6wgquUnXhiFHU/AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVwJL4xt69X0lH/P9Gqg+KvMLaisypB8gH2kWaWWMa+r2AwLqJqUgP28ZZrZsak8HI6bj9fdf5zT3h5942RV4PonKb/qhm/+OqY2bpzHgRCqcK8uQ3MpKTCzZKH8VzwBOHunfRBmhnRg8gzFg4Ng7NQyNrAkuhhqKMuxCfeKPzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMU2XV6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMU2XV6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7961CC4CEF1;
	Mon, 27 Oct 2025 19:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593112;
	bh=UFji515DdRn7XtDgMWKDitQbmqJ6wgquUnXhiFHU/AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMU2XV6aeWhyy3Adg5vne7IRPUvoG/3NyDJ8rnH0f/nKozcuoA4N6HFAYp57aN2kz
	 6pPRTT35ddr9tFQS1Jb4eA1J0naN0/yCVWLSTJ8ruBQoy19rXtIH/sz2AyvypS0/R9
	 K530v3cVRtnAfUuShe7IviMAqE0etn6QPAVdzE0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 018/184] lkdtm: fortify: Fix potential NULL dereference on kmalloc failure
Date: Mon, 27 Oct 2025 19:35:00 +0100
Message-ID: <20251027183515.424436909@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit 01c7344e21c2140e72282d9d16d79a61f840fc20 ]

Add missing NULL pointer checks after kmalloc() calls in
lkdtm_FORTIFY_STR_MEMBER() and lkdtm_FORTIFY_MEM_MEMBER() functions.

Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://lore.kernel.org/r/20250814060605.5264-1-junjie.cao@intel.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/fortify.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/lkdtm/fortify.c b/drivers/misc/lkdtm/fortify.c
index 0159276656780..00ed2147113e6 100644
--- a/drivers/misc/lkdtm/fortify.c
+++ b/drivers/misc/lkdtm/fortify.c
@@ -44,6 +44,9 @@ static void lkdtm_FORTIFY_STR_MEMBER(void)
 	char *src;
 
 	src = kmalloc(size, GFP_KERNEL);
+	if (!src)
+		return;
+
 	strscpy(src, "over ten bytes", size);
 	size = strlen(src) + 1;
 
@@ -109,6 +112,9 @@ static void lkdtm_FORTIFY_MEM_MEMBER(void)
 	char *src;
 
 	src = kmalloc(size, GFP_KERNEL);
+	if (!src)
+		return;
+
 	strscpy(src, "over ten bytes", size);
 	size = strlen(src) + 1;
 
-- 
2.51.0



