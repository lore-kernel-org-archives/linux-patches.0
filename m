Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32782E7F1A;
	Tue, 15 Jul 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587889; cv=none; b=VbQ6v7yq5FxaPSs0ZhUcoJByYBcKRzKm9UE8qKX61Csp0wJhKOLyPiYxbhmZydjCeyPJVm4g3EAns2JuhUUJruJOu8bGN89pnNKqrMvQReL0mIw9D4Y+dIwhpUCfI6VVdUnU8Bvh771S53JXCmsNTn4rkThnfjGWU+tcNxXw4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587889; c=relaxed/simple;
	bh=+SWmiBJ+pv+YhcVJh4wQtucQwdMnhmH34bDWd2EaT2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uE7BE2cNQ5fpWX9znKmPwkBclMmaJmtOf7prAnlBEOLHdpvRe1q6dvzKFgrtLrFNhZxlmeOIYmkwl2fLMoioCYdLA1e8JtTAGUpJF4P0VGbe1W3bTQiyVB5kN85GJdo0Z8hgCbyPn2KpQtTKIE+lmVImfULVA/CS3GDSGaaDn7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5aGpa9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5aGpa9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B84C4CEF7;
	Tue, 15 Jul 2025 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587889;
	bh=+SWmiBJ+pv+YhcVJh4wQtucQwdMnhmH34bDWd2EaT2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5aGpa9YelHvS5JFHUR6K5RPeuhqtY/1zV24I/13/NKO5q7kfcNjUuaYNEcbypNHl
	 gNIM/SZyJZ44kvDSD/5LS30ZnbDAXiILSh/1flVvCJiHujDaviiNcIZAzHrrNFIob3
	 deo2YWya+z2fFZfz0OroROkSnU27TiLgAS4svGt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 164/208] x86/its: Fix undefined reference to cpu_wants_rethunk_at()
Date: Tue, 15 Jul 2025 15:14:33 +0200
Message-ID: <20250715130817.547752927@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Below error was reported in a 32-bit kernel build:

  static_call.c:(.ref.text+0x46): undefined reference to `cpu_wants_rethunk_at'
  make[1]: [Makefile:1234: vmlinux] Error

This is because the definition of cpu_wants_rethunk_at() depends on
CONFIG_STACK_VALIDATION which is only enabled in 64-bit mode.

Define the empty function for CONFIG_STACK_VALIDATION=n, rethunk mitigation
is anyways not supported without it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 5d19a0574b75 ("x86/its: Add support for ITS-safe return thunk")
Link: https://lore.kernel.org/stable/0f597436-5da6-4319-b918-9f57bde5634a@roeck-us.net/
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -80,7 +80,7 @@ extern void apply_returns(s32 *start, s3
 
 struct module;
 
-#ifdef CONFIG_RETHUNK
+#if defined(CONFIG_RETHUNK) && defined(CONFIG_STACK_VALIDATION)
 extern bool cpu_wants_rethunk(void);
 extern bool cpu_wants_rethunk_at(void *addr);
 #else


