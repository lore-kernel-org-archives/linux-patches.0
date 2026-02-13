Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22E11684BE;
	Fri, 13 Feb 2026 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990975; cv=none; b=ssgo/862oWedgVx/CLIQL2FTx92JReU0JhBGeChrDSMw5c0SQLjJZVuEvRhno4+Rzk+2VYWgxMMhQKrjqH3jgA6NK9QgzpYXs4u81P7YAFXz+gej5HCczuc67Z8GiV0iwXUqdjC0y5rI+5er/3i41PxBtVWi48WflXc0Ahv+5YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990975; c=relaxed/simple;
	bh=YhfrCDGTEvKHr7dLmgEvI8/dpcxkuUND0/PlbWktHj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPBZyM8i95htspzg9HPHrzhNtoyZN8F1CXxikoYWcMXGXJyGvVSme2gPntqTklgJXHJ3iGmt/1qroR404Y3SxnolxJJoXvwxlAE/inQfPZOs2V5chnzpUtn03GqZLYhh28XCJQcHMKUYTPo7WkwWPZWxpFH/rhCSKo+tUORkitI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dm4KnDXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dm4KnDXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DFCC116C6;
	Fri, 13 Feb 2026 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990975;
	bh=YhfrCDGTEvKHr7dLmgEvI8/dpcxkuUND0/PlbWktHj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dm4KnDXomQ2xqdsCu06pVTnB4G3PwjtMc5FTVBKCH7D8ugsPMvZaL45lOk2s0dw1s
	 7rvvqrktPnj7efKzfCQ1BMY9yW2nho8FEHyrRXwDxh5/ZVM9YHeA6f+u/u7Vtyhr+E
	 ERAaaLxmomrXWvKI8HykxQYJs3fDsnvseVCgfWl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 07/24] crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
Date: Fri, 13 Feb 2026 14:48:26 +0100
Message-ID: <20260213134704.999303959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 5565a72b24fa7935a9f30af386e92c8c9dfb23b9 upstream.

OTX_CPT_UCODE_NAME_LENGTH limits the microcode name to 64 bytes. If a
user writes a string of exactly 64 characters, the original code used
'strlen(buf) > 64' to check the length, but then strscpy() copies only
63 characters before adding a NUL terminator, silently truncating the
copied string.

Fix this off-by-one error by using 'count' directly for the length check
to ensure long names are rejected early and copied without truncation.

Cc: stable@vger.kernel.org
Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -1336,7 +1336,7 @@ static ssize_t ucode_load_store(struct d
 	int del_grp_idx = -1;
 	int ucode_idx = 0;
 
-	if (strlen(buf) > OTX_CPT_UCODE_NAME_LENGTH)
+	if (count >= OTX_CPT_UCODE_NAME_LENGTH)
 		return -EINVAL;
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);


