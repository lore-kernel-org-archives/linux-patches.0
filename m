Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1342146F4A3;
	Tue, 21 Jul 2026 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661541; cv=none; b=MVvQrp7RqpR5mujCv+UO1agbatoHlka8o/p0xsXcz5eFHMQxmZdCXtH/iOa5idaRw1fSoluS+VNUzFLJr0m3K5aJIT/CDO8u3/olAMQhdQHFjaGSPdGdaUlRViArKi/X/cyvMTTFlaibMEZXxwPMEOZu9O1SrQVZyoObobXpPa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661541; c=relaxed/simple;
	bh=PPFjGbv3RXPB8hP6KEUAFZmN8kZe0oTWWM/K4WBLdjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWVIPbjzGvecrKdwaa1qLg/m9oUn9PTNyezV64TKzcv7SxB6oEruULZPCe1GCvP0TapXbWG235ffxzetuVbncfH7ioF8IaMb4SJLvhG9j/2Tmr6RddGU9MK5WtoLXVAvU9Hbp/YKS8mPummFXI5F3bO10G8QkadUYo1GXOrIgeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIfZ90Ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIfZ90Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6E91F000E9;
	Tue, 21 Jul 2026 19:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661539;
	bh=m4QxPpESIYf/BVXRhG+W9hbdLj3ppMP/Y1aW26YFCCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIfZ90Kayo8/fKkmnTVDj1jvM/9O4FkXLrNA3VQDe8hTNLj4z7ZSMfoe0YIEo7cid
	 5DdTd1UzDadHtPUNeNrGVRv1gXCdoaLaUvq9/diCLINj3sEU+cDzwTgdY/vhgPYio9
	 jQD7YXLbjzAfHdE0tcWLrYLKrviKANGTZXNTduA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiu Che Yu <yu.whisper.personal@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0106/1276] rust: alloc: fix `Vec::extend_with` SAFETY comment
Date: Tue, 21 Jul 2026 17:09:09 +0200
Message-ID: <20260721152448.470380114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Hsiu Che Yu <yu.whisper.personal@gmail.com>

[ Upstream commit f497aae6ded43f91b1dbf29a35d7062823635640 ]

Fix an incorrect operator in the SAFETY comment, changing `<` to `<=`,
since `Vec::reserve` guarantees capacity for exactly n additional elements,
so the equal case should be included.

Signed-off-by: Hsiu Che Yu <yu.whisper.personal@gmail.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Fixes: 2aac4cd7dae3d ("rust: alloc: implement kernel `Vec` type")
Link: https://patch.msgid.link/18fc8eee2f057a6bfbcadae156d1d0b7c40d0077.1777111268.git.yu.whisper.personal@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/kvec.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index f62204fe563f58..28dc9ee02cb07f 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -479,7 +479,7 @@ impl<T: Clone, A: Allocator> Vec<T, A> {
         spare[n - 1].write(value);
 
         // SAFETY:
-        // - `self.len() + n < self.capacity()` due to the call to reserve above,
+        // - `self.len() + n <= self.capacity()` due to the call to reserve above,
         // - the loop and the line above initialized the next `n` elements.
         unsafe { self.set_len(self.len() + n) };
 
-- 
2.53.0



