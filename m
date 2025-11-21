Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B51836D4F0;
	Fri, 21 Nov 2025 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733515; cv=none; b=OemNkBtXsk4HGVAZ/UtPJb5djAcvSYthUdUjhH/Dm98OH7tXKEUW2sN4zGcBuQRvwp2IIqt33sX/Gyy44ws1dzDPSvFWUH9L+Fid+rExltZydlCPjsEpcD5pO5NRd4P3MX5V7Zb7ymgS2YWC5antsbqRMlOvNZrrw9fLhHBQuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733515; c=relaxed/simple;
	bh=nN/QeJhsYJLcBvnSVUiUnsyDKCLTtCghGeBwdXD8xjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHlNWkl1tHjT02XF7wAR2XIBtjqziNA8nCeDZmU49eJAf+kklR90ked6HgS7SdlTNbdvlGVxFRJjDDNClsl/Sbqlv8LyhcYlFPB0sHjjTcmDmdD5jIoZ+AiBNviB7uejLsn3yq64PTuplAynjLRMWz8HiZ7tOrsuO+Ttjy02+b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sFK7O88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sFK7O88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF038C4CEF1;
	Fri, 21 Nov 2025 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733515;
	bh=nN/QeJhsYJLcBvnSVUiUnsyDKCLTtCghGeBwdXD8xjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sFK7O88fxXdQHhmBIOtqIx4LsAWG340KMBXVfkErqT+YulrgMbIRR2yD4EtV/wA8
	 3mT1QSxil3hKrMBug2pXz3e66ORQXwwoMgJFnOHCPWmy0P7I3bOIhkYOd4QaNtblun
	 NoymFhsElIWlXVFg+GQ3NaMLbSpFnG8+UgMav9Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 461/529] HID: uclogic: Fix potential memory leak in error path
Date: Fri, 21 Nov 2025 14:12:40 +0100
Message-ID: <20251121130247.414028628@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9859dad36495a..eee05d668e361 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1364,8 +1364,10 @@ static int uclogic_params_ugee_v2_init_event_hooks(struct hid_device *hdev,
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



