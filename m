Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33AC39A7FD;
	Tue, 21 Jul 2026 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658467; cv=none; b=XIscfRWgI8DB+r4jflX+ZMoxtjGZx1MOa6yyVdHufM/VJB68gPW/tAmtjMBU4Vq3FgYvIzBUYd5K+C2ejSXZmzVOIpXl7cLaSr8/DqbX53xcpeS4KzzpPvDZ8wF10tsvpMFhU6IBYpVYQwkrV5/8YsBO7SUAa6ofVWjcjpB6yvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658467; c=relaxed/simple;
	bh=rHhEXyOywRPEfp/jGZZeX7RvQP+GI49fMe1BJ0IaPbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puXNM1e+n08+gmT3q5LPksjwzoj3fE0KWwMj95FWyqkIBT/rxY0IKcfC/4xrl2PxTYYsPdZVBoNyf40mUHAi1/mTAc4KPIVfarSy6j/IkdOceRudvZz6Wd+y56EjRtl2jxaIzJOOGpgp1Nyf/nIh9P+CsKrdcXPwZG1wg8wEGvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqWnr8Z0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqWnr8Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6049D1F000E9;
	Tue, 21 Jul 2026 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658465;
	bh=TQS1nq2wbCz/tszWhXSHvPAKPSglcGIycONucpgNKMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqWnr8Z04QZRMlzZMWO7hqbPSX8iXAo+y2Eoq/BGzLtgBFyNQcayIqTtynmWGNNEv
	 GxsqQVllD9CBNRjbuAWeWpK3srRhNqzcTSZuyWDBew7MyNp2DO5oSfk3mUMP5r3VZ6
	 3/ehQGQtORDiAY9oiVP8O/OnYP0SzweR2DRBRyc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1152/1611] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:21:08 +0200
Message-ID: <20260721152541.332222288@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 033e56fed09047ee63072e9f58789f40c1c7079d upstream.

Due to an incorrect goto label, memory allocated for modedb and modelist
in uvesafb_vbe_init() is not freed in some error paths. Fix this by
updating the goto label.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1697,14 +1697,14 @@ static int uvesafb_probe(struct platform
 	i = uvesafb_vbe_init_mode(info);
 	if (i < 0) {
 		err = -EINVAL;
-		goto out;
+		goto out_mode;
 	} else {
 		mode = &par->vbe_modes[i];
 	}
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		err = -ENXIO;
-		goto out;
+		goto out_mode;
 	}
 
 	uvesafb_init_info(info, mode);


