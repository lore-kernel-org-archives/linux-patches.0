Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6EC30276A;
	Sat, 25 Oct 2025 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408997; cv=none; b=fj65odi4Q/LNm52JEZBV6J0XTiU435T512itCvpFDshRL/8H8FyfnF4aGdxJN5bHXU5uXUbHTnpdyAeWU7PM9V6aozj7aYRyQsUdI4YDhlyWGywPg59k4tL/kiuxCTMlTFQJkPHnla4Q+p1ACmu9hHsu1NHklkce67RGocR53z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408997; c=relaxed/simple;
	bh=JabiHfliSwSHQuQwQs2XA+E+27md+dnI+Xnb/fgeaRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUIeKeCqr0XvG1Hi537ri3yGiCeI2JmEmrOZb0wvwmFeUVzqpkcwVQ2x6dyIQmRKRJLqDggFjORhc4iUzBDSWj8nH5/yrJjNLDVJew3Rl96l+YSU4yXbY8ItLMB4AF96Q6NM9m4Pdlf/qjDj9tj0Y1HpqkXe7nHUJOvKwCHEmbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mq8RGfqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mq8RGfqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E988CC4CEFF;
	Sat, 25 Oct 2025 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408997;
	bh=JabiHfliSwSHQuQwQs2XA+E+27md+dnI+Xnb/fgeaRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mq8RGfqm9z5KJUUyk4QJOKfoan8GVuF+zN8bgEl6TFmRu19/w9rlapSOyQrz9lAUI
	 uwXVm5ScYx9w4an+FByVwsZDUJHssidAvZQXEFRvkaIB3kin3Pph9zeI/QoFIHbpoq
	 u9gOTeyM178c/EkuuoJtojnDdu7gP99msNyJ1exUhNXkafj71Spdr5pSlW1Zj+HY7V
	 VKEUbRzu+YSR6WVP7HG2lwEmMXhLUQ7MB1KUshU0EjD5LIC8fY+gSGZIYQamWUmEGI
	 2WtYei1r24ZGLTOhOx8hV4gCj9a5/1pUJuuQOFtgbT1KDqxE6IoIOKwSrDsO2RMhSE
	 hur4/nYrc/VZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xion Wang <xion.wang@mediatek.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] char: Use list_del_init() in misc_deregister() to reinitialize list pointer
Date: Sat, 25 Oct 2025 11:56:38 -0400
Message-ID: <20251025160905.3857885-167-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What changed: In drivers/char/misc.c, misc_deregister() replaces
  list_del(&misc->list) with list_del_init(&misc->list)
  (drivers/char/misc.c: list_del → list_del_init).
- Bug addressed: After list_del(), the entry’s next/prev are poisoned,
  so list_empty(&misc->list) is false and a second misc_deregister() can
  call list_del() on poisoned pointers, causing undefined behavior. With
  list_del_init(), the list node is reinitialized to point to itself, so
  list_empty(&misc->list) returns true after deregistration and a second
  call cleanly becomes a no-op for the list operation.
- Scope and impact: The fix is a one-line, localized change confined to
  the misc core. It doesn’t alter the normal registration/deregistration
  flow. The surrounding teardown remains unchanged and safe on repeated
  calls: device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor)) and
  misc_minor_free(misc->minor) are tolerant when the device is already
  gone, and the code resets the minor to MISC_DYNAMIC_MINOR afterward
  (drivers/char/misc.c: the nearby if (misc->minor > MISC_DYNAMIC_MINOR)
  misc->minor = MISC_DYNAMIC_MINOR;), further reducing risk on
  subsequent calls.
- Risk assessment: Minimal. The only behavior change is reinitializing
  the list node instead of poisoning it, which improves idempotency and
  enables correct membership checks via list_empty() after
  deregistration. Concurrency is guarded by misc_mtx as before. The main
  trade-off is slightly less aggressive poisoning for this node, but it
  materially reduces the chance of crashes from double deregistration
  paths.
- Stable criteria: This is a defensive bug fix that prevents potential
  crashes/oopses when drivers—particularly in error paths or out-of-tree
  modules—call misc_deregister() more than once. It is small, contained,
  and non-architectural, with no new features or API changes. The commit
  message explicitly notes the robustness improvement against double
  deregistration and has maintainer sign-off.

Conclusion: This is a low-risk, robustness-improving bug fix suitable
for stable backporting.

 drivers/char/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 4c276b8066ff8..ea5b4975347a0 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -281,7 +281,7 @@ void misc_deregister(struct miscdevice *misc)
 		return;
 
 	mutex_lock(&misc_mtx);
-	list_del(&misc->list);
+	list_del_init(&misc->list);
 	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	misc_minor_free(misc->minor);
 	if (misc->minor > MISC_DYNAMIC_MINOR)
-- 
2.51.0

