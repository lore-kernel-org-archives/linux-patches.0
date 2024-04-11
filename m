Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1DA1E48E;
	Thu, 11 Apr 2024 10:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832709; cv=none; b=je33lydR3k8DH5x+/cdjwewubD5zZO42DfqZQVvLS9kmoDxjpOlYGwiPivXtVMsHkWo3jrrsIkcI85E7tVmdtiEMkplnOux7CNMLIMhVpPNpCWsrFf0DSRKa6ohvlP6Bz6+dEV8nahtZIcKtPPUwdpuKchaM8SZg7InY60p+Ack=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832709; c=relaxed/simple;
	bh=hCq890Y6HGsLHVY3quS/VfsbSCr3xKkoNG2C4SGA9fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj5pEdc/9K11wlplzPJXcRn4xN46YO2Iud0yQIJG2NTfS0fkKkHpY8q12TbgGuXzhZq9/y42j9wCoJg6yJBsXHZQKPP3dASPs8X3Ueht/KFymvd57DQOL/PnkUUxFOUWfO/TfQ5EzVKB3f4alM/LCKeYq/glwWrlOjv06laBvVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNWpKr0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNWpKr0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DE4C433C7;
	Thu, 11 Apr 2024 10:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832708;
	bh=hCq890Y6HGsLHVY3quS/VfsbSCr3xKkoNG2C4SGA9fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNWpKr0I8t87GJK8wZjAVe/NTL0BTIJ46baj/Gaq3T6QAAfSMGxcT8fxSycA20941
	 mPStrlV0ipPv9JAzCAbp6UvJlk7Gc1BOHyynv0vfeJnVGCj1z9IonBS7byLlnG6brH
	 zrK9SXa4bRPbzPlCa8Ej/r2VMBjVPPouYmOUU0YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 54/57] randomize_kstack: Improve entropy diffusion
Date: Thu, 11 Apr 2024 11:58:02 +0200
Message-ID: <20240411095409.623573872@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 9c573cd313433f6c1f7236fe64b9b743500c1628 ]

The kstack_offset variable was really only ever using the low bits for
kernel stack offset entropy. Add a ror32() to increase bit diffusion.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 39218ff4c625 ("stack: Optionally randomize kernel stack offset each syscall")
Link: https://lore.kernel.org/r/20240309202445.work.165-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/randomize_kstack.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/randomize_kstack.h b/include/linux/randomize_kstack.h
index d373f1bcbf7ca..5d52d15faee0c 100644
--- a/include/linux/randomize_kstack.h
+++ b/include/linux/randomize_kstack.h
@@ -58,7 +58,7 @@ DECLARE_PER_CPU(u32, kstack_offset);
 	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
 				&randomize_kstack_offset)) {		\
 		u32 offset = raw_cpu_read(kstack_offset);		\
-		offset ^= (rand);					\
+		offset = ror32(offset, 5) ^ (rand);			\
 		raw_cpu_write(kstack_offset, offset);			\
 	}								\
 } while (0)
-- 
2.43.0



