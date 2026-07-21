Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5D46A5FB;
	Tue, 21 Jul 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656011; cv=none; b=r9c5XkmQlS4mVoECWa4i0XXK/J9prJ4mTMZbfDEc5YSmKb4PWZaBQwDdn4A7T+/WQEriexV1bbhU9gYKFrMGfGndbRUdWbS2U39JjJGxfYjimGatMr7ecj8I7WSDQY358MKj3lT5+s5H5BjsgXc2PSQ/+h2DIYtOdeZ1vOouL1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656011; c=relaxed/simple;
	bh=80CU04tzGXmPQzPuwCdXQydmTQcopxMBrWod/nM2RZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjjAFiFLnHDuG5JEoO5kdbxBRbtshCXO8k3h2T5WJ/GSw6wwNFbZHvE3qnyjNwK8iBqKNMVgFkM6kclYejuXrB0FA8W/jA/vUYDlDAoZgmKfeNIoCdgiR8QMYNAX0Z/abJr00a3UJUUbECNcsBwfohAVFpDJ2AJEL0Xj9fPgf9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNG+7w/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNG+7w/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA8B1F000E9;
	Tue, 21 Jul 2026 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656009;
	bh=yczGKVP35a2iaAkN48FE2NJySIWQEnCNqwcoaebP+k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNG+7w/j9Tu5Q1FqjRY5fL0E4lS/43d7Bek16yLZnavmQKjgEDxhpM9yxh/hqr0Ne
	 0Tp4ch7/KUMPszNv1JxnT6frV1jYOqndjWb424FMagREeep6airPrVaK9iOe1fT2du
	 RHA+yvkFRjPbv0bTKKn+/mSb4jkPmfo5FAvxGLpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0224/1611] driver core: Guard deferred probe timeout extension with delayed_work_pending()
Date: Tue, 21 Jul 2026 17:05:40 +0200
Message-ID: <20260721152520.044179938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 557495bc879013c3d5e21d667e987e7ce3a514de ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 175d9be6455dd2..1ba53078703e49 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -327,7 +327,8 @@ void deferred_probe_extend_timeout(void)
 	 * If the work hasn't been queued yet or if the work expired, don't
 	 * start a new one.
 	 */
-	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
+	if (delayed_work_pending(&deferred_probe_timeout_work) &&
+	    mod_delayed_work(system_wq, &deferred_probe_timeout_work,
 			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
-- 
2.53.0



