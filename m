Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8883BA225;
	Tue, 21 Jul 2026 21:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667981; cv=none; b=ovNB16NBA+kEJTPWDz9ij1hfk+aZT1fx7CnB2iqIV0EqY2LC8m+g3W+StJKg37n1yVPXgmLjO0d6yfi6MBKAMOVd+oaqLPOFTSxxt92zsNGILeDxQb8kG5dD0rrz8yCz9U1lR/0M54QkqDzTJuNKz9dGXqg/dPS7H2xFKSSIOhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667981; c=relaxed/simple;
	bh=fM9Y3Yovc5H73S71H/yWq+eY9SHD+ZlM+lEHtVrqVqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgRljQKvAI2y7XglnLvfWDPaqKrLG2wb4BPXOts9qEMAlzluojss+0yabS3Ba0hLf8Xrr29i5M+KUi+A03YuJO8QhHk/15duP6VRNjtv5Ww7rfvpoAq43sYzwPve3YXzdgKPMpdbZPAy72rdbyWopnLQ1npxfjehMWjL5nShDHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxRXCpUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxRXCpUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026571F000E9;
	Tue, 21 Jul 2026 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667980;
	bh=742ANhgLEFV/C4k5bmdlBxYhV18MNa8a2FiCCx0rlv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxRXCpUB2iPACFfqCOgajSysoJHMgc7urby4is5O55exYEmiJdxS4obFlBF6x233C
	 El2PPOohJbPtKWJRo+3V3t8nwuwNu0nSsMIwCRXLFMJ6v3iqEOGh5NAIJeykZbiW6H
	 Y/rKa/ILUNW+HmY19YNe3rywWYUxlWBvxnfLSSKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 1266/1266] driver core: Guard deferred probe timeout extension with delayed_work_pending()
Date: Tue, 21 Jul 2026 17:28:23 +0200
Message-ID: <20260721152510.154735273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


