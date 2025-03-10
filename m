Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4166230BED;
	Mon, 10 Mar 2025 17:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627399; cv=none; b=N++Dv1QAtyUNupRpMdh1iO0cbXxVDRDNdlaIidrwVyqqBFknHvUripM/s6Y3zTTRDUTPaGbgJx8YqTSI2R/t+TEZivxtWNy2muCpRnHwRBG4yQdQEowN7JhNDJj/UXar/aUz1fYePcfKLo/T3WIqauTnwlpeTJNYiW65cZuYTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627399; c=relaxed/simple;
	bh=Ksyxk25XOLuB6+zVzHqKesxoUBqhVMYr8CSa19SNwNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMFDymDYEa/unzOepBFsMgXO0gypNlG8EHbP2/0CZpENiU09+ezERW+7DXWy28YgmUpGT8q8KpOOIbf0IbFX4H5LXclxdDIKiqexcWIx6v2BdzcnXiOOfB0zzYB8wP9WoqL4M7MasJtMKu9/B3EWLnPLKriQcC5r8ODlLuTVGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6GD8Y9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6GD8Y9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41AEC4CEE5;
	Mon, 10 Mar 2025 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627399;
	bh=Ksyxk25XOLuB6+zVzHqKesxoUBqhVMYr8CSa19SNwNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6GD8Y9oqZMo4R9nWi74yHYbEm3m8sRbB3GB+qHyyfcTjEenuzwHjv23ppHcGg03s
	 OZM7cEBdFZuAFnoA8tnfznE/XxaXgY8EeMsi8asoJpXISpUtQdspPu2LnXzEWpKp90
	 ASf/YxWrog/f89U3j1RqMHXRGHUusGaLAj9qTPzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 085/269] ksmbd: fix use-after-free in smb2_lock
Date: Mon, 10 Mar 2025 18:03:58 +0100
Message-ID: <20250310170501.106482037@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 84d2d1641b71dec326e8736a749b7ee76a9599fc upstream.

If smb_lock->zero_len has value, ->llist of smb_lock is not delete and
flock is old one. It will cause use-after-free on error handling
routine.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7441,13 +7441,13 @@ out_check_cl:
 		}
 
 no_check_cl:
+		flock = smb_lock->fl;
+		list_del(&smb_lock->llist);
+
 		if (smb_lock->zero_len) {
 			err = 0;
 			goto skip;
 		}
-
-		flock = smb_lock->fl;
-		list_del(&smb_lock->llist);
 retry:
 		rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
 skip:


