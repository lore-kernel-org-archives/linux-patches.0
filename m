Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6079E1E3DCF;
	Tue,  3 Dec 2024 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241606; cv=none; b=JWbtHWqUG0z8Rf9BGg5lmiAHDgS/VLfrMpy6B+ycfjs7qBP1y5Q84PHQLyxxweu8L1g2lA6oIFnlt5i2YqWm1b5Ip2Ph5iHHtoxRPS8q3uWdllveGpBjY0jlgVl/5NtMvsqV8NtaYt5cKAmC7qvbuyd6D0stP+1XN0MpouXkZ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241606; c=relaxed/simple;
	bh=9jk1uSyfU/dl0qZIKF9u8U3P0EwWhWzo2P+ZYnruvEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBU2txJ9lQEgGCx4qap2Kpa1oHOL2bTKdTeLaAmmiQiBwVnMIguG3WWCH6rFxn6SRvXfUdBeoEtWpFiZYQG/tyey5B0N+6OeCpHlnAH6eQV+ktzHiTCQsQbU6KMLnsl6HD80HgxSlrR5X8nr90UckCQeqgprfq8yqr2DWaCDBq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZYfBj1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZYfBj1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9A3C4CED8;
	Tue,  3 Dec 2024 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241606;
	bh=9jk1uSyfU/dl0qZIKF9u8U3P0EwWhWzo2P+ZYnruvEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZYfBj1O3MKzuJCi04JFRSw5rvB2nRTkRxr7fCf8WPkpe8r5dKPjQpVqjmvqomTH4
	 K6GX/G56DeYS35+SPybkJMyecqNlvYzOzEypjt1syLstyGjiRPRy/Wf7/5BwMMFPqq
	 53Hc9JVnwOfomTaIUAU2Gqzk0EE30sM1m3NywdWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 465/826] x86: fix off-by-one in access_ok()
Date: Tue,  3 Dec 2024 15:43:12 +0100
Message-ID: <20241203144801.903218794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 573f45a9f9a47fed4c7957609689b772121b33d7 ]

When the size isn't a small constant, __access_ok() will call
valid_user_address() with the address after the last byte of the user
buffer.

It is valid for a buffer to end with the last valid user address so
valid_user_address() must allow accesses to the base of the guard page.

[ This introduces an off-by-one in the other direction for the plain
  non-sized accesses, but since we have that guard region that is a
  whole page, those checks "allowing" accesses to that guard region
  don't really matter. The access will fault anyway, whether to the
  guard page or if the address has been masked to all ones - Linus ]

Fixes: 86e6b1547b3d0 ("x86: fix user address masking non-canonical speculation issue")
Signed-off-by: David Laight <david.laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f43bb974fc66d..b17bcf9b67eed 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2392,12 +2392,12 @@ void __init arch_cpu_finalize_init(void)
 	alternative_instructions();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
-		unsigned long USER_PTR_MAX = TASK_SIZE_MAX-1;
+		unsigned long USER_PTR_MAX = TASK_SIZE_MAX;
 
 		/*
 		 * Enable this when LAM is gated on LASS support
 		if (cpu_feature_enabled(X86_FEATURE_LAM))
-			USER_PTR_MAX = (1ul << 63) - PAGE_SIZE - 1;
+			USER_PTR_MAX = (1ul << 63) - PAGE_SIZE;
 		 */
 		runtime_const_init(ptr, USER_PTR_MAX);
 
-- 
2.43.0



