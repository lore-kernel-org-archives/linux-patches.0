Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B340149C6F;
	Fri,  6 Dec 2024 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498191; cv=none; b=GuqwWDdojoFkKlgyVNApx61ARsL+bGwKpXFnMKN8SEf/xZwZJM90e8aEFZrwoytFA0OB/PBJLn3OlyfN7i/3MMAwe/KGomU44oHacJsDJpzOVUM5rU1RGXYBAr+MDpKRqYYSnF/V1+j0DNyd8siiTB7MAUPswlbSEgb1Uxw6tRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498191; c=relaxed/simple;
	bh=Au1iJ5w1Am7U5mQd8XP2NSujwtG2OxwB9Mjg4o7qmc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFKtml8ViP+z14aOxHMchwUFuTXFl9q1X0bPBgSaO4ql8FdSFuRVMO2MKujFmF4ZU9GVhKL0PatRBlWcDbOCz9OH9Kwhucpc9MwDXQYFp8OM8GqHCur9Re155P+PvBETSnATVqtqNJo2TH8UTtlKLsjgPWTXeB9zxT0bubtsQxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXlPHgZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXlPHgZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9E8C4CED1;
	Fri,  6 Dec 2024 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498191;
	bh=Au1iJ5w1Am7U5mQd8XP2NSujwtG2OxwB9Mjg4o7qmc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXlPHgZ3g+L2ZA22CfUtmQwoCms+ohrKea42aYIfKx+GiklaU0rX0EHoAXKg0MKvy
	 rHkmZun/MDzgkbbbrBcry9qJmMfrTP9MZ8twLadbmdPUEYPAAfXKiMboX8Y/28qRm4
	 GFAoFfsLuzVgyNzHWbh1yOsl3f8PStmnl8Rr2RDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 511/676] parisc/ftrace: Fix function graph tracing disablement
Date: Fri,  6 Dec 2024 15:35:30 +0100
Message-ID: <20241206143713.314528022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit a5f05a138a8cac035bf9da9b6ed0e532bc7942c8 upstream.

Due to an apparent copy-paste bug, the parisc implementation of
ftrace_disable_ftrace_graph_caller() doesn't actually do anything.
It enables the (already-enabled) static key rather than disabling it.

The result is that after function graph tracing has been "disabled", any
subsequent (non-graph) function tracing will inadvertently also enable
the slow fgraph return address hijacking.

Fixes: 98f2926171ae ("parisc/ftrace: use static key to enable/disable function graph tracer")
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -87,7 +87,7 @@ int ftrace_enable_ftrace_graph_caller(vo
 
 int ftrace_disable_ftrace_graph_caller(void)
 {
-	static_key_enable(&ftrace_graph_enable.key);
+	static_key_disable(&ftrace_graph_enable.key);
 	return 0;
 }
 #endif


