Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C87E8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DD3C4339B;
	Fri, 10 Mar 2023 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456909;
	bh=ud9bS8BBNwLLLwu18K43YklUIaPteLlRkmPLAfIeqBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfBQQvI2OwbFIQvFRBLvmB+LBzcBTendduiELXkVELA44YibLeQOkSr9w1+6/2yBC
	 7RhHYxiEnNYb/5mR1HRYMVdDSBEphA9vS1nwngFgmLYPR1CyTrCdIu9btTqORRmCkx
	 n9HEE2K0gg/v4AByZ6p4enOK5KzDwB8oD6FhIR9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 166/211] USB: gadget: lpc32xx_udc: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:39:06 +0100
Message-Id: <20230310133723.839036650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

[ Upstream commit e3965acaf3739fde9d74ad82979b46d37c6c208f ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-10-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index cea10cdb83ae5..fe62db32dd0eb 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -532,7 +532,7 @@ static void create_debug_file(struct lpc32xx_udc *udc)
 
 static void remove_debug_file(struct lpc32xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(debug_filename, NULL));
+	debugfs_lookup_and_remove(debug_filename, NULL);
 }
 
 #else
-- 
2.39.2



