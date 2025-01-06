Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD67BA34;
	Mon,  6 Jan 2025 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179090; cv=none; b=Fqd/SP7lSHqjDqGmRR2HxVi2M3wwgl38z9HkTFmSDi3ygblyhiDs45d9xBr7+Wkuuma7RP82M//vi6lzt77DvUWjY8MKGzZw9+3YDhC3+G4nBvZvheLho69FE4kRfSGhsbmdlW0C+D1sSC2DAMFcTyNtM9LyzaeccAI4roOk2I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179090; c=relaxed/simple;
	bh=EAmOiryuQPwW7jQ4lsRlLWScH7rvh49fNTAgmwYRodg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHFX3drJwcCUKvnhGnne/8CzAwQrZ6BfTb2DUOGZzZ96Zpu5uVeQU189A5HYdKzeJqkCqs1d2GWLs/vExEdTYx7I8q2s0qdk+J4jUuU0u0njfR9/zkH5s4D8Ri+5YBhlOdszf6znYUpNT3o9t/Y1w+zyNBosNn1DcwtWgesWqrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZ5wv2mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZ5wv2mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62C2C4CED2;
	Mon,  6 Jan 2025 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179090;
	bh=EAmOiryuQPwW7jQ4lsRlLWScH7rvh49fNTAgmwYRodg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ5wv2mBXHzE0XEV8Ho2k4eZmBMMNkPF91NkD0r+o0116ZreOXa0YjC4S3qrk+z9r
	 3t2Ru8ivZNsV4oxO3BmXf9G5boGd85UgPduBqzqbr3N9UNpxBEa0oNIOuVawHRPckk
	 Z/lftolwVhXhvyqwl1cBzqqDWcvyTu15QM3Z6zhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 24/93] sh: clk: Fix clk_enable() to return 0 on NULL clk
Date: Mon,  6 Jan 2025 16:17:00 +0100
Message-ID: <20250106151129.616674515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit ff30bd6a6618e979b16977617371c0f28a95036e upstream.

On SH, devm_clk_get_optional_enabled() fails with -EINVAL if the clock
is not found.  This happens because __devm_clk_get() assumes it can pass
a NULL clock pointer (as returned by clk_get_optional()) to the init()
function (clk_prepare_enable() in this case), while the SH
implementation of clk_enable() considers that an error.

Fix this by making the SH clk_enable() implementation return zero
instead, like the Common Clock Framework does.

Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/b53e6b557b4240579933b3359dda335ff94ed5af.1675354849.git.geert+renesas@glider.be
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/sh/clk/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -295,7 +295,7 @@ int clk_enable(struct clk *clk)
 	int ret;
 
 	if (!clk)
-		return -EINVAL;
+		return 0;
 
 	spin_lock_irqsave(&clock_lock, flags);
 	ret = __clk_enable(clk);


