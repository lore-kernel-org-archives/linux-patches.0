Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768AA4ED1BC;
	Thu, 17 Sep 2026 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664577; cv=none; b=BbSZKv+szalXK6leLhu7c6LJCSa2gAbXkLDulRvWrkx004Ln0HoiirUqVhlc9TH4FzzvDt/Xgn8RgrukLFFf7AiDVU6fA5FT+OgGVoFrIsOfpGqXdzBtCVJN1J17n1A+7/1sWZf++Nkwg/O2vgSYdQKAIub7/9WhmpdWsJYaKNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664577; c=relaxed/simple;
	bh=4cio+PxqplwBs3cqbY9jc4T6vp4v77/ucXZevpAA+zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxT50Vfgh5edBRhWxIohhFoPZlh14+1I2SKvqwW1agyMINSq54UIji7Qvm5aYLiWbAiFPvlrXnq/y+N+m9H8VcbY8wURB3EEVplD7k6OB8GLAo3ydGzK3QHX4nleBO21fh51H0bk5ZkSsBUqqfQaMOY9B7C6IwwdC7klxcEglI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6u0paMz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6u0paMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA81F000FF;
	Thu, 17 Sep 2026 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664576;
	bh=fUINNAACPMOGByS6K/3+jQwN7WXp8A4k8tLCJlCo4sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6u0paMz3CCuR7BjLWlyvaqTA/4HnMi4khoXDNVT3JgA4uN5B3h7FcCTqn1ldKSEv
	 8M9eiZMgfaWR+PoSD8Tsa9pwDMhp7iWIYrZI8UWzugaQJXFbAPL2pvBfKq47sxsj7X
	 DiEEEtnvj1wdycnya8SJ5YTJu+ENaTIxWcTTvG7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0417/1250] sparc: Disable compat support with LLD
Date: Thu, 17 Sep 2026 16:03:32 +0100
Message-ID: <20260917151603.325497558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 852fed2e8bfe195351fb0078ba7245d41154e7a5 ]

An LLVM=1 sparc64 allmodconfig enables COMPAT and then tries to
build the 32-bit vDSO. That path cannot be linked with ld.lld:

  ld.lld: error: unknown emulation: elf32_sparc

ld.lld does not support the 32-bit SPARC ELF emulation used for
the compat vDSO, so keep COMPAT disabled when LLD is the linker.
This avoids selecting an unsupported build path while leaving the
existing GNU ld configuration unchanged.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a630d373e6453..454782ac54b26 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -470,6 +470,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
-- 
2.53.0



