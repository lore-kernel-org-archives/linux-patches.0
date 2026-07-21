Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02648388890;
	Tue, 21 Jul 2026 19:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662361; cv=none; b=YJ3wph0HTLzSxJfRkApuPIUvNcMR43k2RScCyUsS75zB3ABX1Lc/jzwgXWn1KDwSK9PS1Otz7O9LALAT9uDyN6T7+ty2Ta1l3fXYGaAtze8jrOVsRpn/kMGB8sdN+4kd5ao3vszxVzYzHX7KL0bwvtZwJO+xbm/jGAadQJN6ssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662361; c=relaxed/simple;
	bh=/X3E287lLEn9FmTzTfk9g3dluehRAKlfBLqE3c0OqCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2gKIuYAWuCoRANgjRMb48+6fNQZE/LvvXfMCAeAosLLqsxDGFzVbQkPavrUsO7u+3+0L58b2nbaVi/cOj/K1YjD7flwicsxrjGVj9kyjii+Eb6NvpR0KUO+nwBb3U3Xxr7qk5LD1EJ8u5ohdjTavjeKPKoXcBYxsK9XiRoztv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3ZmN2i4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3ZmN2i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691E81F000E9;
	Tue, 21 Jul 2026 19:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662359;
	bh=Jkm/70dDuzs7g/tyi+S9sGWlxzxubTKwGFN5+SCG6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3ZmN2i4IXhRbQPOzBONOzDektI+9a0f0/TY1k2Jh2++Z0XWQcNgqNQ0SCDNh0jXw
	 2JcXhqjk3pCrnkSssmY023DNoMgpKOHKReTu7Pg2bumWbbaAiE1Xdc0UYjwYTNEot3
	 CkknD4QUwuI4SMmCS0EeETVzdfYmbJQuwIa1d5ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0371/1276] dpll: guard sync-pair removal on full pin unregister
Date: Tue, 21 Jul 2026 17:13:34 +0200
Message-ID: <20260721152454.408609006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 0a5c720a7d57d2287d5566c4ad93ee26b7c06845 ]

__dpll_pin_unregister() wiped the global sync-pair state on every
(dpll, ops, priv, cookie) tuple removed from a pin. When a pin is
registered multiple times and only one registration is being torn
down, this dropped sync-pair pairings still in use by the surviving
registrations.

Move dpll_pin_ref_sync_pair_del() inside the xa_empty(&pin->dpll_refs)
branch so it only runs when the last registration is gone, alongside
clearing the DPLL_REGISTERED mark.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260607183045.1213735-7-grzegorz.nitka@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 08b5055ee09cf5..c457c7b03fce4d 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -856,11 +856,12 @@ __dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 		      const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	ASSERT_DPLL_PIN_REGISTERED(pin);
-	dpll_pin_ref_sync_pair_del(pin->id);
 	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv, cookie);
 	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv, cookie);
-	if (xa_empty(&pin->dpll_refs))
+	if (xa_empty(&pin->dpll_refs)) {
+		dpll_pin_ref_sync_pair_del(pin->id);
 		xa_clear_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED);
+	}
 }
 
 /**
-- 
2.53.0



