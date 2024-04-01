Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2854F3D961;
	Mon,  1 Apr 2024 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988898; cv=none; b=jZyG3Qw0LOmjxi7TXjbQA+8cDrKzUkq1kJ6/KS+ogdk4dPV7J5hPrLAJuny3lL9zk3lRsiYJ5xYrOgj0qvDIEh/ByjbiiJC0VUMc3Cn4EWMNPFGKESLI9k9VtcJ3BX5J3by8+AD3t8O0AMI85ygP55eduWMhPge7tdQ6txAGvd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988898; c=relaxed/simple;
	bh=IvTe5IArURdZYNjl8W/Sjx4IdV+Ir+7h40dKFN09IeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G38VLmkEr57n+Z4rAtO4NLoQXrRbTyAYNp2EwwJxxesyQ2YItLGflg5Lg3VUYwMuhgvLHLwqjGZ095LUMYRjm9RYgKK8i+2xkwl9tR0+DdK/q8JwWUBJS79tOjzGgXLm0Cu7HHuX/MAhj6mzn1HcROs9TNaKebLL1mHx8Iy0OXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIxUvIKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIxUvIKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2F6C433C7;
	Mon,  1 Apr 2024 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988898;
	bh=IvTe5IArURdZYNjl8W/Sjx4IdV+Ir+7h40dKFN09IeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIxUvIKy+bP1nGPjVOV9ZT76565xn3VQ+eRaTcSgESu4/fdjX+X7UOEewQyg2VhiM
	 yB6PTmxpBQlmhIb5PKVPej1mhwyIaYb20N+CYLZxwCL9gLWRbk5eGzCF7tspL9R+/Q
	 myczZIU7FZBvr7jT/3HQ7gGLO8tEtqeWZCqEpVbI=
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
Subject: [PATCH 6.7 293/432] Fix memory leak in posix_clock_open()
Date: Mon,  1 Apr 2024 17:44:40 +0200
Message-ID: <20240401152601.908758564@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


