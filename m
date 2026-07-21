Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA8C47125D;
	Tue, 21 Jul 2026 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657519; cv=none; b=SbCugZ9D527wpXwqaySISS9gL3tb2VQ40hPWycXt/MJ4MKzUlF6374yJrL8jOF2amLGVd2EaWz1D2f2EqTq5POXYPsDsDYzO/17Ysakj7aCElFw1silVJkkWSTVTHHjQj5YgZpqQFx8x39HIbNDJddvq9QOFw8B2JZnL4lB6iRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657519; c=relaxed/simple;
	bh=cXZsXHx1tJS8usAilhCgdt+FZO/RNXsLlTuV9xbomsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifZJzoBJYR45mZksprove5vvq+pDrwkPoAlo8NhXGFtJolh1PlARpQe36u9H+2j8UUbqrs9OFTL4DHPTyUGJDEmtBmAq36qtm6NLaS5JvgM/GELBI2+47p/vgakdCAiIfq1GXVz/7SbLGmwteHZiQNdoWfWq1KT4Inqyzp4Nkok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXJ4LcPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXJ4LcPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD6F1F000E9;
	Tue, 21 Jul 2026 18:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657518;
	bh=ThIEEEtBxGMxOukIXaqyU+sow+29ptb58rDyNBU8zGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXJ4LcPUvpUABoXH74XwrV7DK7RQEygNaXxNZOdKDkfHs1HgJUxc6WdjVNu/zJhwK
	 ezXLRIK4U0+awcfJkNQAVouurrT0BtHcdXHk01APUv4ayRSgRf7jHufxQqOav0lvW+
	 q/w7sr6WPdwj3psVgRtos0UpRd/cRGsg5xDHdh0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Manuel Diewald <manuel.diewald@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0742/1611] apparmor: fix NULL pointer dereference in unpack_pdb
Date: Tue, 21 Jul 2026 17:14:18 +0200
Message-ID: <20260721152532.066383016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit 7681ca43d2b1c776e62fe77e3167835fb1ab8319 ]

pdb->dfa could be NULL if unpack_dfa fails, causing a NULL pointer
dereference.

Fixes: 2e12c5f06017 ("apparmor: add additional flags to extended permission.")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Manuel Diewald <manuel.diewald@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index b0e18dd8d512bf..3ae58f476c0817 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -804,7 +804,7 @@ static int unpack_pdb(struct aa_ext *e, struct aa_policydb **policy,
 	}
 
 	/* accept2 is in some cases being allocated, even with perms */
-	if (pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
+	if (pdb->dfa && pdb->perms && !pdb->dfa->tables[YYTD_ID_ACCEPT2]) {
 		/* add dfa flags table missing in v2 */
 		u32 noents = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_lolen;
 		u16 tdflags = pdb->dfa->tables[YYTD_ID_ACCEPT]->td_flags;
-- 
2.53.0



