Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988322F5A01;
	Wed, 10 Dec 2025 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352221; cv=none; b=vARFdrr8VCxRQBwPQJSOq7Dxzov7IDWHgXchGkrv+/C7jXjDPPEAK5zcrlkAw1F0rHv5Pw8FBk/ygG9KjggQSUxyIBHmFWNahb8YzMLftDYQA7/LK97FCyC498yqPfIjplgMfmZQJbDq4W6oP9qoe9JdXuZLv00G4fLpz+kvUG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352221; c=relaxed/simple;
	bh=MxwMokhJf6U475DQlI/KVnP91lHicjz4AnvkafD2+bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCNTl2rsvBGMZJOAsQLtT6nn/AfcP//SSicez1xCXCqe5yxPzrQK5IGu8/jGvcxBvYao2Gv3S5fdW5hT3sTZBUwrEiDao2o6Wf3/DqruTKkLylttDoUP1oYXxYwcM1hMGGAr96MrauT6NUkJybR/MIqeQf3ad7dInZKIdDsYSsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsLPIS3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsLPIS3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425E4C19422;
	Wed, 10 Dec 2025 07:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352221;
	bh=MxwMokhJf6U475DQlI/KVnP91lHicjz4AnvkafD2+bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsLPIS3xVIxkZrb0URQWQaZsuehZclimMXgEWIv87QEryQuOw4NA9EEarm7aF1yDe
	 3fKgJ0aPKex/+B6ATI2gFi6aPQfMBdSgnCQzGMRIb50TgThUPm5H3A8Q1GGDnKuwGm
	 ulCgPlnLxuZFkFb0Y787XffR9WgkHV3ibVlhi5+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.18 17/29] serial: sh-sci: Fix deadlock during RSCI FIFO overrun error
Date: Wed, 10 Dec 2025 16:30:27 +0900
Message-ID: <20251210072944.837838161@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 75a9f4c54770f062f4b3813a83667452b326dda3 upstream.

On RSCI IP, a deadlock occurs during a FIFO overrun error, as it uses a
different register to clear the FIFO overrun error status.

Cc: stable@kernel.org
Fixes: 0666e3fe95ab ("serial: sh-sci: Add support for RZ/T2H SCI")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251114101350.106699-3-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1024,8 +1024,16 @@ static int sci_handle_fifo_overrun(struc
 
 	status = s->ops->read_reg(port, s->params->overrun_reg);
 	if (status & s->params->overrun_mask) {
-		status &= ~s->params->overrun_mask;
-		s->ops->write_reg(port, s->params->overrun_reg, status);
+		if (s->type == SCI_PORT_RSCI) {
+			/*
+			 * All of the CFCLR_*C clearing bits match the corresponding
+			 * CSR_*status bits. So, reuse the overrun mask for clearing.
+			 */
+			s->ops->clear_SCxSR(port, s->params->overrun_mask);
+		} else {
+			status &= ~s->params->overrun_mask;
+			s->ops->write_reg(port, s->params->overrun_reg, status);
+		}
 
 		port->icount.overrun++;
 


