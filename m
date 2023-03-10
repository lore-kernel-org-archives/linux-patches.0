Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B466882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5565C433EF;
	Fri, 10 Mar 2023 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461327;
	bh=cLpGKzR9oXYwKmGmS61ejIZhP4XCNmu/Ru+Ow1oZKpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUYBV63UZlbeD44+jdDZb2B02vdV09gc3GOKqSddS0oeuleiyqUk8Q4qfOGNROjud
	 dXv8Q+0JITQrXp4Cyyfdt18fGhpe1e/wx1AjigSAyO3qjgsmb9vHHh21LoS0xYzFAE
	 28G8eqpBsV0GJuNXxirHgcytaKtBJXOJMTb8Xoi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olav Kongas <ok@artecdesign.ee>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/136] USB: isp116x: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:43:43 +0100
Message-Id: <20230310133710.207388001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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

[ Upstream commit a95f62d5813facbec20ec087472eb313ee5fa8af ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Olav Kongas <ok@artecdesign.ee>
Link: https://lore.kernel.org/r/20230202153235.2412790-6-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp116x-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 8c7f0991c21b5..9c3e12f2f25d8 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1206,7 +1206,7 @@ static void create_debug_file(struct isp116x *isp116x)
 
 static void remove_debug_file(struct isp116x *isp116x)
 {
-	debugfs_remove(debugfs_lookup(hcd_name, usb_debug_root));
+	debugfs_lookup_and_remove(hcd_name, usb_debug_root);
 }
 
 #else
-- 
2.39.2



