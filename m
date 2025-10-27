Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68DB31CA7E;
	Mon, 27 Oct 2025 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592436; cv=none; b=jzM518/3BbGud2b2jAmXKuPc62SfX2sYNB8Q1kyv8SJPT+3gqfwnAC7Fty0umlA4FKvfDHMTCG26M0FWuy2/mgWGog6Nk+Kjyo2tE/ebkYlT3k8GyDZkFPsSi9y7FwZ0Vhpl3tNRbwZk3JULUucN5VhqoSxDKM1ct5zIG53ZGew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592436; c=relaxed/simple;
	bh=zFOWTEwyZO8OWFGbTwrQyK5zwimvJDcm1ae47yPRIaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4Cg4tzPutQTdY6kv+U6dZln7q9AybEB2NwsU0V5ha+5WZHZGvLOEeXwFA9UR5PUO2GahneITaoEeMAmICjy1SrlX7lNqUDJvRfNwKO0DsqpDpCJL1bMSIwPLuCpM26TkFhR1DZuw1sCMhCyHLLCfp2tIKfwiEQHuCGJ1tRBEvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjMABqlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjMABqlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66286C113D0;
	Mon, 27 Oct 2025 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592436;
	bh=zFOWTEwyZO8OWFGbTwrQyK5zwimvJDcm1ae47yPRIaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjMABqlgWO85sO1XHT6wafEHZvBrdMbW1nx9o/yOOBnu/IeqU3lyq5QBmQhrgIt3M
	 /W4CL3rIigDhQ11/xolpxhrlKWB8F6EESGloq/y/wrRhQyW0grJno8HxCYc0mZS9zV
	 uTj8ApTpsfNcPUixl+yx/DwLqjRjdkVDRWql7IPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/157] lkdtm: fortify: Fix potential NULL dereference on kmalloc failure
Date: Mon, 27 Oct 2025 19:35:38 +0100
Message-ID: <20251027183503.342771568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



