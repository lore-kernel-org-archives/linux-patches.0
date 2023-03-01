Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2CD847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B88C4339B;
	Wed,  1 Mar 2023 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694083;
	bh=6a3DvynJx1rcCiVsBUeKrX/q9oIIXrZvoeeCv9ukjyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQlRoKJKsN7tFTdWs6QCUXAG3H/f4BgsSZKYY+0Qe4gHgi7zWMdHhrNcF1WIr+8+l
	 MBaQGaSF4+8mwUTfILns4y2KsDQ9/aCf3ndBQaKA/nSUbR6FgncqKkAw6qsdxtq6D5
	 ZM9J1UFcyi5Kw/I6h4O7XkUCaCicMcFCljjUtIUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Storm Dragon <stormdragon2976@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 10/13] vc_screen: dont clobber return value in vcs_read
Date: Wed,  1 Mar 2023 19:07:33 +0100
Message-Id: <20230301180651.569971762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
References: <20230301180651.177668495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

commit ae3419fbac845b4d3f3a9fae4cc80c68d82cdf6e upstream.

Commit 226fae124b2d ("vc_screen: move load of struct vc_data pointer in
vcs_read() to avoid UAF") moved the call to vcs_vc() into the loop.

While doing this it also moved the unconditional assignment of

	ret = -ENXIO;

This unconditional assignment was valid outside the loop but within it
it clobbers the actual value of ret.

To avoid this only assign "ret = -ENXIO" when actually needed.

[ Also, the 'goto unlock_out" needs to be just a "break", so that it
  does the right thing when it exits on later iterations when partial
  success has happened - Linus ]

Reported-by: Storm Dragon <stormdragon2976@gmail.com>
Link: https://lore.kernel.org/lkml/Y%2FKS6vdql2pIsCiI@hotmail.com/
Fixes: 226fae124b2d ("vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/lkml/64981d94-d00c-4b31-9063-43ad0a384bde@t-8ch.de/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -284,10 +284,11 @@ vcs_read(struct file *file, char __user
 		ssize_t orig_count;
 		long p = pos;
 
-		ret = -ENXIO;
 		vc = vcs_vc(inode, &viewed);
-		if (!vc)
-			goto unlock_out;
+		if (!vc) {
+			ret = -ENXIO;
+			break;
+		}
 
 		/* Check whether we are above size each round,
 		 * as copy_to_user at the end of this loop


