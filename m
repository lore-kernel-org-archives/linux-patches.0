Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ABC2222BB;
	Mon,  2 Jun 2025 14:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873290; cv=none; b=uAzM8s6T9OHonr3jCmtVW9p471D6OebOWniZWvo2638QGOlvoy4dehseAE2OIzqqwE5cYVAxyjV5vBvoL75F2R4nqWSH9ncS4HR/hWfGbQhmrwsNUSUVpxqsEmL25dE7aJYkPuUbou47yNkaMxRMKANSOYE/ZNlq7x0eG2rqeVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873290; c=relaxed/simple;
	bh=y+qBLju3u5BF6KrAWaH2c3w/wrdacvRFTA6nxZbtK8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE7UclshX07W3H3CsO4Vy7409eowZZ4DtLvoR/tBFw4F13mWFC+jdRWVbH2ByOjX95siPO4pqbEn38pSsXt1ZcNm6WtXCiqd5XZ6xIKSgYCOXUrAvnHFVAJSwCoYDkF064Wl/FS5CXMiLufkQEzbRE5GZrAdijppkTznvUki+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQwgGria; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQwgGria"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D081BC4CEF0;
	Mon,  2 Jun 2025 14:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873290;
	bh=y+qBLju3u5BF6KrAWaH2c3w/wrdacvRFTA6nxZbtK8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQwgGria/bJ4kGHPnPRTBPGqp4b1riJia9arxpkTgRaufBf9MUBURtCoOMcE9Q18U
	 RqFtSeXNHZP0VfNasWG0Ov9EprHVBXMz1JWCvc7bv5wM0fKhREAdMq9F/1M8Y0092I
	 w8+2cJPkbKdJIXcxCGXpHQtJ7X86xtPfRh+YwEBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/444] objtool: Fix error handling inconsistencies in check()
Date: Mon,  2 Jun 2025 15:42:39 +0200
Message-ID: <20250602134344.758194527@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit b745962cb97569aad026806bb0740663cf813147 ]

Make sure all fatal errors are funneled through the 'out' label with a
negative ret.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Link: https://lore.kernel.org/r/0f49d6a27a080b4012e84e6df1e23097f44cc082.1741975349.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f5af48502c9c8..f8e676a6e6f8e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4692,8 +4692,10 @@ int check(struct objtool_file *file)
 	init_cfi_state(&force_undefined_cfi);
 	force_undefined_cfi.force_undefined = true;
 
-	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3))) {
+		ret = -1;
 		goto out;
+	}
 
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
@@ -4710,7 +4712,7 @@ int check(struct objtool_file *file)
 	if (opts.retpoline) {
 		ret = validate_retpoline(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
@@ -4746,7 +4748,7 @@ int check(struct objtool_file *file)
 		 */
 		ret = validate_unrets(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
@@ -4809,7 +4811,7 @@ int check(struct objtool_file *file)
 	if (opts.prefix) {
 		ret = add_prefix_symbols(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
-- 
2.39.5



