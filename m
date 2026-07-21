Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E5C2EBB8D;
	Tue, 21 Jul 2026 20:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667282; cv=none; b=DpAxZV1+SS5BMiQPuBdkSY5vzgkYxXo84kDeqAz1v3x93eVXJsFhOV0Fa+lkRF9ZbvUUZdSksAQ4ipNRAXTQdffLLi7wfD2TIbvBktGUo8MeQuhYK+Tkk17goHgwn8dsPsbJlAXKs4v6r1lG5IhyfnFBJdSFGtsfEX3jKP9rkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667282; c=relaxed/simple;
	bh=E401O+OcOzmQKC1BSLPVXw6mIc73LLTS/3DrwgFxQXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZ1i4t9bVI/O5OdnGdGDUP7MwMvcd1uTvkKL6cByFe7tfZ9BuWh50lxZyhNxra+yyz3nZHWTjC2iu9MEy0yQguQaV/ZPj0/+5Ue9lSwy1CAMiTuao3/DVLIMLcaXUOHSGk52KBwWu7Wjs+9yUhDIZuAU/OKai7wT2CywVZAQysU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBCff55b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBCff55b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97D51F00A3A;
	Tue, 21 Jul 2026 20:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667281;
	bh=fbpMbDgjl5JfUARHmls5MrXncKdrEG3QpDIiPho2fSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBCff55b0jPXaDe4/TGdNoW0ULx/YdAIelfIBtqKpwvjVoCUh40ngX7EicF72zlzt
	 2b4JMBUSsZ/P/avSTn64G7ngw65taMEhNOQMJ7R2/kweKF53R5l2iWBasGYRMooNVP
	 +AaDPXIYFp4p0rShOBfNF2h0tIoJpyc6vMDsPWVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 1001/1266] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:23:58 +0200
Message-ID: <20260721152504.229282716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@rulkc.org>

commit 8507c2cc9e4fa402401819f44d1e8a5ef4d11d8b upstream.

'cs' here must be in range [0:nanddev_ntargets[.

Cc: stable@vger.kernel.org
Fixes: 32813e288414 ("mtd: rawnand: Get rid of chip->numchips")
Signed-off-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -175,7 +175,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


