Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0F5140796;
	Tue, 23 Jan 2024 01:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972040; cv=none; b=QmV/O4T4wGY4eVqmVjhpO9AX5t2F1E8tc/EcNLqzDH4H02mHKHcyIPto2LTXxYgNeB9Xh93ttWE+og9u51Xx8q9XmyTu2YtOCSB6PRsQxn+XS1v8kGdOAvVK78mWn1CsbfBis9grp4UMvRyqsZM4wDbu7PyE64KgNFBx3L4GlqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972040; c=relaxed/simple;
	bh=4LVKt8jWSF7omSY/pFXmj2WW/Zw26btYAzV+Kmg28jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8U8GUdxoejwY7O4ilcTejTN9fI9FZb8LJ+v8rC+rrguqdnnW8YLsnyyn3fvqrpATfppkTdGVCGnB98RgQ+948wx1JwmaAxibMkdShDVUnksLeV/IRubE0ZUcKu11GQmZ0rRu8TRcduMQ+Jnk1kRHpprzHIfkeOcUeBn40mEPrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRLD2m/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRLD2m/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1581FC433C7;
	Tue, 23 Jan 2024 01:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972040;
	bh=4LVKt8jWSF7omSY/pFXmj2WW/Zw26btYAzV+Kmg28jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRLD2m/B8pGgHsexw2lsyt3//h9bSlZTG/B15LqeX2WU6PnzJy9AamxYMHsA9WGai
	 KVEZkwgFXeQ/PpBV5d6dDx/Ml063GsiHszelnAnwB7u2IP+LZwf3DZ+GO0tM1cTMqf
	 xUln12cEoySyckPqGRW2isggWPu13b61tyl0AsVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/417] kdb: Fix a potential buffer overflow in kdb_local()
Date: Mon, 22 Jan 2024 15:59:36 -0800
Message-ID: <20240122235805.834893734@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4f41d30cd6dc865c3cbc1a852372321eba6d4e4c ]

When appending "[defcmd]" to 'kdb_prompt_str', the size of the string
already in the buffer should be taken into account.

An option could be to switch from strncat() to strlcat() which does the
correct test to avoid such an overflow.

However, this actually looks as dead code, because 'defcmd_in_progress'
can't be true here.
See a more detailed explanation at [1].

[1]: https://lore.kernel.org/all/CAD=FV=WSh7wKN7Yp-3wWiDgX4E3isQ8uh0LCzTmd1v9Cg9j+nQ@mail.gmail.com/

Fixes: 5d5314d6795f ("kdb: core for kgdb back end (1 of 2)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 438b868cbfa9..35aa2e98a92a 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1349,8 +1349,6 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		/* PROMPT can only be set if we have MEM_READ permission. */
 		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
 			 raw_smp_processor_id());
-		if (defcmd_in_progress)
-			strncat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
 
 		/*
 		 * Fetch command from keyboard
-- 
2.43.0



