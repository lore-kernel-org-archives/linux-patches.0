Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3830047A6C;
	Tue, 14 May 2024 11:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686596; cv=none; b=MaXP1k2DxKgDx5E+U5CvYeSGZ0hSve8K/bpZKM5RD76g2DDc1Kyzf2jqDyjedcL0sFqNkWnCnM7WqNBO0yHtFrDFV5f+4MljP690Ler9bq1iPEMbi1lLV6kTpUti1Q2G4G/TAAuCg6Q1oiPgyRB4+Dl96KX6H3NLDmrYoOvMrNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686596; c=relaxed/simple;
	bh=+mdXUpiSElh5vPmzmzOmgZf2EKVmk6MHlyftmkNhJU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xc8USboo6yqTViWges+TRHaEzTxLJlZ0oRhR2wZVbE454B4qYLycxysAtSIGiYIx8USjFGsRKSf5Oj+A0QKhe54irQCkG5LJ4na4taDdtVX+dKqML9uspIM9ikLNpTuASaCwtfPk81NUMjq5ECDl8F6TCixED80o2s5R8d4j1Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5qxF/WA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5qxF/WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6A4C2BD10;
	Tue, 14 May 2024 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686596;
	bh=+mdXUpiSElh5vPmzmzOmgZf2EKVmk6MHlyftmkNhJU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5qxF/WAWGQjMlvC23E/1tOLis0wN8AhopiCu8QgswkDms0HTygDhdzxTIPzO+V93
	 jlyhsKh1EjBbDC662Ob3vj+GMdwoeu+6jBoZ/ZkK5bvDQ2saGgWzEij9PJWSvQzOOE
	 Rmlflhj2lVy9QGs8+nLXtexS4FASwzpj0SNmAgfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 193/236] usb: typec: ucsi: Fix connector check on init
Date: Tue, 14 May 2024 12:19:15 +0200
Message-ID: <20240514101027.689241017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian A. Ehrhardt <lk@c--e.de>

commit ce4c8d21054ae9396cd759fe6e8157b525616dc4 upstream.

Fix issues when initially checking for a connector change:
- Use the correct connector number not the entire CCI.
- Call ->read under the PPM lock.
- Remove a bogus READ_ONCE.

Fixes: 808a8b9e0b87 ("usb: typec: ucsi: Check for notifications after init")
Cc: stable@kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240401210515.1902048-1-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1302,11 +1302,13 @@ static int ucsi_init(struct ucsi *ucsi)
 	ucsi->connector = connector;
 	ucsi->ntfy = ntfy;
 
+	mutex_lock(&ucsi->ppm_lock);
 	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
+	mutex_unlock(&ucsi->ppm_lock);
 	if (ret)
 		return ret;
-	if (UCSI_CCI_CONNECTOR(READ_ONCE(cci)))
-		ucsi_connector_change(ucsi, cci);
+	if (UCSI_CCI_CONNECTOR(cci))
+		ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
 
 	return 0;
 


