Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B801EB5A;
	Mon,  4 Mar 2024 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589122; cv=none; b=l1SOgQvIXp76icvDpnnrVFjS67RX454U4Jkj+SMVo/hCFR4TxwTDhaHUYBcQeqUmgV3sAdbzuBttWXk1ChwqrUGf1I/sBASyQkh/Sn3Wk2YhgezqOVW655ih+6fB7maU2kSbT0PrJnUK/vrUVjXCBQk4mZbW7uUnLDHaAtKxC0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589122; c=relaxed/simple;
	bh=tRJTyjH42CeZ4P0AD10tlr81WXrJzENqiunvNkXo6yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFSlE0cHrEZ81CJKSD8oyfsCKIET/eFLjtHQK2BySgZwg2YsoYRk+2jiO9YEdBh5MdLLBKUQBzpAqX6odrWKd1NunPurhxjETMnlgBZswh9nZGhqkrsMjkqOwmb3/xhdEjDN4Mcm7ZdQmUr3MJ3tx/Qyu0ybkZ8AngIek5k7gEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7GKzyf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7GKzyf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1601FC433C7;
	Mon,  4 Mar 2024 21:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589122;
	bh=tRJTyjH42CeZ4P0AD10tlr81WXrJzENqiunvNkXo6yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7GKzyf0Sbee8j5xDrJypVpuzZKNlGcSbyYCMGLUMSB3Sf/XN3eC9TfuTOSQWGktf
	 kVrsQGswaXB+guZe6eiFdbzixbz4b0+rtB8rUVn3wKFkkYeIRsVRl2wbl8j3CTTTpG
	 rTojFzTHz8k9Apo5YX68fOgnlZK2g1iom28En3qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 181/215] efi: efivars: prevent double registration
Date: Mon,  4 Mar 2024 21:24:04 +0000
Message-ID: <20240304211602.686660703@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb+git@google.com>

From: Johan Hovold <johan+linaro@kernel.org>

[ Commit 0217a40d7ba6e71d7f3422fbe89b436e8ee7ece7 upstream ]

Add the missing sanity check to efivars_register() so that it is no
longer possible to override an already registered set of efivar ops
(without first deregistering them).

This can help debug initialisation ordering issues where drivers have so
far unknowingly been relying on overriding the generic ops.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/vars.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -66,19 +66,28 @@ int efivars_register(struct efivars *efi
 		     const struct efivar_operations *ops,
 		     struct kobject *kobject)
 {
+	int rv;
+
 	if (down_interruptible(&efivars_lock))
 		return -EINTR;
 
+	if (__efivars) {
+		pr_warn("efivars already registered\n");
+		rv = -EBUSY;
+		goto out;
+	}
+
 	efivars->ops = ops;
 	efivars->kobject = kobject;
 
 	__efivars = efivars;
 
 	pr_info("Registered efivars operations\n");
-
+	rv = 0;
+out:
 	up(&efivars_lock);
 
-	return 0;
+	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_register);
 


