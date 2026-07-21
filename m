Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EFA44AB62;
	Tue, 21 Jul 2026 21:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670766; cv=none; b=LMxNyH3g26UhPKdej+uPBmWWdrX3/080BQRekqnZH05vpCaEN7DsMKwxuX4NzE3V2OGSMEk7gr4280bG3AfX4StXsOzeBD65kpv0J1OawNCernKVwGVyo7xGmHG7FpRbKl/wS31jgJaqyOv5qOl2UOoDr9Y+DKVzUIZYx5vSFOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670766; c=relaxed/simple;
	bh=00e+tL/NtaFnIZ97fXGvEJMWOAmQKKrFbtHyvjeRJnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/bzWxdAJtBitdNayP9YOAolQX3HNllW023YXpthA6ejsbFhUFr/ww2kARQpWZz+RNi0/m/t4xj/KnFRVHUhoIqRrI5xNeoElnieG3A+k15U6VIrRkMfgHQbHXOMEAWpIH65TEDE5LJiaMhJYyQcvACNJOzWn8GxyRsX3QQyM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unB5vj7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unB5vj7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99681F000E9;
	Tue, 21 Jul 2026 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670765;
	bh=xw+8brJNzkLdqjLGIuEGgjCcWY/JbfdRhrD8z7S9j/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unB5vj7Sgl3iW7xQENtFwhvF9uvCzuDuZHTX7Mmzwg96pz2ZGTMgtE1aGBx10u3Op
	 CzrD5Mn9D+DTTkiQteOXIXNO0EOHZCENAT5L/fhoPBbQxFcOQT8iffG7WTrNbgVVDi
	 4YXcLUpmzgEaEieXeN1ym+zf9VeFLLd9012LmKi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 1055/1067] driver core: Guard deferred probe timeout extension with delayed_work_pending()
Date: Tue, 21 Jul 2026 17:27:36 +0200
Message-ID: <20260721152448.187187012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 557495bc879013c3d5e21d667e987e7ce3a514de upstream.

mod_delayed_work() unconditionally queues the work even when it wasn't
previously pending, which can fire the timeout prematurely or restart it
after it already fired. Add a delayed_work_pending() guard to restore
the originally intended semantics.

Premature firing calls fw_devlink_drivers_done() before all built-in
drivers have registered, causing fw_devlink to prematurely relax device
links for suppliers whose drivers haven't loaded yet.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -326,7 +326,8 @@ void deferred_probe_extend_timeout(void)
 	 * If the work hasn't been queued yet or if the work expired, don't
 	 * start a new one.
 	 */
-	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
+	if (delayed_work_pending(&deferred_probe_timeout_work) &&
+	    mod_delayed_work(system_wq, &deferred_probe_timeout_work,
 			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);


