Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B514E7802;
	Wed, 30 Sep 2026 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787375; cv=none; b=Phuh3ebQfSEK8yREaRJdidfGPdJavSsOPemB8kleSzGzfPj/+1NHsb0kkhRJazy+TrWHbbIjfO+IoT+zTuRRWvnJLxaDJN3Lr2ZabcpLRLHUDiFCJJVy8yDr8/TNrSqUeM2RF6XIgPwSEGFBIOk5zEWOal8aqSHaOF4VSHmWLGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787375; c=relaxed/simple;
	bh=Um1jy8M1HhJDtzfWcTsYjMgCk0V9U7cDAizvpwAlXJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWREV1SuhZO/sQqz+uxIWBBHZtVyaEyiR2pfvwffD8jKPZluy0PE2kJMC82uV+5+QkBNCzVwt+lwu4tuggVWTsbyziNIOwWpO8EvDsr8ckrhKzLR1soktDHvNdja+pFOesmvKyobgX13tGDUql6R9V1kCdINI92oY/0rSolTjLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsC2Jffq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsC2Jffq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF841F000FF;
	Wed, 30 Sep 2026 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787374;
	bh=+D96SvDnNAfVS+vra80EG3huTJ3ZpzkYQ3G1cSIhogc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsC2Jffqq8CXjxcWbuLF5XKbuUUat6U7PYmGx/PFwqzpbCbQZaLpTkwBY+Febr6u4
	 Yw7V15UgNj9MkM3h/BWK1yVBXUaGXVNXdY7i59sg1SBaR9OPdpPd+FD03lCdJgi4U5
	 onfzHe5DtfXynJAXWPyy5mbIlPLqC4ENwohNmu9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 153/457] firewire: cdev: fix back-transition for iso_resource_auto client resource
Date: Wed, 30 Sep 2026 17:24:18 +0200
Message-ID: <20260930152349.352876833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit c6b51091cafff9ce6c03c1416aa13864d17ab97c ]

The todo member of iso_resource_auto structure represents the state of the
client resource and normally transitions in the following order:

    ISO_RES_AUTO_ALLOC -> ISO_RES_AUTO_REALLOC -> ISO_RES_AUTO_DEALLOC

However, concurrent access from the work item and the file descriptor
release function can cause the state to transition backwards from
ISO_RES_AUTO_DEALLOC to ISO_RES_AUTO_REALLOC.

Prevent the back-transition by checking the current state before
updating it in the work item.

Fixes: fcabbf40fae5 ("firewire: core: move allocation/reallocation paths into specific branch after isoc resource management in cdev")
Link: https://lore.kernel.org/r/20260922132639.191593-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-cdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index e49d8a58be09e..664952a67a11a 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1397,8 +1397,10 @@ static void iso_resource_auto_work(struct work_struct *work)
 		} else {
 			// Transit from allocation to reallocation, except if the client requested
 			// deallocation in the meantime.
-			scoped_guard(spinlock_irq,  &client->lock)
-				r->todo = ISO_RES_AUTO_REALLOC;
+			scoped_guard(spinlock_irq,  &client->lock) {
+				if (r->todo == ISO_RES_AUTO_ALLOC)
+					r->todo = ISO_RES_AUTO_REALLOC;
+			}
 
 			if (channel >= 0)
 				r->params.channels_mask = BIT_ULL(channel);
-- 
2.53.0



