Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B35B43D503;
	Thu, 30 Jul 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422642; cv=none; b=slokpHoVEbuD1bJzxXkb/7axg3JtwrrNl5PxJeByXEL4vBgzCh7BszaOFNbBVyCMRVQfqaMrYKMmpwjsf7MV+Y358GnJMKqhjtXumPG9awMjrKmgi02DF+Wl+DLPC5CWaCK/xA9pGI6YstbHrIqR7ffUJWyWI/YTnwy5MfOH04s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422642; c=relaxed/simple;
	bh=mOr7r5t/jNRHkHGW0/eerfMmhkuDPCGf79So+iZBp0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MzHqBxxBhNppxVcXz0li36gT1gxe1XPcPgGWRTLoywyeytzFJ8UNJMBYZfOnXpCJxo6HpGlN6jxCzSn5qhKlrj7mnXKF8YEsKdNNehIqvlrlsGBupwheCecGxRnpdor5ri9KBUjPnFFsM5wsB+ZEO3L6n5uZiNaH6fpVQ8VPlhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWMvkDaI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWMvkDaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8F41F000E9;
	Thu, 30 Jul 2026 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422641;
	bh=2oxkVSO+olG8aHCuXC2SqbtSn+fUXFihZD5M2+/p59A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWMvkDaI3mw61qug9ZCrg/q6FUaSNQuUmyCzY3A6hMtHSORYOpfZfzYpxJ/iBHYk4
	 c+WB4C6vVyiykHe0sKn2DVpFNdU4J7DJWVZFGJk2Lmi7Ad9a7OIsCQ2G1U+h4i49ob
	 eR+2cuiDDT2I+ZzNHFxPkA1Y9yi0TtKyYucUrwsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.1 464/744] drm/vc4: Shut down BO cache timer before teardown
Date: Thu, 30 Jul 2026 16:12:17 +0200
Message-ID: <20260730141454.159368049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 6273dd3ffb54ec581855b82ae77331b66028249c upstream.

The BO cache timer callback schedules time_work, and time_work can rearm
the timer through vc4_bo_cache_free_old().

vc4_bo_cache_destroy() deletes the timer and then cancels the work, which
does not break that cycle: the work being cancelled can rearm the timer,
and the timer then queues work again after teardown.

Use timer_shutdown_sync() instead, so the timer cannot be rearmed and the
cycle ends with cancel_work_sync().

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720084426.1632508-1-lilinmao@kylinos.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1045,7 +1045,7 @@ static void vc4_bo_cache_destroy(struct
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	int i;
 
-	timer_delete(&vc4->bo_cache.time_timer);
+	timer_shutdown_sync(&vc4->bo_cache.time_timer);
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);


