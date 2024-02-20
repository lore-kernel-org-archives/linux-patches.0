Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD2D446C9;
	Tue, 20 Feb 2024 21:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464721; cv=none; b=Emis6X/LQ/PbNj7pPXbj6FZbZHp0BGSDBDHuO0ductpCZ9IavNfdAfjPZF8STVKw/LKv7DCB67TJQXH0MaMkSWHc4lq6C6W+VW7bBn/6vMhHGPUknuUT85RVE9l9TCEt9OgxgD2lyYshnb9vSI9RjetKtDDHHEkNgGJCVitU/Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464721; c=relaxed/simple;
	bh=pvRjih6kpf2CoKGcCXLxuAmUGpG0SlgE5WRRmcIudQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoI+euQHglWqYCaVNas8/YuviPduXppJFCUfuwk49fHAOYr6hdqpMnwOzH8oPdoXHU+tNYP2yuEu7nGEM3mX3fvL81p3UYHzrJKpfLeMnUwf1K/q6SVuDv5KXweM324w/ZBRohFHMBcleR5bt4OOOAVORN5+AgevSBOUKzDgloA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os0EYaLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os0EYaLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E067CC433F1;
	Tue, 20 Feb 2024 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464721;
	bh=pvRjih6kpf2CoKGcCXLxuAmUGpG0SlgE5WRRmcIudQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os0EYaLXZ9b6RMJZJtLtqycKK16FUk49EtSqnqcWSLn7J/FO5IUln7gRgw5n8lxGC
	 OhooPUVRzPWLQCFK3GuZLqVlsEjBJbkFRWnoSEm/qGmPb8o7pfmeqzp8itNrZfwQ0b
	 sthKm6SAkOtwfA39BCkv3DLIbH/Yt9roQiDgoTZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 115/309] kallsyms: ignore ARMv4 thunks along with others
Date: Tue, 20 Feb 2024 21:54:34 +0100
Message-ID: <20240220205636.783826623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a951884d82886d8453d489f84f20ac168d062b38 ]

lld is now able to build ARMv4 and ARMv4T kernels, which means it can
generate thunks for those (__ARMv4PILongThunk_*, __ARMv4PILongBXThunk_*)
that can interfere with kallsyms table generation since they do not get
ignore like the corresponding ARMv5+ ones are:

Inconsistent kallsyms data
Try "make KALLSYMS_EXTRA_PASS=1" as a workaround

Replace the hardcoded list of thunk symbols with a more general regex that
covers this one along with future symbols that follow the same pattern.

Fixes: 5eb6e280432d ("ARM: 9289/1: Allow pre-ARMv5 builds with ld.lld 16.0.0 and newer")
Fixes: efe6e3068067 ("kallsyms: fix nonconverging kallsyms table with lld")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index 9ba1c9da0a40..57ff5656d566 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -48,17 +48,8 @@ ${NM} -n ${1} | sed >${2} -e "
 / __kvm_nvhe_\\$/d
 / __kvm_nvhe_\.L/d
 
-# arm64 lld
-/ __AArch64ADRPThunk_/d
-
-# arm lld
-/ __ARMV5PILongThunk_/d
-/ __ARMV7PILongThunk_/d
-/ __ThumbV7PILongThunk_/d
-
-# mips lld
-/ __LA25Thunk_/d
-/ __microLA25Thunk_/d
+# lld arm/aarch64/mips thunks
+/ __[[:alnum:]]*Thunk_/d
 
 # CFI type identifiers
 / __kcfi_typeid_/d
-- 
2.43.0



