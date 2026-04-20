Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7F8402438;
	Mon, 20 Apr 2026 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691617; cv=none; b=NhJntryQJswq2UZmYeu8XzjLNr1Xwt3clWGzmxgLeYa/u5ZFdGdO4Ra5YSuPOS3J0QaIiiKUBopatm6eSc6AJtLUV+gsiCzUYs6mWwKTJ9VVRnoGcLNeu5txjdLR5Q+UL7m644GBoX42wQP7oEb3YGWqvYAaEDDMEfxJR8hhbj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691617; c=relaxed/simple;
	bh=UcKJEjgOU6eYq0PKTJ36LRKQhrU+TD4bvjXm7hN7WWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kewiuCuPg8DLcLNB82fT6r6kQm34eDwVNjAzdZPyacy2G7mXl2y0uho8QqrIaVbzPHBlIEacgqL5vFXvTWtUVgfLnc4IGdjy2KBDUGCpJiV3cA0Mj5f9P3eC8GH7JntfYbiuKXhGSe2slKF3F7wnTwiYDCQG0WZRsc0tsQfI4GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXrFqAvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXrFqAvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2CBC19425;
	Mon, 20 Apr 2026 13:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691616;
	bh=UcKJEjgOU6eYq0PKTJ36LRKQhrU+TD4bvjXm7hN7WWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXrFqAvLSkZrLFq8c15E0qn1ryqmr6ritlROlDB6W8TM0iGrY/1gKzbig1BB7JvTF
	 /e6lTGn0iTL7EhFqQxol/FwUtHSUS3BExNZboaQgQM8Y00FdAHPRbvXSU+9W9NAyRu
	 76NS9J5Fa4P6M1gX5qGc4u9GdDxwRg91YnwoNnidP3F2UXW4n5VlRpeSX6PO76D4QE
	 hYnLh44Fj03UkHEBypJMrSWNYXjqxOJ2RnRvKyygy9B0FAa3u6zrc2u5NOfpCAIy/z
	 gPU7J0uRQjVYrBZdQddElPiu0M0gqqif80H3i3NUzck05iJ+gdMzv9AfSzlnKsg9/W
	 nP0cNC6GcJc2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	erazor_de@users.sourceforge.net,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: roccat: fix use-after-free in roccat_report_event
Date: Mon, 20 Apr 2026 09:18:48 -0400
Message-ID: <20260420132314.1023554-134-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit d802d848308b35220f21a8025352f0c0aba15c12 ]

roccat_report_event() iterates over the device->readers list without
holding the readers_lock. This allows a concurrent roccat_release() to
remove and free a reader while it's still being accessed, leading to a
use-after-free.

Protect the readers list traversal with the readers_lock mutex.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/hid/hid-roccat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index c7f7562e22e56..e413662f75082 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,7 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->readers_lock);
 	mutex_lock(&device->cbuf_lock);
 
 	report = &device->cbuf[device->cbuf_end];
@@ -279,6 +280,7 @@ int roccat_report_event(int minor, u8 const *data)
 	}
 
 	mutex_unlock(&device->cbuf_lock);
+	mutex_unlock(&device->readers_lock);
 
 	wake_up_interruptible(&device->wait);
 	return 0;
-- 
2.53.0

