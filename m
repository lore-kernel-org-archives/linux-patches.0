Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87A7196D80;
	Thu,  6 Jun 2024 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682961; cv=none; b=GYFn8OzbeCnj3+RKQU1vxwy2VncN54Z/gHydDFTHFWWyQFEzlRRbwjuXaIH6/yom6G+u3vlNKQejzmeWJTVKb1CJE6YnvoHOtOn3+TflqSBSaeZWDA3ZRBgMD9s+ODh5zRKnTuGgR2o0/z2yHRgCXfrhHTaaZKpMFpMpUqocVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682961; c=relaxed/simple;
	bh=sA26Otu2TVMrixUHQvk8mhyZ+C5xQJwvegGwQH54b98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7mDSk1h880Nw9ZD88k/JT8j2r8Zi/Y1hxDjy7CwYUQoGB12g4klP7EaCpbPUbJ7PZ9LtFPw6e1/VcZyEF/0aJsYreqntq3gYUyl85xarXKMtpfgDqJv418CCTL0qwh+anvDPQBoHcemp7F4eL47L/dI6tlBLbaIoLe3P8MjgSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWr2Jo4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWr2Jo4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552CAC32781;
	Thu,  6 Jun 2024 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682961;
	bh=sA26Otu2TVMrixUHQvk8mhyZ+C5xQJwvegGwQH54b98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWr2Jo4Vf8Di7x5+5bJpsQDSzfCWSRVMYTL593jqw7GW0l8m5JPdQiq0P53ZxfiPp
	 Tb7ejdJAMsGqMoSNcW7J6njPUXepC0I01uAlbQp8Z8YEdJKfJMANFzAP1ALLnkQpiQ
	 btbpGysgEWSNVLw5N8sBfmAs23PCppeNvaCGg140=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 128/374] s390/vdso: Create .build-id links for unstripped vdso files
Date: Thu,  6 Jun 2024 16:01:47 +0200
Message-ID: <20240606131656.188821213@linuxfoundation.org>
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

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit fc2f5f10f9bc5e58d38e9fda7dae107ac04a799f ]

Citing Andy Lutomirski from commit dda1e95cee38 ("x86/vdso: Create
.build-id links for unstripped vdso files"):

"With this change, doing 'make vdso_install' and telling gdb:

set debug-file-directory /lib/modules/KVER/vdso

will enable vdso debugging with symbols.  This is useful for
testing, but kernel RPM builds will probably want to manually delete
these symlinks or otherwise do something sensible when they strip
the vdso/*.so files."

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.vdsoinst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.vdsoinst b/scripts/Makefile.vdsoinst
index c477d17b0aa5b..a81ca735003e4 100644
--- a/scripts/Makefile.vdsoinst
+++ b/scripts/Makefile.vdsoinst
@@ -21,7 +21,7 @@ $$(dest): $$(src) FORCE
 	$$(call cmd,install)
 
 # Some architectures create .build-id symlinks
-ifneq ($(filter arm sparc x86, $(SRCARCH)),)
+ifneq ($(filter arm s390 sparc x86, $(SRCARCH)),)
 link := $(install-dir)/.build-id/$$(shell $(READELF) -n $$(src) | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p').debug
 
 __default: $$(link)
-- 
2.43.0



