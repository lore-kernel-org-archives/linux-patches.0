Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9AF26E6F4;
	Fri, 21 Nov 2025 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731270; cv=none; b=luHeVdvo8NO5TjE+itBT/ZSUZkhwrYx7ZoMkXuPiuJntgFa3LtkpfvtyJD0bP2tLKWXCa+O6kS5AaA7vevi/mLJ2/D/pAccL5ywpa62EHnBTvS5yTHVrt5zTLVBJ6jTEufPOsbwQueuOd1LzucYqeT7INCJpR0CF4No9iRH+PPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731270; c=relaxed/simple;
	bh=yJIdz6Oov/kG6TWyzHMvZuO8SOtYrLa2qsM95yV2u9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3qIEw0FyzJktu+nr0ywQ4a5Sl6uQeeyBiA4VgUshmflvVkqkggKIFK+whtYDArJZaQXMZF1M0430ecIFAG46Q37qNfCdEIYXEQRPudxk5nrVZc/WrsOygaZeeqrkLJWxjEA0sH82+BQhOxEVxpdF5S+F6hD7ibvGb0U5OVcT0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0XOdgYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0XOdgYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6798C4CEF1;
	Fri, 21 Nov 2025 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731270;
	bh=yJIdz6Oov/kG6TWyzHMvZuO8SOtYrLa2qsM95yV2u9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0XOdgYVEboBJT+xFl0z4WMYbZ03Yzk5AMPKtruJWfv6usRPVcETXVqdN279qxau2
	 r4dQjDlEiqm5n98V4z+ID3sS76ISWQjiGlknKhNmXqD/ad7ySwjrmjT2/jbi+GNff9
	 qywrwWFWYJNyVzUzzFKj9to1p5Vfkk5SeNSOr3ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 148/247] HID: uclogic: Fix potential memory leak in error path
Date: Fri, 21 Nov 2025 14:11:35 +0100
Message-ID: <20251121130200.039279451@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit a78eb69d60ce893de48dd75f725ba21309131fc2 ]

In uclogic_params_ugee_v2_init_event_hooks(), the memory allocated for
event_hook is not freed in the next error path. Fix that by freeing it.

Fixes: a251d6576d2a ("HID: uclogic: Handle wireless device reconnection")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 4a17f7332c3f5..016d1f08bd1db 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1369,8 +1369,10 @@ static int uclogic_params_ugee_v2_init_event_hooks(struct hid_device *hdev,
 	event_hook->hdev = hdev;
 	event_hook->size = ARRAY_SIZE(reconnect_event);
 	event_hook->event = kmemdup(reconnect_event, event_hook->size, GFP_KERNEL);
-	if (!event_hook->event)
+	if (!event_hook->event) {
+		kfree(event_hook);
 		return -ENOMEM;
+	}
 
 	list_add_tail(&event_hook->list, &p->event_hooks->list);
 
-- 
2.51.0



