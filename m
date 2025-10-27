Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DC22BE037;
	Mon, 27 Oct 2025 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592787; cv=none; b=lLgyB/YcsroC0fvNWVImZJ4xQBNBwNBAoY1BnjMa1HMITF/T0ebaB47SbC0sXA7EvtF9/pgUDjTQbVXX2UG9nHRHD5qvn0S2GtSG+8vPkcS7wEnfmIC1cQB8dN5jITkYFzYpdejWklIyQipa0w9rpiKuuHbViJcwS2JeXiND7Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592787; c=relaxed/simple;
	bh=tc0IEoVlYrwApb6RskkaC1pEf6Byz5fTmfb9aYb+oqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2jrXdRITqZ2wM/43DsjZFaqVpNpGHdwDX21yVF4A6AjgMJodOn9YlGVngZ7uMOo2Aev+4LnB72KDqOhKOF3fts0pp6W3P3GcrgZu0cbpTHqdWAo2hLYFptEYCO+xsu8O885nDkZzZZTfICyZvN33RGWebZWkh9VZ5xg4SGL02w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPkKBGlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPkKBGlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2021FC4CEF1;
	Mon, 27 Oct 2025 19:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592787;
	bh=tc0IEoVlYrwApb6RskkaC1pEf6Byz5fTmfb9aYb+oqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPkKBGltYYX8Hkjbw88jrW24nXyok64L8A9FCVuplVRi9YEDxOb3xvsqNV5OHasSV
	 oZtw2dbs/akgg+YPlQ1lIVy5rFuuhZAvzbFFMjFxs+nsgjTWicrVcizTms9KmEonaK
	 ocuV9H9eVJnyrTL3cLFzKP931GKLm8cBDkh9jbKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/117] lkdtm: fortify: Fix potential NULL dereference on kmalloc failure
Date: Mon, 27 Oct 2025 19:35:38 +0100
Message-ID: <20251027183454.273194172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



