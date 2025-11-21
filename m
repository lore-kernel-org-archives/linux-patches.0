Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68B34D38B;
	Fri, 21 Nov 2025 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732673; cv=none; b=Wwkpdn5R6CwV7IvXlArdYL7D4M7deECRqK8J4mUX48egwF4jGcOBAKaIVpV2JQpJI1p5Sb7JMhQyqD4hrmdlNAaOJ1p/gBzy8rrxwaUKgrc4NkwwD5EbT0npTPe3sA2yOjNxVFu5/nWLcspVhXKlk/mFDk7uFoatP1JhUylNmB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732673; c=relaxed/simple;
	bh=e/A1LD50kYn3V7XY13x3xzpvReYxObL0tHiwuwYe3s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB96N1TsTEPzMCrZZfAK0J/gAks0vmpmGbmguAu0kmX+E2SCTCKkQaEpWRGBozjwxqH7CR1nTrUZBSoEzTWp1WVHSgHtkWFWKc9gqlEdpKOPyLrMwwfg2ShOWIhIfi0Vl9q1is5ED1tV8rU27hUQYis+SDd7jaXTo40TpvaFhLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKh5N91b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKh5N91b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A04C4CEF1;
	Fri, 21 Nov 2025 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732672;
	bh=e/A1LD50kYn3V7XY13x3xzpvReYxObL0tHiwuwYe3s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKh5N91bGSOwhJYqgV0x0viitj3iA5JNMeG6XLQzD4LNGECoWKh4IJLEMJuweaOG5
	 f3o7tBEM7rtNYTbjVVzU3XLLtCOZ3uhWK/fMJC5GxQjw11NMxa+qML3Gwl48oOQWk3
	 mjYExKRI7rxCNl+j3hWqSQ9Uoh2WPxHCtfLlw3xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xion Wang <xion.wang@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/529] char: Use list_del_init() in misc_deregister() to reinitialize list pointer
Date: Fri, 21 Nov 2025 14:08:21 +0100
Message-ID: <20251121130238.204664322@linuxfoundation.org>
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

From: Xion Wang <xion.wang@mediatek.com>

[ Upstream commit e28022873c0d051e980c4145f1965cab5504b498 ]

Currently, misc_deregister() uses list_del() to remove the device
from the list. After list_del(), the list pointers are set to
LIST_POISON1 and LIST_POISON2, which may help catch use-after-free bugs,
but does not reset the list head.
If misc_deregister() is called more than once on the same device,
list_empty() will not return true, and list_del() may be called again,
leading to undefined behavior.

Replace list_del() with list_del_init() to reinitialize the list head
after deletion. This makes the code more robust against double
deregistration and allows safe usage of list_empty() on the miscdevice
after deregistration.

[ Note, this seems to keep broken out-of-tree drivers from doing foolish
  things.  While this does not matter for any in-kernel drivers,
  external drivers could use a bit of help to show them they shouldn't
  be doing stuff like re-registering misc devices - gregkh ]

Signed-off-by: Xion Wang <xion.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250904063714.28925-2-xion.wang@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 6f9ce6b3cc5a6..792a1412faffe 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -299,7 +299,7 @@ void misc_deregister(struct miscdevice *misc)
 		return;
 
 	mutex_lock(&misc_mtx);
-	list_del(&misc->list);
+	list_del_init(&misc->list);
 	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	misc_minor_free(misc->minor);
 	if (misc->minor > MISC_DYNAMIC_MINOR)
-- 
2.51.0



