Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC9129A1;
	Tue, 17 Feb 2026 20:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361193; cv=none; b=GqLsY61SWj+5J+CcslmG4QL0xGdf9DhD6vbI8hV0G3pH4nRxg6QLMTO/tFsg98rhieDQFYfwhez4IdMqy5XxfL0MEFGHxu0rFwcMAlFkKZMcW3KhhPovXn/0njPoB9vftxBQ0bt14wOgR7U/IBJAdI3XPh/xdyMB6KhuJlmYv7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361193; c=relaxed/simple;
	bh=MmUrVW4O9PNYsaDu3si3+uxqzfkzrTDyYeVOEQyMgW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI/2trHiRXMhDabBfdIOLJ+K04pQGn8xdiSHcbFhhNOkpacFSKuZ63RuA1zvzuQNL9fSzeFq0wCLBF3KrcLblJeYOyLdP8E7W+JagZ6IB5MSJm/ugB3fzPF6K7Fn2ARWNUu6bwgoGhuWXKC8qHvwhQsoQZPPEovQwsC+h2Qdkb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZlrguF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZlrguF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68D8C4CEF7;
	Tue, 17 Feb 2026 20:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361193;
	bh=MmUrVW4O9PNYsaDu3si3+uxqzfkzrTDyYeVOEQyMgW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZlrguF1TkOCQkGcz+SXCiGsFR9fC0/GWRujhjmclPezSmG9hsYUvCp/Ojuum0Do2
	 z+vWUe7SOFN+IWWJ7L7BYisMUodk/NmNDBXyan8Z7+dqot0Jzor3/IKtrAYkuRFrsC
	 lIocWNsS7yxm1z1AajNqXGMmAkRSxCbAOuB6IDNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 04/64] crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
Date: Tue, 17 Feb 2026 21:31:00 +0100
Message-ID: <20260217200007.674285368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1337,7 +1337,7 @@ static ssize_t ucode_load_store(struct d
 	int del_grp_idx = -1;
 	int ucode_idx = 0;
 
-	if (strlen(buf) > OTX_CPT_UCODE_NAME_LENGTH)
+	if (count >= OTX_CPT_UCODE_NAME_LENGTH)
 		return -EINVAL;
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);


