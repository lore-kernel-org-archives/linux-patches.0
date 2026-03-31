Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1023E423A62;
	Tue, 31 Mar 2026 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976357; cv=none; b=OgpYZWX/yUqkVrBPKyDraH3Cqexj8/X0pb61NmZOdg3NXD6JqyGqc0Tt4ZZKtX4JKnMp7w7uKsXmRQ8qE4UlnxfW+lWrWOkC1GjmjdprR5pr4JpGDwugpULqvM59aTOKHOXL1yTCwVKamrG/MJOZtPcE0m4jy2BvMEPf3yusfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976357; c=relaxed/simple;
	bh=AzU/cS4ZkHL8EDkKxYl/pNQ2/7ynCP2r4B9O3RinjJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l7cZM/XUHhwCbBUMMjt8WyZU5v6b6EY8d5vusqrP815DxRV6W7LQM8hdijXED9mBF4AYqK+JTrzTkT7S55k56u+P+6zrV70iAbzAKoXay7PytBiYH8q+5ZBvpZUPfCoKH4fC2O73+vh2Gl0dkujwXuKfsNmp2+oI/C1metXjY7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7Fqz9DJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7Fqz9DJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F46C19424;
	Tue, 31 Mar 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976356;
	bh=AzU/cS4ZkHL8EDkKxYl/pNQ2/7ynCP2r4B9O3RinjJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7Fqz9DJjUZ1zk5GvPRP8FbM/lAOKjm0iXfcOTRHdlfDl593GIUmJSNmxobm6pTjF
	 S9+k7TBAZxAbmx+Go7Eh/p7BNe0unE5Ho/tZDHNjMfewfgcZSXSg5oF93s2v5MGcEx
	 2JzhkOaWVXRmTWHBEwPfbTb52s0DTesA72OMVy6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/309] HID: magicmouse: avoid memory leak in magicmouse_report_fixup()
Date: Tue, 31 Mar 2026 18:18:51 +0200
Message-ID: <20260331161754.516736077@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 91e8c6e601bdc1ccdf886479b6513c01c7e51c2c ]

The magicmouse_report_fixup() function was returning a
newly kmemdup()-allocated buffer, but never freeing it.

The caller of report_fixup() does not take ownership of the returned
pointer, but it *is* permitted to return a sub-portion of the input
rdesc, whose lifetime is managed by the caller.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-magicmouse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index f4cf29c2e8330..9eadf3252d0dc 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -994,9 +994,7 @@ static const __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			 "fixing up magicmouse battery report descriptor\n");
 		*rsize = *rsize - 1;
-		rdesc = kmemdup(rdesc + 1, *rsize, GFP_KERNEL);
-		if (!rdesc)
-			return NULL;
+		rdesc = rdesc + 1;
 
 		rdesc[0] = 0x05;
 		rdesc[1] = 0x01;
-- 
2.51.0



