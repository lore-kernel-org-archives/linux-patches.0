Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68216143870;
	Thu, 13 Jun 2024 11:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279026; cv=none; b=J4Mc/rro/gW4a77CKaduo8NYDgtefwDZoJC8NyMAjK+J9r1VuW0AzNKBu+XKwaR4v3xyrLs3AoExnI7QQwz21ODBcBISgtYV6klYmqspC4dNM2qYYGTHP832aPhqAlCL71upOYZYS8WWzX1i9NK8VVDY4xnogRoPzEUWxQVUpqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279026; c=relaxed/simple;
	bh=B0XxeoU2YrDrUVIh63hK7FuPSunOVqIcM9l5E0MbyRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ltt3XyIIBLdw4L4/9K4pge4a1ltesbsBgi+x8J1muhNV8nlq4q5dSr0MuEkxJsQsUQ6AUjrPA1niac4YLcOUleTFM1jd0xpOHgzZ37xFeR1N9ZsTvKROvk23jwKjTPWoTgZ1ENEcaKcYTzX67Wz7cLZdVVgNB1OJAW90423qWXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTou2NNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTou2NNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A31C2BBFC;
	Thu, 13 Jun 2024 11:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279026;
	bh=B0XxeoU2YrDrUVIh63hK7FuPSunOVqIcM9l5E0MbyRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTou2NNUJ6mvKjT2njkWNHRew5BVSqWwlWhkxsintqbOHm1lonS3aXN99VbAxAv7k
	 GmRyKoBVZnHKvqB6af0wfzY7onauvXYv8M/nTemqqHjvX55UM8EwNaeS10aaqfmOYS
	 /8ImG+zuqw71dvdDYaI5Uup2p9i8aSTxhXONhoOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/213] x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y
Date: Thu, 13 Jun 2024 13:32:48 +0200
Message-ID: <20240613113232.627142143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 66ee3636eddcc82ab82b539d08b85fb5ac1dff9b ]

It took me some time to understand the purpose of the tricky code at
the end of arch/x86/Kconfig.debug.

Without it, the following would be shown:

  WARNING: unmet direct dependencies detected for FRAME_POINTER

because

  81d387190039 ("x86/kconfig: Consolidate unwinders into multiple choice selection")

removed 'select ARCH_WANT_FRAME_POINTERS'.

The correct and more straightforward approach should have been to move
it where 'select FRAME_POINTER' is located.

Several architectures properly handle the conditional selection of
ARCH_WANT_FRAME_POINTERS. For example, 'config UNWINDER_FRAME_POINTER'
in arch/arm/Kconfig.debug.

Fixes: 81d387190039 ("x86/kconfig: Consolidate unwinders into multiple choice selection")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20240204122003.53795-1-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig.debug | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 687cd1a213d50..82170d6257b1c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -376,6 +376,7 @@ config UNWINDER_ORC
 
 config UNWINDER_FRAME_POINTER
 	bool "Frame pointer unwinder"
+	select ARCH_WANT_FRAME_POINTERS
 	select FRAME_POINTER
 	---help---
 	  This option enables the frame pointer unwinder for unwinding kernel
@@ -403,7 +404,3 @@ config UNWINDER_GUESS
 	  overhead.
 
 endchoice
-
-config FRAME_POINTER
-	depends on !UNWINDER_ORC && !UNWINDER_GUESS
-	bool
-- 
2.43.0



