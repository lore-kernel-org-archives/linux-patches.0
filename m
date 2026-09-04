Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADC231197C;
	Fri,  4 Sep 2026 05:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498574; cv=none; b=HNauzDxzDAD17qb4bv62zpGNVCPwnFPmK37jqkaQZ2DlVAQ1Y2ZFDY5OSO/dYNyn4CIrsPukej/3WKWPWVHodqCRYKxAEXOhgB0p+eMMPlo3EjAAVuzX+7YtNIGp7mgpYnLgJ8g87gxMNlqx546w018P3ehG0Xt7UudZzGbz7pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498574; c=relaxed/simple;
	bh=XDFE674tCfewa3q+FF75ePi85AJ+DuS/p1JztSjZU7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtYSe/+Skf5Xb1O1164DAOxPab1Rkqq+Z9X6lneP6mlJunLUIvVpA2x7j+BLF6UmG6DRcMWIZ9YI7DtPGHxVQvPiRs6YcpA86DC2LXnxI6cskkGA6+k+f/DjcThI7L5JEgaPUIRI0S7RTOZ3vkT65MO8PS4UQmHMpAk8jI0lm0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEo8Fn/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEo8Fn/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012371F00A3D;
	Fri,  4 Sep 2026 05:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498570;
	bh=mku/DTmKzqVhUf7Od73SaMeh5zWHO0QmLoYeuRXrL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEo8Fn/1J/7H8189bPpWZJav2JGtg5gBGBAoh+NHaD48nLsVkeQfmhQiPAd9Z+Dfc
	 cVgwCGxdFU0ZSDNE7u9ITVCEbGxjgBy7WLX2wFm7nV9Dnyq0KkBRj3rzs5RmC76vXk
	 dHZGJyjAahP7DB1QQgPQLfiO2ZEDHt21AN53B3iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 109/713] usb: typec: thunderbolt: Disable work before freeing tbt on remove
Date: Fri,  4 Sep 2026 06:51:17 +0200
Message-ID: <20260904045806.279459403@linuxfoundation.org>
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

commit 92090f6ff2acc81e9dd99881dcfb4f8c1bdaabd3 upstream.

tbt_altmode_remove() drops the plug and cable references without
draining tbt->work. The work function dereferences those references,
and can also requeue itself in its error path. The VDM callbacks can
queue the same work item.

Disable and drain tbt->work before dropping the references. This waits
for an existing invocation and prevents subsequent schedule_work()
calls from queueing it during teardown.

This issue was found by an in-house static analysis tool and confirmed
by manual code review.

Fixes: 100e25738659 ("usb: typec: Add driver for Thunderbolt 3 Alternate Mode")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260802014959.416687-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/thunderbolt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/altmodes/thunderbolt.c
+++ b/drivers/usb/typec/altmodes/thunderbolt.c
@@ -303,6 +303,8 @@ static void tbt_altmode_remove(struct ty
 {
 	struct tbt_altmode *tbt = typec_altmode_get_drvdata(alt);
 
+	disable_work_sync(&tbt->work);
+
 	for (int i = TYPEC_PLUG_SOP_PP; i >= 0; --i) {
 		if (tbt->plug[i])
 			typec_altmode_put_plug(tbt->plug[i]);


