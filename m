Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E495611C88;
	Fri,  1 Mar 2024 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709312921; cv=none; b=GysUagc4/4A2AOndBM6mYRMTjhD9dqKrUC+qvfNFf5I9+dWvmBd1jHu0KctbJ7RLcvZeLomG8TDXmoz9SbLjFfcLQgqQfOX6pjCNaHtfz7h2gQ77Hla7NewfYCtCilmvnBGm56R3pri3JAhddHAU+uhArTTiPo5X5OQr25fSA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709312921; c=relaxed/simple;
	bh=eTObds2izYL4TPcl0aSAxiIVWF2HUMm+ABcCamdSz2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Ty2tI1TbZ77exZEvM4WIrO6K466zTB+vggaJcleI1vk8TOIaRUuhK2wLR+heMYjXpzX12ZUi9tJwXfMh744sozUz2eCS+jCydX9rooe9dPBbpZ7gxcoZzHDQj2DYFtZIF6fCl9DMq768eUg0NuqpPQHsJzubvyBf3FeshLcvZSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmOFGptM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmOFGptM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5046C433F1;
	Fri,  1 Mar 2024 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709312920;
	bh=eTObds2izYL4TPcl0aSAxiIVWF2HUMm+ABcCamdSz2U=;
	h=From:Date:Subject:To:Cc:From;
	b=MmOFGptM98VwC/lfX32kORpJFt12Yhq6FQsLxc/wG2wrapC77ddBWkfsULCT9EBOY
	 uqnNLrI085BfLuVCWhPUrcAY/aTDYpTfoiOQg1h28Vfg3Ksx/9JOC+80ns8VYenqpe
	 HcjIQSRcDc8CO2lSerJdaiWObWl4a7T9ZBk9nPGud/ohaA9Pfxfsi4LwLYEi9IPBp5
	 0Ht2TSUURux+87OXMABbY2ZeGkHIKe4Z0V6uI7x51ee5qHBX4kPkUyoZqpGZC6fKWK
	 1bmGCaX8YhjKsfJPQsQ2/YdggxpvZcRNppm43YEDsgBe0f8rM/YkIwjXVkrL1mq8vl
	 RUBxk/idEcDKA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 01 Mar 2024 10:08:22 -0700
Subject: [PATCH] ALSA: hwdep: Move put_user() call out of scoped_guard() in
 snd_hwdep_control_ioctl()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240301-fix-snd-hwdep-guard-v1-1-6aab033f3f83@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIUL4mUC/x2MywqAIBAAf0X23IJa0eNXooPlWnsxUXpA+O9Jx
 4GZeSFRZEowihciXZz48AVUJWDdjd8I2RYGLXUja6nQ8YPJW9xvSwG300SLZhkc9W1XK+OglCF
 S0f7rNOf8AT4FjHJlAAAA
To: perex@perex.cz, tiwai@suse.com
Cc: ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
 linux-sound@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4165; i=nathan@kernel.org;
 h=from:subject:message-id; bh=eTObds2izYL4TPcl0aSAxiIVWF2HUMm+ABcCamdSz2U=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmPuKdXSPZYPNPaNVEkJeNQYLOPb9etoL1qziEvFdlMN
 u+/cdKuo5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzk2XFGhieaJS8Tosq0xNed
 cPb6/G/hhuL1/mdC+Qu7hZIsAsovPGL4w5Wy/8L5mPod6SxP3OY8y+1NbK8QU34jWTD16elpwh8
 FWQE=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang prior to 17.0.0 has a bug in its asm goto jump scope analysis to
determine that no variables with the cleanup attribute are skipped by an
indirect jump. Instead of only checking the scope of each label that is
a possible target of each asm goto statement, it checks the scope of
every label, which can cause an error when a variable with the cleanup
attribute is used between two asm goto statements with different scopes,
even if they have completely different label targets:

  sound/core/hwdep.c:273:8: error: cannot jump from this asm goto statement to one of its possible targets
                          if (get_user(device, (int __user *)arg))
                              ^
  arch/powerpc/include/asm/uaccess.h:295:5: note: expanded from macro 'get_user'
                    __get_user(x, _gu_addr) :                             \
                    ^
  arch/powerpc/include/asm/uaccess.h:283:2: note: expanded from macro '__get_user'
          __get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);      \
          ^
  arch/powerpc/include/asm/uaccess.h:199:3: note: expanded from macro '__get_user_size_allowed'
                  __get_user_size_goto(x, ptr, size, __gus_failed);       \
                  ^
  arch/powerpc/include/asm/uaccess.h:187:10: note: expanded from macro '__get_user_size_goto'
          case 1: __get_user_asm_goto(x, (u8 __user *)ptr, label, "lbz"); break;  \
                  ^
  arch/powerpc/include/asm/uaccess.h:158:2: note: expanded from macro '__get_user_asm_goto'
          asm_volatile_goto(                                      \
          ^
  include/linux/compiler_types.h:366:33: note: expanded from macro 'asm_volatile_goto'
  #define asm_volatile_goto(x...) asm goto(x)
                                  ^
  sound/core/hwdep.c:291:9: note: possible target of asm goto statement
                                  if (put_user(device, (int __user *)arg))
                                      ^
  arch/powerpc/include/asm/uaccess.h:66:5: note: expanded from macro 'put_user'
                    __put_user(x, _pu_addr) : -EFAULT;                    \
                    ^
  arch/powerpc/include/asm/uaccess.h:52:9: note: expanded from macro '__put_user'
                                                                  \
                                                                  ^
  sound/core/hwdep.c:276:4: note: jump bypasses initialization of variable with __attribute__((cleanup))
                          scoped_guard(mutex, &register_mutex) {
                          ^
  include/linux/cleanup.h:169:20: note: expanded from macro 'scoped_guard'
          for (CLASS(_name, scope)(args),                                 \

To avoid this issue, move the put_user() call out of the scoped_guard()
scope, which allows the asm goto scope analysis to see that the variable
with the cleanup attribute will never be skipped by the asm goto
statements.

There should be no functional change because prior to the refactoring,
put_user() was not called under register_mutex, so this call does not
even need to be in the scoped_guard() in the first place.

Fixes: e6684d08cc19 ("ALSA: hwdep: Use guard() for locking")
Closes: https://github.com/ClangBuiltLinux/linux/issues/2003
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/core/hwdep.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 9d7e5039c893..09200df2932c 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -288,11 +288,10 @@ static int snd_hwdep_control_ioctl(struct snd_card *card,
 				}
 				if (device >= SNDRV_MINOR_HWDEPS)
 					device = -1;
-				if (put_user(device, (int __user *)arg))
-					return -EFAULT;
-				return 0;
 			}
-			break;
+			if (put_user(device, (int __user *)arg))
+				return -EFAULT;
+			return 0;
 		}
 	case SNDRV_CTL_IOCTL_HWDEP_INFO:
 		{

---
base-commit: 7dba48a474e68dcdda2b212cea131b4c9ddc7d89
change-id: 20240301-fix-snd-hwdep-guard-ab9fe85731af

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

