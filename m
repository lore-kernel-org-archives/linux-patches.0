Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3A2192D83;
	Wed,  5 Feb 2025 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767099; cv=none; b=eEmdP4Wf4VDeUZxuQ5XOFXC3kIxwbG1hNgYEbZ+sGiymSZsQV7pR+TnB2IZMVU/8yF3AEAtcXJkfsn3guUFpusv1o9nXnoF+oihLDBmNlbeZ3ACW8ADj15D7T0c1ywCI10A4mqSdM+0cFKO5KRN2/j147Xq5LykLy40kTYfJc98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767099; c=relaxed/simple;
	bh=eaqoMV9Y3NzVGb32II8kXTki+MNXs86a/CYtWaBmt50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOLz4EnxJy38MPcAyBVyvcGRqPLXronWZxL7bhg0WNeaCtvPkGX57StNkJ/9oEXopmVWweAFGEKqI1sMzd9WgYAjOJYXLK/SHxHYwarI7g2HT2uow1+lC4cFk+p30Rthw8oS6ti0G3pN+z3fZBSw5tZPa5LIV+Mp+mixPYN4DGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLxRck+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLxRck+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4B7C4CED1;
	Wed,  5 Feb 2025 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767099;
	bh=eaqoMV9Y3NzVGb32II8kXTki+MNXs86a/CYtWaBmt50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLxRck+FG261zVLje2ovsNaEO8z4cxo95+as0+ORrHYnNNd5/rZ4mrkXsJzqfL6F5
	 ZvycspIqqICwjXxcbrNU4nP0niOiVJm8c7Fhrbos1TFHE12VKlo87kieAB5lBWjavr
	 c4rln5KVvqVA7jKMCGJU0rMqfH4gsfzybVyIvRdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 406/590] media: rc: iguanair: handle timeouts
Date: Wed,  5 Feb 2025 14:42:41 +0100
Message-ID: <20250205134510.801872030@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b98d5000c50544f14bacb248c34e5219fbe81287 ]

In case of a timeout the IO must be cancelled or
the next IO using the URB will fail and/or overwrite
an operational URB.

The automatic bisection fails because it arrives
at a commit that correctly lets the test case run
without an error.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: e99a7cfe93fd ("[media] iguanair: reuse existing urb callback for command responses")
Reported-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/66f5cc9a.050a0220.46d20.0004.GAE@google.com/
Tested-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 276bf3c8a8cb4..8af94246e5916 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -194,8 +194,10 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
 	if (rc)
 		return rc;
 
-	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0)
+	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0) {
+		usb_kill_urb(ir->urb_out);
 		return -ETIMEDOUT;
+	}
 
 	return rc;
 }
-- 
2.39.5



