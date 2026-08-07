Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A296474275;
	Fri,  7 Aug 2026 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117781; cv=none; b=u5P3qj7UZAMkpOMiJ/S5AzfkzK+a65+KC5XcptWuP7CBzQqkx+kMZq55VMHMz7OKzeVDSg2bQqvt1m0Y9v5x+fp1xMZGnLUyge4qYd/BSYcktULaw1F0r6xApLy+MDdG0PFI3e4rXMNPeryhZVKEpbtjenu28vW9VzV6o6gdmEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117781; c=relaxed/simple;
	bh=RBn4nO9txIxu84tqWsqLhq0jS2LAfuflbT2wRkOyywA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkyAcd5TBugc9nAI3n/11SOfWZoLIVJqxDLEuhx7LXIDZDUbkNB/xrp3smGpSHk8e3NbGxW764OXOH2V0M6hJwipA8ENfddOCqYIbpdgKiaukzCnk0gY9UQHhEq4ZP+Zbl6Hq4l26ZSCDy1pY9iFPITqPrt5WyCIRPft8IQHQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2Ezd+fu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2Ezd+fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73421F000E9;
	Fri,  7 Aug 2026 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117780;
	bh=SlJo/2QWz7ukuQDIxz2v7AJZkWxkEYKpkjBOKGprClM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2Ezd+fubIt1dX89e0gqNFhptHKkMJEcAkSJYzd23k13TjRL1L2IeCu7xk0tsorPI
	 cjELFdilFe0/ruEf4SPZaK6wUzgZ/txyo67k20y7IKhKa4W0/WTgCl22zdK9Jc1TIR
	 aeLwpXy7MI+CxufwIL+TjbnczrhDLHFg1GajR+/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.1 438/438] usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path
Date: Fri,  7 Aug 2026 16:40:34 +0200
Message-ID: <20260807143437.311293195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2110,11 +2110,11 @@ static int ucsi_init(struct ucsi *ucsi)
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


