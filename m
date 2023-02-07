Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD7A2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7153FC433D2;
	Tue,  7 Feb 2023 13:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775180;
	bh=Z8wNkXhNV2I8A7muiZVNlEeBOypjQrLAsS7BVvnIryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixSqE3GnLUlAxbshtEOcAf3KrY9TdeL9yCWZsdavDZxFewF1D/YaNkr1sGul/GXKO
	 lReKl5The9Gsq7zHW+k5MmX4BgodtSkygIXAUUcUw9YARiXAThWl7nb4wzxZrGVkk2
	 5kq8M8VLNuJwacp5E0hr9mMrH0OSBuS5A89nXPzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	stable <stable@kernel.org>,
	Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 6.1 163/208] HV: hv_balloon: fix memory leak with using debugfs_lookup()
Date: Tue,  7 Feb 2023 13:56:57 +0100
Message-Id: <20230207125641.805621730@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 6dfb0771429a63db8561d44147f2bb76f93e1c86 upstream.

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Fixes: d180e0a1be6c ("Drivers: hv: Create debugfs file with hyper-v balloon usage information")
Cc: stable <stable@kernel.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20230202140918.2289522-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1911,7 +1911,7 @@ static void  hv_balloon_debugfs_init(str
 
 static void  hv_balloon_debugfs_exit(struct hv_dynmem_device *b)
 {
-	debugfs_remove(debugfs_lookup("hv-balloon", NULL));
+	debugfs_lookup_and_remove("hv-balloon", NULL);
 }
 
 #else


