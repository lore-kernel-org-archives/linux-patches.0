Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B29130E42;
	Tue, 23 Jan 2024 00:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969077; cv=none; b=YKYQFKUycq40hfMwfh2y8DEmMpQQFf4OehTTbHibaVFucre3ikKkiiOcnlM+zyUiFgP6TtEipSvoc12sd0BehIQm7ypUO+t8EWaAZ5vmS02TYD0M2s3nR8V2s4p40UUM0tuZZCZ21Onafqh5qdhopT6n5NHP81ED/MsiVoxaY7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969077; c=relaxed/simple;
	bh=dULWr7xxOaWxJCDI6HyY2gczX1XtrpBTdwpRopk+cWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiQQ3ySg2n+RFAuKhyN1JoB97oYDuclWpqNUaigEsktgCS8zTxsvaAGbvqJL0R53fzrAzJ9b122BgzJ7ofOvuX/xAqZpH8H9bQgYaDBBRvc76jdLQyjQyuwffodMI12Ql2HMl0AdaF6hCWzo1TP9fjRaNqVyG2ZyGdgsToKtiX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONVLf9pI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONVLf9pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D9EC43390;
	Tue, 23 Jan 2024 00:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969077;
	bh=dULWr7xxOaWxJCDI6HyY2gczX1XtrpBTdwpRopk+cWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONVLf9pIJ4QoyNv8SL5CslhxOVVxC1JWVFhz3BjuRiy7wA4POQ8QnruR/qatxAd60
	 gMXFxsyIvjQ9gdf8mkVjDKjJq1V7We5RZpB3TELPaK4uNKaottCrdqBsiq1hXuhqud
	 LpOwyUKJt1DVwmg1Rluzi9xVaIMJ6ZqWDitZvCRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/194] kdb: Fix a potential buffer overflow in kdb_local()
Date: Mon, 22 Jan 2024 15:58:40 -0800
Message-ID: <20240122235727.373597602@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f8f087193644..51cfb8618205 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1365,8 +1365,6 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		/* PROMPT can only be set if we have MEM_READ permission. */
 		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
 			 raw_smp_processor_id());
-		if (defcmd_in_progress)
-			strncat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
 
 		/*
 		 * Fetch command from keyboard
-- 
2.43.0



