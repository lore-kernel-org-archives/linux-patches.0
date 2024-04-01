Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4EB1CA8F;
	Mon,  1 Apr 2024 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987313; cv=none; b=CXgYvV2dY7ed8xApoWN9euj7EQsNkM2hbMei7t//nVWFyX3nnklIy7aFidy+Q2/hyYcWExZNo98G9NbNYdsfgvW83EtnNQF5HxHpWZFuAgeU+lFSZtq44hQ1HyZrhET4HzWnbwuDHOJFs33I7d1icDiICLQKhpy+iKT0UVWpUbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987313; c=relaxed/simple;
	bh=vwdMGU5u7oAp1EnTLn7cmsbe0wE/DGM4ZoIqbikCL1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb8rvrErjaTBCuc4UqWFhskXg8RTilBC/7X4xtdm7GY4LfGZOz60jOmEgXf6BZBJ0/ovQnd1XF0F3ytaHoAObxqeCodTCNMxQ+EaYg2K85C0bi+aQkKcOgg2/1zVkCsNf0RELMYYk7nr9ipPPVEJFcVDKx8DDVrlnn+HznvARrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tT8l5YwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tT8l5YwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D88DC433F1;
	Mon,  1 Apr 2024 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987313;
	bh=vwdMGU5u7oAp1EnTLn7cmsbe0wE/DGM4ZoIqbikCL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tT8l5YwU4t0G/G1JXdoLrg9QekfmbH5nXzR+rXtK22PticGLbe5q94YoTX75mx0hV
	 uGyIt9cqqUG7tCSv/bqQVBiSa8RpVNmBmK0HlFnBeaM7YLr7qX+ICCzhahoKrdYYUj
	 Nfo9w2biyAataPIlTRYlNPSbzIYJoenhstLuIh90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [PATCH 6.8 249/399] Fix memory leak in posix_clock_open()
Date: Mon,  1 Apr 2024 17:43:35 +0200
Message-ID: <20240401152556.603032606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5b4cdd9c5676559b8a7c944ac5269b914b8c0bb8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-clock.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -129,15 +129,17 @@ static int posix_clock_open(struct inode
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


