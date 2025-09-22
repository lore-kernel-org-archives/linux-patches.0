Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0C318C2C;
	Mon, 22 Sep 2025 19:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570437; cv=none; b=jElswmjcaYdOfoP4T5sn2T7icy/+SBqyZwWxTrIwP/BVEjANZPyj+MS3dt2E8vtB5sctCjlh0hfREUZiLCWQu/i39B8uU1plb+tLUw+t/lGl4XvYPTWl8bU3+02+9MuZcZY2GQZyx/X0IhPEHr6l1pXWRbavA6wy2JLNJsDj9E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570437; c=relaxed/simple;
	bh=UfIFKshORhP2k0smGebIyWy/HGFjtrYqYwPi4q6kJEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgQdR/wqIv+RBnuOrb+n1eDav/IChw6MvbFwejwTGGL5USBJ3Lz09b02LUugtkZ+AaWETfxsnhvQeDS3UalPQBtiE3hmAYDVeSEge2kZI73PFW38j+vnW/VvP8C20TuXVo6e+lEBXFPvFC3TdvhPLVBz2atFuIyDC+djGwRaqGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0fzUUtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0fzUUtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143BDC4CEF0;
	Mon, 22 Sep 2025 19:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570437;
	bh=UfIFKshORhP2k0smGebIyWy/HGFjtrYqYwPi4q6kJEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0fzUUtQ09NVcRE3R+AGIz4zLuKJX6VPSYNQtB4whx/cuf0rV7NzFBv2ZUiAowifr
	 wIGp8e0FarAGd5q0xYn31sNYPS34ktN2wlszcRFNKJBkhiaTJ1dGTDICM+HMq+xSDN
	 ME8Jc7lEA4Aba0KAUwM7IDhxRjp97kHX6mZM2AjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 149/149] samples/damon/prcl: avoid starting DAMON before initialization
Date: Mon, 22 Sep 2025 21:30:49 +0200
Message-ID: <20250922192416.625657803@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit e6b733ca2f99e968d696c2e812c8eb8e090bf37b upstream.

Commit 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash") is
somehow incompletely applying the origin patch [1].  It is missing the
part that avoids starting DAMON before module initialization.  Probably a
mistake during a merge has happened.  Fix it by applying the missed part
again.

Link: https://lkml.kernel.org/r/20250909022238.2989-3-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-3-sj@kernel.org [1]
Fixes: 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/prcl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -124,6 +124,9 @@ static int damon_sample_prcl_enable_stor
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)


