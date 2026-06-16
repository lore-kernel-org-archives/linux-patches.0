Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BE8318EDA;
	Tue, 16 Jun 2026 19:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636817; cv=none; b=oAuv6aEAJ5f+UplMND3ThBJI/QA2WgNn7f2WmQxAhu93fbiCUUIlvHzziOTVF++gCj97nxonIehQ+QdmFXWOI8aRYy0GZoxK3V7Ax1F4vLyOHcnaNGbIMEHis8Utu8jVC4rNtWdXcSyafBoiWJf2yqGZOYzVZgvhviQvoa8vISk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636817; c=relaxed/simple;
	bh=spMDwq/ME5z569hTGXRny1qB05hU1HD/39J6VIQuESI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyBJkA2x+HwSWkoN8pCXjbRONKWfj/Xfxp+xJiwMagw4spH6wRGD4KHhVi4Rt5QPfEED9irjhAKNfMgWZm+8tthW/nYVfeF1DkceMXpnaTDoqFiw+gaNtUKXtakf8J/4cgNp+GefcD0BtLG0KoeO943LzAQd0F+YJ2UirpxLayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsKK3MB5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsKK3MB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2101C1F000E9;
	Tue, 16 Jun 2026 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636816;
	bh=wK0sirdrVwwv5jGJEkSqZ9Qp7J1cXUqRQcDZiWgL4yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsKK3MB5nmmD+x9QV8+1iLj8bCHFPhFvbY7Uszdnopx9R9KEMtfD2+GxDVn1ng/JT
	 xXHJinXRYbA4KEPxEAf7muLitKMXNDife/e5Q0TfDlUUS2Ry2XzB7eoPbiqkGUFRPj
	 wo4QPwk0pJ+7KGbPTeeQQ3tQYW3+BYPfBbclQLo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Sasha Levin <sashal@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 5.10 310/342] usb: typec: ucsi: Dont update power_supply on power role change if not connected
Date: Tue, 16 Jun 2026 20:30:06 +0530
Message-ID: <20260616145102.909504547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

[ Upstream commit d98d413ca65d0790a8f3695d0a5845538958ab84 ]

We only need to update the power_supply on power role change if the port
is connected, because otherwise the online status should be the same for
both cases.

Cc: stable <stable@kernel.org>
Fixes: 7616f006db07 ("usb: typec: ucsi: Update power_supply on power role change")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patch.msgid.link/20260519-ucsi-fix-2-v1-2-6f1239535187@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -775,6 +775,12 @@ static void ucsi_handle_connector_change
 	    role != prev_role) {
 		typec_set_pwr_role(con->port, role);
 
+		/* Some power_supply properties vary depending on the power direction when
+		 * connected
+		 */
+		if (con->status.flags & UCSI_CONSTAT_CONNECTED)
+			ucsi_port_psy_changed(con);
+
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))
 			complete(&con->complete);


