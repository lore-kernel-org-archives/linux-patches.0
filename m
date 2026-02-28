Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FDE371460;
	Sat, 28 Feb 2026 17:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301464; cv=none; b=ZqqPI8lnAFNfGpi1gzU3PSrbkVzOOM0VRC6APCQbx8999MZD1IpCn2NpyYMFxVynmOzZfNTvA4/HZadO0Myvzww31D4H89JcFbQtu+bcm8eA9zPsXFCwH71jE2RAkqfkT9hvsdKwpb9nk8s2Bdz1FDsCz79KBtztzpLrQgcuGng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301464; c=relaxed/simple;
	bh=Zeq8st5I0cgj8mYEdEdDCix/cXMYj7QqLZ18R1YqXKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckOFkbDoUvuQqU8CubbHlRfUQkehDXLe7vgPLOo8qXxOLWNO2n9cgBwYJ1K1IYNjVhaeIwJTC4KUezaVYrwlOzYXjmeKsTXLjWfXDscZt2/K5r7kXs1U8z1nq54DW4s47QMhxIZEUn4Q5ykSWahm/+xU3n92GQZpqRpYT0XA1Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3qMn1bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3qMn1bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE2EC116D0;
	Sat, 28 Feb 2026 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301464;
	bh=Zeq8st5I0cgj8mYEdEdDCix/cXMYj7QqLZ18R1YqXKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3qMn1bkqUqtRADEBeiYAoLUhWTvCALGYZMUKZI7X7iKokgG/W+WPWQM7rlgeKa5R
	 8im7XNy0OzhgcHANrd6KeAwyQWLtowF4d/8EjuG/Y8QpWVph0bP3YwFlAJ6XcUoepv
	 x2P41EqCMwPrrGVmpm8loqCqxfFs09Do5OhyyvHR3CRq1xnr4PXngMEhqvdHgb/eCf
	 KkylF0wOoZj83uV4LDGbQvyTxO6l6RZ3ngev5rpr8J2V7qeTtZUgENG7rgvON2FlgT
	 ftEl7iTFqUZmw3EX6OWn4IOETqb17F7PwVO8HhezXcmIrshIHqD0loEc4WDzg023uQ
	 EMgEPXhuznQPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Marco Elver <elver@google.com>,
	stable@vger.kernel.org,
	Boqun Feng <boqun@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 649/752] arm64: Fix non-atomic __READ_ONCE() with CONFIG_LTO=y
Date: Sat, 28 Feb 2026 12:46:00 -0500
Message-ID: <20260228174750.1542406-649-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Marco Elver <elver@google.com>

[ Upstream commit bb0c99e08ab9aa6d04b40cb63c72db9950d51749 ]

The implementation of __READ_ONCE() under CONFIG_LTO=y incorrectly
qualified the fallback "once" access for types larger than 8 bytes,
which are not atomic but should still happen "once" and suppress common
compiler optimizations.

The cast `volatile typeof(__x)` applied the volatile qualifier to the
pointer type itself rather than the pointee. This created a volatile
pointer to a non-volatile type, which violated __READ_ONCE() semantics.

Fix this by casting to `volatile typeof(*__x) *`.

With a defconfig + LTO + debug options build, we see the following
functions to be affected:

	xen_manage_runstate_time (884 -> 944 bytes)
	xen_steal_clock (248 -> 340 bytes)
	  ^-- use __READ_ONCE() to load vcpu_runstate_info structs

Fixes: e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire when CONFIG_LTO=y")
Cc: stable@vger.kernel.org
Reviewed-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Marco Elver <elver@google.com>
Tested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/rwonce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rwonce.h b/arch/arm64/include/asm/rwonce.h
index 97d9256d33c97..ac370a4a01ee9 100644
--- a/arch/arm64/include/asm/rwonce.h
+++ b/arch/arm64/include/asm/rwonce.h
@@ -58,7 +58,7 @@
 	default:							\
 		atomic = 0;						\
 	}								\
-	atomic ? (typeof(*__x))__u.__val : (*(volatile typeof(__x))__x);\
+	atomic ? (typeof(*__x))__u.__val : (*(volatile typeof(*__x) *)__x);\
 })
 
 #endif	/* !BUILD_VDSO */
-- 
2.51.0

