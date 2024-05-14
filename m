Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E96812FB14;
	Tue, 14 May 2024 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686180; cv=none; b=JTUpWT0G6/2Ulao5fEcZ0+h6tzV+e7pNAz5zCHAzEs9S04SEAyMh3eI9LVp/9/cBjJ1wi/qP5pzUic2d9FcOev1OilRtAsrR9KRLskYmJMYpDf1d3qW2kY/gGkMHcXLykjYpqSPiqL8NSbDa0nYcxgXmpnnZXFEzHWWP0jrgJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686180; c=relaxed/simple;
	bh=tm4L7hVxEsv65Jp+zGs1XeLtyau7GQjTn3PWsctm5UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPnbDvLLm9NApm8C4PF9vL5PnxpwUhD28qCtGRTTgDwbzaAMQD5WplJsk24qFt8wM/vxAMZbWjDyp/4B/O0iWfxgQIBKtWk3Ok0LbkH3+v98azDxl8WGjVm9oDAtnPI/Xnc5jnURCpDNwvNHU9mBFPUMIS7J7ht6zXih5NPn3lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4lSRHIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4lSRHIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D88C2BD10;
	Tue, 14 May 2024 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686179;
	bh=tm4L7hVxEsv65Jp+zGs1XeLtyau7GQjTn3PWsctm5UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4lSRHITJJ1speup1dv4Y1hsXaBHtnFoJBaNx2+LKjZ/ICX9wYyO8yy2hPtkwgTew
	 iWVDTRtqDDHrVDCLweNq2uNwwysFImmZOgdvP69p3gAAQWvLFw52jfkfbAyf9MXooN
	 OJLnUS/ZkwnlNAv/rPCimk6goX6z9TMMuoLMILF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/236] kbuild: refactor host*_flags
Date: Tue, 14 May 2024 12:16:20 +0200
Message-ID: <20240514101021.023558506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 16169a47d5c36046041527faafb5a3f5c86701c6 ]

Remove _host*_flags. No functional change is intended.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: ded103c7eb23 ("kbuild: rust: force `alloc` extern to allow "empty" Rust files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.host | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index da133780b7518..4a02b31cd1029 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -80,25 +80,23 @@ host-rust	:= $(addprefix $(obj)/,$(host-rust))
 #####
 # Handle options to gcc. Support building with separate output directory
 
-_hostc_flags   = $(KBUILD_HOSTCFLAGS)   $(HOST_EXTRACFLAGS)   \
+hostc_flags    = -Wp,-MMD,$(depfile) \
+                 $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS) \
                  $(HOSTCFLAGS_$(target-stem).o)
-_hostcxx_flags = $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
+hostcxx_flags  = -Wp,-MMD,$(depfile) \
+                 $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
                  $(HOSTCXXFLAGS_$(target-stem).o)
-_hostrust_flags = $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
-                  $(HOSTRUSTFLAGS_$(target-stem))
+hostrust_flags = $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
+                 $(HOSTRUSTFLAGS_$(target-stem))
 
 # $(objtree)/$(obj) for including generated headers from checkin source files
 ifeq ($(KBUILD_EXTMOD),)
 ifdef building_out_of_srctree
-_hostc_flags   += -I $(objtree)/$(obj)
-_hostcxx_flags += -I $(objtree)/$(obj)
+hostc_flags   += -I $(objtree)/$(obj)
+hostcxx_flags += -I $(objtree)/$(obj)
 endif
 endif
 
-hostc_flags    = -Wp,-MMD,$(depfile) $(_hostc_flags)
-hostcxx_flags  = -Wp,-MMD,$(depfile) $(_hostcxx_flags)
-hostrust_flags = $(_hostrust_flags)
-
 #####
 # Compile programs on the host
 
-- 
2.43.0



