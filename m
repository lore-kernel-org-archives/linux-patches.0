Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570B54B44A9;
	Thu, 17 Sep 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660004; cv=none; b=XI20TqEybh9PmB+okbZ5PkbMqGzNrf2f1Z2fzs+L0r0/Tud+XShOjex98QC6jxo1ApOJSd1lj2esYeKmS8MjAfMfnXYUXoZyp2AfonuhmCz2DzAYHznZmx8s7XpKoDNuQobNt60Agqsk+skmH+E/K/wbVb8nHKTTdBA2xH/C6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660004; c=relaxed/simple;
	bh=nT4O7IpesbWm5pd6GJS5JdbYE3UkIa/jxhHE7LoAG4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcFAfmamsSC9wCw75nk9DEAf6zw5os3l/wXyhfXNM1qa0RTkNLAImIa7S3LV26Xg4pQ/jinB4R1BJLV1WFqpILWNZPm0BmFEqmP0V2Jdgh/SNA+DL2cmApryNkxRxQuWkPK9el9/Qh5GibG/1UkjG5XJX4NV+gEdYm3cpfsH5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqCeP1c/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqCeP1c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F561F00898;
	Thu, 17 Sep 2026 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659997;
	bh=SzIsbJ1OXAnPkX2amAy0uxgdyKr3YdxeeRZVKkKQoyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqCeP1c/dyaDytvy/+q0if3wkt4/zU4rjOpktbHpJpmvaevtsiRKb3ULnJLn/wsYm
	 MdUgO3W6J04Jmr9GDFg9TXjXVNCT1Mic1ZGDJu8cWhSaUIRibXP2p2H7NrmZnPKjks
	 W1eBd9wf3kITpHhQGOQBqUq3rbxaVdwQjRtrkaJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 443/733] scripts/mksysmap: drop the MODULE_INFO() symbols from kallsyms
Date: Thu, 17 Sep 2026 16:12:31 +0100
Message-ID: <20260917151402.918641016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 281b61d408d4c39544583e393c6707af0ef5ee50 ]

Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
keeps .modinfo symbols out of System.map and kallsyms, which assumes unique
IDs have a format like '__UNIQUE_ID_modinfo123'.

However, commit afb026b6d35c ("compiler: Tweak __UNIQUE_ID() naming"), sent
in the same cycle, changes this to '__UNIQUE_ID_modinfo_123'.

As a result this regexp has never matched and every kernel since v6.18 has
carried one kallsyms entries for every MODULE_INFO() declaration in the
kernel whether the modules are compiled or not.

That's 5,810 entries for an x86 defconfig build and 15,200 for arm64.

On x86 defconfig that is 113 KiB of kallsyms tables and 32 KiB of bzImage,
and every lookup walks past them.

Fix the pattern.

Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260908-build-speedup-v1-1-5dc1ac01672d@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index c4531eacde202..56a8b8bbdb373 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -83,7 +83,7 @@
 / _SDA2_BASE_$/d
 
 # MODULE_INFO()
-/ __UNIQUE_ID_modinfo[0-9]*$/d
+/ __UNIQUE_ID_modinfo_[0-9]*$/d
 
 # ---------------------------------------------------------------------------
 # Ignored patterns
-- 
2.53.0



