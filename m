Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22D72517AB;
	Tue, 29 Apr 2025 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948141; cv=none; b=WZo7QLUrmmMOIaxopSHIj5iNNYDZ0L6aUxHBk98gLvkzBewMEHEjUGNkRF3DfUYtRLls4NsG3lvX+ITAhkUeCh0TCgwNpG5/9uyNY8r4zuzO75pT0dRt5YmgDS1vqXZ8c1TnlCVtqVsukVmMg/XLuOPPIghOpjsLPFHRlrAEkP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948141; c=relaxed/simple;
	bh=9J3ZRDpL4d8DFfP5bCCvD8m6/bm0PyBnzYVHmDMXDvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8HX7ShQ470XhdQnqqiiJuYKHTRAi5KVKveCdls0xQYSerKl+OmccqFUhuIzm3yQUwOhl6bHXiApan446TlD8Dee5/e99eB7skiB3TRtuOfX1FHf9uvS6ToHq16tlIzpVa6e1q4N9vJWpf28pNkNFT/cE4DRDsqP0XSEv+EqvkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+8KRNBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+8KRNBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4428C4CEE3;
	Tue, 29 Apr 2025 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948141;
	bh=9J3ZRDpL4d8DFfP5bCCvD8m6/bm0PyBnzYVHmDMXDvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+8KRNBGEo6WbpZ0X8pMKE8flKrqBiuMLrY057dC98Gc8QPpICqJrsD5VHyQkGnvb
	 H8LejgcaydT2kNazMJdUIc6L2Xiqp/hx2I3ILTImqscBXdyFuAT0ZbA5vLxqrx8EAn
	 u9UOdaWOTDGHjSynToZdyjENu4wPwEqOAnkza0Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/280] kbuild: add dependency from vmlinux to sorttable
Date: Tue, 29 Apr 2025 18:42:20 +0200
Message-ID: <20250429161123.269594936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit 82c09de2d4c472ab1b973e6e033671020691e637 ]

Without this dependency it's really puzzling when we bisect for a "bad"
commit in a series of sorttable change: when "git bisect" switches to
another commit, "make" just does nothing to vmlinux.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.vmlinux | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 1284f05555b97..0c2494ffcaf87 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -33,6 +33,10 @@ targets += vmlinux
 vmlinux: scripts/link-vmlinux.sh vmlinux.o $(KBUILD_LDS) FORCE
 	+$(call if_changed_dep,link_vmlinux)
 
+ifdef CONFIG_BUILDTIME_TABLE_SORT
+vmlinux: scripts/sorttable
+endif
+
 # module.builtin.ranges
 # ---------------------------------------------------------------------------
 ifdef CONFIG_BUILTIN_MODULE_RANGES
-- 
2.39.5



