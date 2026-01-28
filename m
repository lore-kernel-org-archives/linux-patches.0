Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D513B7A3;
	Wed, 28 Jan 2026 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614293; cv=none; b=C/XHwUBTk30TYkmcxBFUBaHTnFmX5PdzKIFQm22Xka6ZoKnKMDfV5Mgs3hWZ4MUSNFYGxOAMNVH29fIm7WSNULKh7UaaZsdpqqM/eJeujEgsFhjpnr5pcP+3BxIFE7lGzjYqkg35sQIktdDQHs+YPFY8C6Qk16plh1olxdtCz4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614293; c=relaxed/simple;
	bh=hxqO7FpZgOt4+RjxXmhQyM61cs0QE0a/7AfB5qe4P0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLI1M2puweQhEUnEWLAHyZg/QFfFTki9806Q0GDNaltGPM35qhfcKLfAlMYs1DhykG8QD/H9Q3aLfKgJVxhRiWxMDCFaYqwOIFqbHBqRIE8fYAZr5s52LB1HmuZTfu/K68KrAAPB8nZDaZcomSoDS0Qti2NBLzUEjHEn44Lipcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBZYXGdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBZYXGdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36CFC4CEF1;
	Wed, 28 Jan 2026 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614293;
	bh=hxqO7FpZgOt4+RjxXmhQyM61cs0QE0a/7AfB5qe4P0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBZYXGdw36AtHEOhrDukAR2Zdy6pxn5bUtHg7MplhhDbLKbbp8q9PFKev6WV1BFzh
	 50mVBH2GsP00SGJl32KQxFqteaz1bw0SYNX1D4H2SbqvAE0tf/7J8t8E55isatc/Ot
	 kAAAjAb2XxKIM85t+RRRvsekufvuYaQwPnzBjQ5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/254] Fix memory leak in posix_clock_open()
Date: Wed, 28 Jan 2026 16:21:08 +0100
Message-ID: <20260128145348.138420769@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 5b4cdd9c5676559b8a7c944ac5269b914b8c0bb8 ]

If the clk ops.open() function returns an error, we don't release the
pccontext we allocated for this clock.

Re-organize the code slightly to make it all more obvious.

Reported-by: Rohit Keshri <rkeshri@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Fixes: 60c6946675fc ("posix-clock: introduce posix_clock_context concept")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linuxfoundation.org>
Stable-dep-of: e859d375d169 ("posix-clock: Store file pointer in struct posix_clock_context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-clock.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 706559ed75793..a6487a9d60853 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -129,15 +129,17 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 		goto out;
 	}
 	pccontext->clk = clk;
-	fp->private_data = pccontext;
-	if (clk->ops.open)
+	if (clk->ops.open) {
 		err = clk->ops.open(pccontext, fp->f_mode);
-	else
-		err = 0;
-
-	if (!err) {
-		get_device(clk->dev);
+		if (err) {
+			kfree(pccontext);
+			goto out;
+		}
 	}
+
+	fp->private_data = pccontext;
+	get_device(clk->dev);
+	err = 0;
 out:
 	up_read(&clk->rwsem);
 	return err;
-- 
2.51.0



