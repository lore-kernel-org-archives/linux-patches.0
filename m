Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA578825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F751C4339B;
	Fri, 10 Mar 2023 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460171;
	bh=73WqWkbemJ/4jwqXMVJeNr8VP/NZehtBXFOoTemCbwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3oMDAWYxUXq2HsqqQYzbqIRYDZKM/XqOhGs+Jk3+cJcsIcppusJl4NKmIOjm1trH
	 v/wXS1tRgrKU2JPgNWQ8k1d2fFeMk0r7F9vRPVkYLq0mJmtU2hY1xbOU2HvXSVdppl
	 7n96IcJPbmXMKAAEr26aTonqzcxafG31xiI+9vLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/529] HID: bigben_worker() remove unneeded check on report_field
Date: Fri, 10 Mar 2023 14:35:59 +0100
Message-Id: <20230310133815.007647727@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 27d2a2fd844ec7da70d19fabb482304fd1e0595b ]

bigben_worker() checks report_field to be non-NULL.
The check has been added in commit
918aa1ef104d ("HID: bigbenff: prevent null pointer dereference")
to prevent a NULL pointer crash.
However, the true root cause was a missing check for output
reports, patched in commit
c7bf714f8755 ("HID: check empty report_list in bigben_probe()"),
where the type-confused report list_entry was overlapping with
a NULL pointer, which was then causing the crash.

Fixes: 918aa1ef104d ("HID: bigbenff: prevent null pointer dereference")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-2-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index ed3d2d7bc1dd4..b98c5f31c184b 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -197,7 +197,7 @@ static void bigben_worker(struct work_struct *work)
 	u32 len;
 	unsigned long flags;
 
-	if (bigben->removed || !report_field)
+	if (bigben->removed)
 		return;
 
 	buf = hid_alloc_report_buf(bigben->report, GFP_KERNEL);
-- 
2.39.2



