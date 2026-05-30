Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5533093C6;
	Sat, 30 May 2026 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158996; cv=none; b=FPs/v0sWRQxMwabeSiqnL/iac4NtPM6CJXZRR7jOrqvJ783euEemgrlurho8GJats40b+0K20niWHC+LeXrU5J4pXHjKvbRdnVRaX/1sF4NASXZs/rzdZfMTNtkN628xqL+jJwj/Sbccv7Ex5BRo+pgd51UXP6o8RK30/pgJTXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158996; c=relaxed/simple;
	bh=GfCuQnNKNquGTdJMbNEcCBBl4kCzzgsQ+S0POgZVUYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjcO6BkOPhKzl1BVneMDg9fWRIXLt3MJqXgOdyn/0M0mpni6MCp6G+Mnn0vX994TIxGSjF9SH9JSzyD3QVX4g8FSmQ1krYL5sLeLgipAoDAN4CnIEzHzj+BmkwCZ9Lpovp/pchQf2NxWGDlU2EsKnHxSmv9yW0aKLy04nQfZIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDn9PBOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDn9PBOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262C11F0089B;
	Sat, 30 May 2026 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158995;
	bh=8QjAjGhXbQ0txqpz0h15e323jtzwg4SqUjl6I49QhkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDn9PBOzs//WjsvKDB3Q9mpFCga1aiCxkuXWonQYy6KO24+11NIliz6+t8GErAEUb
	 Q7JXHk4VDtLJK4zR58HgjsMfqXZwyq57OsfYhGrGjaiE17p0PQpF3exwO2izsre6F2
	 rOt/J6im8nSLb6+rXMIEp8+8ZLd7AXSFafAAbsZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 066/969] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Sat, 30 May 2026 17:53:10 +0200
Message-ID: <20260530160302.203946733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f98b81fe011e1879e6a7b1247e69e06a5e17af2 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Helge Deller <deller@gmx.de>
Assisted-by: gregkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -496,6 +496,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


