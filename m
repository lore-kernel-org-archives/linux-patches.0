Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D980A21E087;
	Mon, 10 Mar 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626997; cv=none; b=X5KGdowA7ocdi9j80bzPf6bqNCL1Rfk8oWB/AeIHKkhYOfNXf+MtOuWshugmQtBlGTU3G7MeTe41Qj+ZrGkoFUQ3nSBPI7YelVulx3L0hadgwmAmIOwtpb1gj7vhK2P9svloRdhxw3nR988ZXmcq+Z4muHw+apXW3KpUTDooXYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626997; c=relaxed/simple;
	bh=uvu/ku6+mejnkkWhS4aiFc3FotPHFr43bva/IC5VaPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUs1P5j8SVaoFDm0dZTcUExowKi/IkMML4V6S3HpECTLL7Z1xj4LD5ebpHtuDjxYCmJLa0BGWTSss2myX25Cq1u2nUwYQBcMMcnli3jctw9foyEYyqGkUFrVqqu4+VrxX5dNWGdFlwPVDcmd6C9cnxlTOEJh8hmTd/y4Evv1yHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfuML2Gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfuML2Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFECC4CEE5;
	Mon, 10 Mar 2025 17:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626997;
	bh=uvu/ku6+mejnkkWhS4aiFc3FotPHFr43bva/IC5VaPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfuML2Gf4zyH3Ipi/8ePmdfqquP9Zbqf1z/EJGsWqFGcGVeUQeChSHiFvRwPHn2vy
	 gZCDBon6f0tbcOxrOK8faY30TFNbLgY92k6NL73Mw9oGGDx1P2Qq+07YXHb7NkRqW5
	 ZeS4Dbd2JZN9eD5is3vHqz0UISIpdHAqSw502pls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.13 186/207] char: misc: deallocate static minor in error path
Date: Mon, 10 Mar 2025 18:06:19 +0100
Message-ID: <20250310170455.178304627@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 6d991f569c5ef6eaeadf1238df2c36e3975233ad upstream.

When creating sysfs files fail, the allocated minor must be freed such that
it can be later reused. That is specially harmful for static minor numbers,
since those would always fail to register later on.

Fixes: 6d04d2b554b1 ("misc: misc_minor_alloc to use ida for all dynamic/misc dynamic minors")
Cc: stable <stable@kernel.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://lore.kernel.org/r/20250123123249.4081674-5-cascardo@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -264,8 +264,8 @@ int misc_register(struct miscdevice *mis
 		device_create_with_groups(&misc_class, misc->parent, dev,
 					  misc, misc->groups, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		misc_minor_free(misc->minor);
 		if (is_dynamic) {
-			misc_minor_free(misc->minor);
 			misc->minor = MISC_DYNAMIC_MINOR;
 		}
 		err = PTR_ERR(misc->this_device);


