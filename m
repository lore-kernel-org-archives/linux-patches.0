Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213B46AA89;
	Tue, 21 Jul 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648271; cv=none; b=SYJmAP+PHRDQNst4meFxyilpgAEU643Lp7qVjS8Fu+MnMgNJNZYI5aSzO0VxVgZeKabd+ar4oeh6oSITte0Lt1YXrXk0/WQ6J1lr2bwHkBKusCuqLoJQGQr9tjB+HheYO3zfbtle8kGEWKvhQq7SZh3QPuMVdkDbPGclUbOZBuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648271; c=relaxed/simple;
	bh=BRu19k5JbciJAldA/W7LVxtWXxsw60NDqn+7RWqmLj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9HEQXTGIcLiEDe57stWBKlwYg/E9ak8OljiJqSN/iqMPvMahk7EgNwMKj1t1QStPixs/nwLgHrZzmeRrVIG5d3gLDPgeAi99T5beabEc2ofHzI8FchRYk4z0vnw3cWzPiHnd2/xvKgeUl3qLO1w8XBtKAyTlggdzOzjAo+GSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCcV8zbS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCcV8zbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CE11F00A3A;
	Tue, 21 Jul 2026 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648270;
	bh=QWdGAv7vA+0Cv3BTzPShfRnLdVoMzYd2N+CvCYZJyHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCcV8zbSC+aTCR8MZIxBVSlRBy6dHnLCEj56qFgs/s44prPYxdWSsYsgmPxKWoVjg
	 /P0AHipikorJZfmo/MeCjWJx1xzc++b/qPs3H2P5BK9MKFaMsyE7BII6cOtNzBVWjr
	 VtWOq6/0dVMT4fBNnumpG1Ey2VLsD5XELYuoBV2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0129/2077] objtool: Fix reloc hash collision in find_reloc_by_dest_range()
Date: Tue, 21 Jul 2026 16:56:42 +0200
Message-ID: <20260721152555.737700207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit a375e327b63e0da29b82a92b569bfdf4628fa38a ]

In find_reloc_by_dest_range(), hash collisions can cause a high-offset
relocation to appear when probing a low-offset hash bucket.

Only return early when the best match found so far genuinely belongs to
the current bucket (its offset is within the bucket's stride range).
Otherwise, continue scanning later buckets which may contain
lower-offset matches.

This ensures the first reloc in the range gets returned.

Fixes: 74b873e49d92 ("objtool: Optimize find_rela_by_dest_range()")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index dc39132f71c148..58631d62011d67 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -301,8 +301,9 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
+/* If there are multiple matches, return the first one in the range */
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
-				     unsigned long offset, unsigned int len)
+				       unsigned long offset, unsigned int len)
 {
 	struct reloc *reloc, *r = NULL;
 	struct section *rsec;
@@ -324,11 +325,11 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
 					r = reloc;
 			}
 		}
-		if (r)
+		if (r && (reloc_offset(r) & OFFSET_STRIDE_MASK) == o)
 			return r;
 	}
 
-	return NULL;
+	return r;
 }
 
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
-- 
2.53.0



