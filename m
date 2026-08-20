Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191DB46C82A;
	Thu, 20 Aug 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248638; cv=none; b=WbuFDtypN0RuQh04eNAt8j5eVTW2wz7UAWFJ3L2oBIN+/Gwxe40N5Brvm8p+nvVoy6rT63LqkpW+K6AcndfpQza9p+83dMBPz4jdt8XFQD4VfIMOKHIukIGEh4x9s83ogx4SjdtA8HOeyulCy3d7auLCwVIqi/utEwVHEqjk9yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248638; c=relaxed/simple;
	bh=RxJms990st+vKpgVfgh8NvWVfbR9KoeisIbdyeiyoF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPzWzomTnF+GlRei0ZWbbcik6Aleg0kYiCX8yrPtDEqrCgYNztu/2vjiCcI+fyfedhroI6GF6Mdh0wO9bIAWSw+jVo+kJns48/F6gEB9u4cziVNxlej9ryjttNuyhr7mAThU5cbmev+rUxkNeuMRmgtsC/gI+NjWCNb7yO0Vo4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+mmG6T4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+mmG6T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0E51F000E9;
	Thu, 20 Aug 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248637;
	bh=eNQPntIt/zwB38ZIMd/iJ/3Eskrb+oLWKKGIz04bOvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+mmG6T4o0FuEpirTOm7wo6zI4eqAjP1vG3tZaWjIPsJpV57eYmdde5AdDH2mkXEu
	 cBxfhzgj44zWsSrTjfRsv3a1fTInd/UPUAz5EnGfCbwS30UiFgVmvoGgEZEngmx35A
	 LMFTEv5fLXFjM8E0S7rvsXdnZ6xs3WgwuSIw7kmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 297/303] usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path
Date: Thu, 20 Aug 2026 16:57:13 +0200
Message-ID: <20260820145302.400452077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit fb0bf289f5d529336ef490c8273e88a8a8b29f69 upstream.

The commit 7aa7d4bf9d3f ("usb: typec: ucsi: Fix race condition and
ordering in port unregistration") consolidated port teardown into the
ucsi_unregister_port() helper. However, it introduced an ordering problem
in the ucsi_init() error path.

Fix this by ensuring ucsi_unregister_port() is called before we unregister
their corresponding lockdep keys.

Cc: stable@vger.kernel.org
Fixes: 7aa7d4bf9d3f ("usb: typec: ucsi: Fix race condition and ordering in port unregistration")
Reported-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/all/22064276-6c56-411a-9f20-6917ceeb865f@intel.com/
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Tested-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260717104614.325250-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1390,11 +1390,11 @@ static int ucsi_init(struct ucsi *ucsi)
 	return 0;
 
 err_unregister:
+	for (con = connector; con->port; con++)
+		ucsi_unregister_port(con);
 	for (i = 0; i < ucsi->cap.num_connectors; i++)
 		lockdep_unregister_key(&connector[i].lock_key);
 
-	for (con = connector; con->port; con++)
-		ucsi_unregister_port(con);
 	kfree(connector);
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));


