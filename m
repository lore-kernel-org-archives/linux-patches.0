Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62E53D75D9;
	Tue, 31 Mar 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974263; cv=none; b=ACCljngd27PCkHCi3g/IXO+U7HHf3VDnzP24bswlK8l5/kQtdpwNElj5VJKSCGtycalQMYR3fKpmslQ9t2lckxgWS0ky6dmchyePM71Ke7MrLveBB+u8HAQ4kSo8ptrEYE9xmi/gn8N6etxvL8oc8duFo6uGKOiQB91SmXiXyjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974263; c=relaxed/simple;
	bh=tVYGE6ZWQruoOMT32QU9x0dSbzARHehzNiXzC38V2M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rskx6bkPvictWluPD6onQhJKGq7r6xSagckQDa7dkTAGibDkydBKjmndXMCYrm+DaH/jUrSWwQkxJc3N6C8IDrlkfc8ehoqklrLirbzguCZgIjkYltjmJwKwMGANnkIosp8dGozM148+UtQo6PUDrHStJSyOZ8OaemBt/sWsJ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaHnRBB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaHnRBB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71EFC19423;
	Tue, 31 Mar 2026 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974263;
	bh=tVYGE6ZWQruoOMT32QU9x0dSbzARHehzNiXzC38V2M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaHnRBB8tD2m6uHttlZzfquzr06edmYk1dkyzawcQEPFZIUveXMEf4soZNqOhP+Po
	 6b1oQYeHocowyFYuq1kWtLg+UVkI7hWST0ZYUHhzkvZZGCMsSqfEAK++mr5yHGClk5
	 Xwo+a97K2+SrMim2GjEDm0rAofomOVzQqoGsXq14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/175] HID: magicmouse: avoid memory leak in magicmouse_report_fixup()
Date: Tue, 31 Mar 2026 18:20:02 +0200
Message-ID: <20260331161730.452607198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb725dfcef196..d5df2745f3da4 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -967,9 +967,7 @@ static __u8 *magicmouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
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



