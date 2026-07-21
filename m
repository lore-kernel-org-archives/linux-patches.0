Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED046AA77;
	Tue, 21 Jul 2026 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649130; cv=none; b=mAyqglNEYg2NsxSt3/zxE5HlJmQiO/XEFT+4/2QldHgt2Xog4TX/rEtO+phYhnOPgMXZlJQHWMcj6kbpI2IHcp4XygmcF/gFXiNgsQJCnYFYC+n2MxUtUcUwI75XPi3UI5JcCT51H7Owrx4UxGKyp5foR/IOclEJCVrk9zq6yJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649130; c=relaxed/simple;
	bh=iFbBaWozj6A5opoACUEnviERo89L3CsNwrR3rcsER0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrWbLWuM+O5XnymRXBWmGbtiCXmNgrLHkhk8reyLiUExnoFPOaC25ZUIOl2J8cC6j4RMMiRdjndeto3GTxrFMHPUBAlXKyTjLJcluytXxLjSKKO8S7pWudrJKhc652zS5zA3QWOEuC+7DWTndoFptp2NJMuazR1Hm6GvHdr2Rtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csCbG2Sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csCbG2Sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B51F00A3A;
	Tue, 21 Jul 2026 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649129;
	bh=oojAkQy0Y9W1wLlFes69/52pIjpT9u1kC66Mj449tx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csCbG2ScbQfaBfsCWgkvh5qM1daa92xv0RdwZfUAdFc3425W9lSoCjn8hCkjUk+Xp
	 I1tuviX+/kqoSFsd54YjOtUWEKzCZseRXpHx7dcTSruKFJaH0685N/LbNGK81AVqg/
	 J4eyvMNkFsSUAUoDpJe2eKdE86PU+HtmyM253tsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0407/2077] liveupdate: skip serialization for context-preserving kexec
Date: Tue, 21 Jul 2026 17:01:20 +0200
Message-ID: <20260721152602.320045858@linuxfoundation.org>
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

From: Pasha Tatashin <pasha.tatashin@soleen.com>

[ Upstream commit 5eff62b051fbdb686e885c1468301d964f2e3d66 ]

A preserve_context kexec returns to the current kernel, which is
unrelated to live update where the state is passed to the next kernel.
Skip liveupdate_reboot() in this case to avoid serialization and prevent
sessions from being left in a frozen state upon return.

Fixes: db8bed8082dc ("kexec: call liveupdate_reboot() before kexec")
Reported-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://patch.msgid.link/20260527202737.1345192-2-pasha.tatashin@soleen.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index a43d2da0fe3e70..dc770b9a6d0539 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1146,9 +1146,11 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
-	error = liveupdate_reboot();
-	if (error)
-		goto Unlock;
+	if (!kexec_image->preserve_context) {
+		error = liveupdate_reboot();
+		if (error)
+			goto Unlock;
+	}
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-- 
2.53.0



