Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC5527FD5B;
	Tue, 27 May 2025 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364719; cv=none; b=ocHFCRVPkr3QkzdyWjgdyWDqOOTIyrlwwI4E7KWffJink26vZ8DncCIRMNYxl5bKQh25wIyGk3XSZCJG2GnZt5kWlIxz/8mGGoSzRhH4aREamRdhf0ZkuliALj1RaK1ORHbiITcxA2epjRDStjWRyH1WkvjWtPNHdovABIpsbZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364719; c=relaxed/simple;
	bh=1RP2P5vGOsm8Ax3+KmrCCDpsUunHceII/po7NNFj2Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n53u2c5d9717+my96tdyA07NtcArVmAcFXvY0QwTEtRknkx8x7Ag0qU18BT0L76HWNf97rjVCiuY54Qm1k5PIGVUFenFQUVuuX/ZzDuyE8IsFouzsERcUtATIGjc0SNERVq4AO8p9tBAAlyWZ+RirQq+c8WsxEWvT1O8VdHUSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIcwJUpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIcwJUpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8B7C4AF0C;
	Tue, 27 May 2025 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364718;
	bh=1RP2P5vGOsm8Ax3+KmrCCDpsUunHceII/po7NNFj2Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIcwJUpYtd+0VtozUa4nNYQ+Z5+kuINEGlw/QxnlPmSmr/3X5QsoZ/98u+pprpm0S
	 5leuYvGnvebsNdxxUp1l1Su2yrVZ05i5RvYSOd3hIKrUB8Gt/urtepaeBE3bhqCBQ6
	 tpzzkChxghR2Woj9cHV/vw0aFF03WhfeSyUV4wuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/626] objtool: Fix error handling inconsistencies in check()
Date: Tue, 27 May 2025 18:20:36 +0200
Message-ID: <20250527162450.840995465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 0757b98b0a445..4fce0074076f3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4758,8 +4758,10 @@ int check(struct objtool_file *file)
 	init_cfi_state(&force_undefined_cfi);
 	force_undefined_cfi.force_undefined = true;
 
-	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3))) {
+		ret = -1;
 		goto out;
+	}
 
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
@@ -4776,7 +4778,7 @@ int check(struct objtool_file *file)
 	if (opts.retpoline) {
 		ret = validate_retpoline(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
@@ -4812,7 +4814,7 @@ int check(struct objtool_file *file)
 		 */
 		ret = validate_unrets(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
@@ -4875,7 +4877,7 @@ int check(struct objtool_file *file)
 	if (opts.prefix) {
 		ret = add_prefix_symbols(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
-- 
2.39.5



