Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E2C17F4F6;
	Mon, 27 Oct 2025 19:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592563; cv=none; b=G4a7Ma0J7xE4AtBRTCNy0bU65V2ULzG3i5dFKYvyyTd5dqVwWblMVWKHWCghGYurugeRCOpYQ4rdNx13qVOp9NdWMisqciuxqprznGyYuSmiTaVmizQm3AOjQOINWUFdp2fs7dwlT890LdJ2mvi7pMViQ4g4yki1KiLNL0bY3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592563; c=relaxed/simple;
	bh=vRcrtNW7AFTn4rjCRqzz5Qa+f5Hy4FdLESONGlNolQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deGIMV9+Yl83mf92ZCYE5iC1nWgN3PRwvAl/+7ez/k84tSzXE0gJv7kvT8tJ44nBP/osgJlW0eBGoy4Lv77+6ZH/l+bovO95Xvx5BI/t6lnly42eLVfmm8AepcAgJ7sImOU+fLRviP9I4252npFGFfiPEZTg6UK0I1UkYG6wvlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BLh5yiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BLh5yiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79191C4CEF1;
	Mon, 27 Oct 2025 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592562;
	bh=vRcrtNW7AFTn4rjCRqzz5Qa+f5Hy4FdLESONGlNolQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BLh5yiyFLQ98dYy2YKBbu8kZCWqu8swPzvQRRoordkNncpY7azbNUK3vvdjY3ERk
	 H1+18X54RHAI83Rbnq9zlzE9xV+iT8AT1sRW8FIiExnFUzTnJk91A4pYe7ZjliJ67c
	 iDkqK6Y8RCrs0i4rxgR9E8Mxr0mPze3JVta5onfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 11/84] lkdtm: fortify: Fix potential NULL dereference on kmalloc failure
Date: Mon, 27 Oct 2025 19:36:00 +0100
Message-ID: <20251027183439.117276942@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



