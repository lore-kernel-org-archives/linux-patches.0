Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9663DAAB7;
	Fri,  4 Sep 2026 05:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499685; cv=none; b=ncMO5npKCHT7zHAaUD8lWnGkRFqVKX9Q/a0+/E7wGzyTu6u62oHgcWGqIJLWvj6rshE4yl0VbDiD49Kas41EH09+CNg3Fuz+OAt8eE7pjROi9O8S1xfMDD1/a/eoZ7ygDJS6RDsT7kQB7l5yV6WliLKg0bgPM/seXKp21hWctbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499685; c=relaxed/simple;
	bh=hO89MNvxOo7DXnP8D1o/lxsjoS0LyL88QtzcoCZxK/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueQAJmpcGF+l/spqrgoAkbterEpAP6eudEW2vAncBQKPZRRf6JV3cP8adwCDQgjU4jnYlZK9F82WDA6XR9V1aGCH6s3suPQsDq9Mgof0/C2vSAWyuWqfi5VlhIki0crHE5J7r2j+CeLk8m+LWyUkyey7vDfWcdM04Z4dcsoNfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccUAd5wH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccUAd5wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1575B1F00A3D;
	Fri,  4 Sep 2026 05:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499683;
	bh=RDHlVHtddTiep/qDFHVNj1v2TPLcufV2MGWxoQMNVbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccUAd5wHNYAuY3DSn/HIpMlX0mPvhGwhsAB8akvD3I/e8KwT+SF7pzYUminkl+hY/
	 Gymj8BJSPbj2tv8YiVuZx2JoV8RQuapWQxiyL5dMOBItmlXtgOx6oNQX1BM8PFDQ7G
	 rSEQStcaLjtjVDEAkaR1rSc+o2yQ2WHpkuIUzOXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 505/713] power: supply: lp8788-charger: fix use-after-free on remove
Date: Fri,  4 Sep 2026 06:57:53 +0200
Message-ID: <20260904045815.142964471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 831c29a12d560f8a3225f43050b3fbb5dfd79c66 upstream.

lp8788_charger_remove() flushes charger_work before unregistering the
IRQs. An IRQ thread can queue charger_work after flush_work() has
returned. The work can then run after devres frees pchg and dereference
it in lp8788_charger_event().

Unregister the IRQs first. free_irq() waits for any running threaded
handler, so no handler can queue more work afterwards. Then use
cancel_work_sync() to cancel pending work or wait for running work to
finish.

This issue was found by an in-house static analysis tool.

Fixes: 98a276649358 ("power_supply: Add new lp8788 charger driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260802035442.421697-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/lp8788-charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -710,8 +710,8 @@ static void lp8788_charger_remove(struct
 {
 	struct lp8788_charger *pchg = platform_get_drvdata(pdev);
 
-	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
+	cancel_work_sync(&pchg->charger_work);
 }
 
 static struct platform_driver lp8788_charger_driver = {


