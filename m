Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C0F1EB19D;
	Wed, 19 Feb 2025 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955303; cv=none; b=YwUPx5jsKXtYHZA9YF+Nrgtc/IEvMlrgpuOpm2EXWFAnE8fBefsWPFiEVwuDKbURXu1a6GfourPw23odQLejxtMQD8jB9RZ8he7PcUw/93qmqi7mG+h9Y2h4TLlgU9WTo38sjmZrbT+F+1ACDXQIAduIWnvShpR60WuLwygGVL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955303; c=relaxed/simple;
	bh=BMwTnMk3Y9lVonqGoFDMk2NX40so6AG0JxDZBiOIhJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3p+nWq1KEzzGcXD0CJfHQswoWoXKmirzyCtspqa98AnZ7FUXEhRtSe8FOaueRpy+QA1YtllxQJj+R5fFNNodqjywyICwT3LTpTvJsKrROs8YOT4Zn7aZVsCBZA3Ixi5l6T16zfxLKlEBDPpI7BcMsUmWucWU4ryugDQ6bVKBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ye3G2yiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ye3G2yiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A507C4CED1;
	Wed, 19 Feb 2025 08:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955303;
	bh=BMwTnMk3Y9lVonqGoFDMk2NX40so6AG0JxDZBiOIhJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ye3G2yiIzmJJjHITalqVSBb2b3gambDawQUE7+SKxfHsLtZsD83bXgsSa637MyCUF
	 6ZTiJPL+2m5s+Sbrwcx0O8huGZKJfQsrrfFf/tMfOk4iUjCji4He35BXcas3e72f+A
	 lPmS0MLqqEzCj9+o6DLUbZroGu7erHHWaawSlghQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/230] HID: hid-steam: Make sure rumble work is canceled on removal
Date: Wed, 19 Feb 2025 09:28:31 +0100
Message-ID: <20250219082609.288340310@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit cc4f952427aaa44ecfd92542e10a65cce67bd6f4 ]

When a force feedback command is sent from userspace, work is scheduled to pass
this data to the controller without blocking userspace itself. However, in
theory, this work might not be properly canceled if the controller is removed
at the exact right time. This patch ensures the work is properly canceled when
the device is removed.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 9b6aec0733ae6..daca250e51c8b 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1306,6 +1306,7 @@ static void steam_remove(struct hid_device *hdev)
 
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
+	cancel_work_sync(&steam->rumble_work);
 	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = 0;
-- 
2.39.5



