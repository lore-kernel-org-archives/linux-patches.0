Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CBD3C0607;
	Fri, 15 May 2026 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861265; cv=none; b=U9Is7UHk9Q6CrYo4CH47RqIb5YGp+N8z8Z+SpYmnG/3X66uW3ImyJneQubZOolIRAjDHF12MHvUfrMYkndRebclPBJOgCR5SWv3vI7bZcY5AIeLJD0kPZafazsb7N83CXPwVaKmAtsZAGl9jTfWvN1ogmiOxS3R/vVa7o7sO+hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861265; c=relaxed/simple;
	bh=FGRBV5LcqBmXg8Z/Z8DsZnh41nq/WeY9U03AfmYohxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrPex00D8CdiDgNJ/99c3tZB2VK2Rwrvvv4XoXHU8oiqLgxHJQl3zwnz1vTw/v3TyiSP0pGbqnhjoyXtG777Tc4+EAooHIafDzhUMOJjvtxofYG2yk1/DC0yfVyz2xomxTxZAInZyZeiJpvt93ilSe5Wvez3tC3IvdGYxdRorCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjgOcIb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjgOcIb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3076C2BCB0;
	Fri, 15 May 2026 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861265;
	bh=FGRBV5LcqBmXg8Z/Z8DsZnh41nq/WeY9U03AfmYohxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjgOcIb3Rs9PF/yFOZw4Hk75/YdmspFLdYiAQuJx8EhfwHcbU5elyqy3phvoeWaja
	 DaTNI8gvcXWpu1dayBx+3qB791Eelg/1Ab3+tLc0FTVbxmKifCFIIs67geYBReIhvc
	 pVX/2I3A+CFNZGRY66RZ974vYfx2bNLsuqnTtPgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.6 263/474] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Date: Fri, 15 May 2026 17:46:12 +0200
Message-ID: <20260515154720.693722694@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 9aa6d860b0930e2f72795665c42c44252a558a0c upstream.

setup_geo() extracts near_copies (nc) and far_copies (fc) from the
user-provided layout parameter without checking for zero. When fc=0
with the "improved" far set layout selected, 'geo->far_set_size =
disks / fc' triggers a divide-by-zero.

Validate nc and fc immediately after extraction, returning -1 if
either is zero.

Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://lore.kernel.org/linux-raid/SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3986,6 +3986,8 @@ static int setup_geo(struct geom *geo, s
 	nc = layout & 255;
 	fc = (layout >> 8) & 255;
 	fo = layout & (1<<16);
+	if (!nc || !fc)
+		return -1;
 	geo->raid_disks = disks;
 	geo->near_copies = nc;
 	geo->far_copies = fc;


