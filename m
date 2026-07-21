Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7143ED3B2;
	Tue, 21 Jul 2026 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661702; cv=none; b=S83vLO1dGXoc1hJuXUIqa5PxcilE/cSIyrhMLRzvTD9QeCYp9RvDSj2Y/S7dzAc31e0SBATsPm09CDZvPSOavJeOqDil4zyl3XgGITc8xkc6t7Rwym70sRlFKpwX191VDdEC0SjcRNVq1YmkJhIHthbSE+McdSlWatRGWyX3S9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661702; c=relaxed/simple;
	bh=c6Bbt2VMHfVjphOJ+7xzJ76auBPXzwzFhHSn4zCPRcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9oj2CslreXJApHRh/cYVdeTp606kt7hOXIR5RqCBpy8WoBR3YtxhYW+xpOwL5OmhufsTZ221nRUMXdsGiswFPEv3abMn46v3AgN+6Kg7V3KMonctmquiLCqzbv2SsQ5Voca3YaiufxeC9LwFZw0LXW/xlEPv9GqvFJ0RJrapQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOIDazVn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOIDazVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A221F000E9;
	Tue, 21 Jul 2026 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661701;
	bh=i13czIZgx4WMM0y+2HjqtD4bH+1DI9p61exmq3CDYzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOIDazVnLGZAZyRtBcCY33LkwzIFOT36x0PzLqBVu3i5+x/m34+sbBfo4ex01Vzya
	 q8tlJvZtkyFEqLBVXkmrJTTl1eK4lHKnCaWhZ18u/shUHs34Ogz5vnFW9PleLZI8B3
	 d4QBGQyqqkvFUNlNDfIiL5ajFmIAIeokNiB7fAAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0165/1276] driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()
Date: Tue, 21 Jul 2026 17:10:08 +0200
Message-ID: <20260721152449.792741923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f9e6da99fe49277979798a1c3b9790ae10aaa18a ]

mod_delayed_work() takes jiffies, not seconds. Thus, restore the dropped
conversion.

While at it, fix incorrect indentation.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 48e0ae8892ded1..f84cbb900908e0 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -327,7 +327,7 @@ void deferred_probe_extend_timeout(void)
 	 * start a new one.
 	 */
 	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
-						 driver_deferred_probe_timeout))
+			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
 }
-- 
2.53.0



