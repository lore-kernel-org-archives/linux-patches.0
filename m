Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D9C30F921;
	Mon, 13 Oct 2025 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368893; cv=none; b=iGZoXWgVl8wYnhgsY5uCw9OUry4HnAj9Sht4LtB+Pxzpgftm/IIiXrQv9KOEkZAd2hmYZtJBZWK7NO6d5Fdtxc0ZZNtIAvGFUVw3lnzVp14GYG6tbSHCJPojQ+fjM34WEIBorYsONi6qtvIGsrVSX1za3ZjD46AbxdjjCfZsBRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368893; c=relaxed/simple;
	bh=mjAP/N458hWYcDH900Msvl9kOP4HvlsrXHgGAX/pFJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+Gf4yyv2BxhlClXLNTyhA7BHf9zUKrUBoX0gbodS0vIwxV9ZD+yJPeVhfw4lN7EXnhK7SlDU/1XpDnRkr2aMitx0DUKDb0sH4vta/ZJSyPo/jPAHGHLdUvO03yATbgojWNJaFUmaJfoFctSCEnK9x9aq4AeB63av+Jkxs5X1Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qehkJ0Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qehkJ0Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DDDC4CEE7;
	Mon, 13 Oct 2025 15:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368893;
	bh=mjAP/N458hWYcDH900Msvl9kOP4HvlsrXHgGAX/pFJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qehkJ0SdBUD1IbonQ4rVhB+yOsMPzWXRVhhtlPGi2BjUxN+LOID9onnPQyqKj07nZ
	 ljEVBsE0zKmUOKsgsGRInRDV9IlEFWk9Ymi155c9JJnuGGjy8E9qfnm596UpYHZHMt
	 tDCKwvkXF1ls+CGTgeAJLiZ3IDZNe7Sx2Kkbd2G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 022/563] powerpc/ftrace: ensure ftrace record ops are always set for NOPs
Date: Mon, 13 Oct 2025 16:38:03 +0200
Message-ID: <20251013144412.092855859@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 5337609a314828aa2474ac359db615f475c4a4d2 ]

When an ftrace call site is converted to a NOP, its corresponding
dyn_ftrace record should have its ftrace_ops pointer set to
ftrace_nop_ops.

Correct the powerpc implementation to ensure the
ftrace_rec_set_nop_ops() helper is called on all successful NOP
initialization paths. This ensures all ftrace records are consistent
before being handled by the ftrace core.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Suggested-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250912142740.3581368-2-joe.lawrence@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/trace/ftrace.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 6dca92d5a6e82..841d077e28251 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -488,8 +488,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 		return ret;
 
 	/* Set up out-of-line stub */
-	if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE))
-		return ftrace_init_ool_stub(mod, rec);
+	if (IS_ENABLED(CONFIG_PPC_FTRACE_OUT_OF_LINE)) {
+		ret = ftrace_init_ool_stub(mod, rec);
+		goto out;
+	}
 
 	/* Nop-out the ftrace location */
 	new = ppc_inst(PPC_RAW_NOP());
@@ -520,6 +522,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 		return -EINVAL;
 	}
 
+out:
+	if (!ret)
+		ret = ftrace_rec_set_nop_ops(rec);
+
 	return ret;
 }
 
-- 
2.51.0



