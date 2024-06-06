Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5519A19AD46;
	Thu,  6 Jun 2024 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683040; cv=none; b=pfrcYPVFraF446pm1EcjCDSGsffH3ghNN/k9UG+U4NEv/mk6hZV+jsvlVO9l8OOOlgev25y3lzTYp3w1JHOXQACi90yrmPCmX5GTTkBboH0IEDlkMlH+TjY/m8tH7bTG8CG9/nXYtl7oixKPIVRhXU8cO1J7/O5HbcihHR+44fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683040; c=relaxed/simple;
	bh=nRKtAFy0GAAF0YVVgr5xm82ZkOfb/QTqpaP02HXKlt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdpuEJx1LwHIZoeEM5a2YDm4dh5MLujOkZu6epeYCyZNOnDInt48x4AUYo7FxIXnYAntGGIBixEh+PTNax/aR0VLjcoYGoIfuFf72PCFNbW1e7NYIbN6auD8m+ENewGZRMDs1AK/3dqnHvNiK+KMdPTfkqmMU+gZ+DYXVxGgx5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZ0kqBz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZ0kqBz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DF5C4AF08;
	Thu,  6 Jun 2024 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683040;
	bh=nRKtAFy0GAAF0YVVgr5xm82ZkOfb/QTqpaP02HXKlt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ0kqBz3hPMTb93LdiQ+BblU2FyZBWUzsnv5MJWskho0s1YUHuVankAZFnLcYe73D
	 czvYh2NHI/mditZsHqNq8ReoiWB2Ik+zYdpez8MDj+VZka0EfzlRn7WuCLiyfD0Hec
	 iSQ86AWYGcMhaf7rUtbCAMcgS8Er0rROh0tDxISg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 232/374] x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y
Date: Thu,  6 Jun 2024 16:03:31 +0200
Message-ID: <20240606131659.580736371@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index c5d614d28a759..74777a97e394a 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -248,6 +248,7 @@ config UNWINDER_ORC
 
 config UNWINDER_FRAME_POINTER
 	bool "Frame pointer unwinder"
+	select ARCH_WANT_FRAME_POINTERS
 	select FRAME_POINTER
 	help
 	  This option enables the frame pointer unwinder for unwinding kernel
@@ -271,7 +272,3 @@ config UNWINDER_GUESS
 	  overhead.
 
 endchoice
-
-config FRAME_POINTER
-	depends on !UNWINDER_ORC && !UNWINDER_GUESS
-	bool
-- 
2.43.0



