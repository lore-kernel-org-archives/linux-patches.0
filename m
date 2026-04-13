Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E823093CF;
	Mon, 13 Apr 2026 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097057; cv=none; b=HZH6j3TN9c9GkiLBizC6ZdL+6SMcpvuNhGw/74hB4yl3vkPiSksw+fo5PkDzPmntsi2gyQ7SqhbrEbWBNMEHJWUZs3wKScN3K1fYTDcin3EavKq8oQDoi4XOQPYrcGniPYFrqFyg5ciNru0nzBB/fJ2E4xSvrDTJk6BATaL2cBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097057; c=relaxed/simple;
	bh=WC8MpXjO/Esh4FjgoPOfuy7C7zTn2WEo8j38J4683zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdUnNlg9WoJ5mz70MIBxciYGhBwjxgsxfP+/Wj3dSnKXiZi7SrNe04wtDE3990/KelN7v7KSU8nue37oD0oHjNUl3cR+GWYkvXns37o7JXk6eL+OEtznjZ4HbI0vebAyzBbtyj3B3HU9V+lmh5jTSV3gFB2LhzvIYsVUftVIBzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgNKA7yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgNKA7yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD001C2BCAF;
	Mon, 13 Apr 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097057;
	bh=WC8MpXjO/Esh4FjgoPOfuy7C7zTn2WEo8j38J4683zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgNKA7yg08iApNvge5zy8BKy4iP8OS4F9mhfW8KAfVZdS881eMjXJ+01AsqFWL3yJ
	 ZDIb/IJZ4uq9IQ1DN/XXF1ybFXNTS/+875e476Vc88OUBFwUwGlQHFI/TlDTVu91Rx
	 XlHmTNqQzZ/oFw48y29yXsLf+nI1bNZNEvr+CcG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.1 18/55] apparmor: Fix double free of ns_name in aa_replace_profiles()
Date: Mon, 13 Apr 2026 18:00:52 +0200
Message-ID: <20260413155725.508565738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

commit 5df0c44e8f5f619d3beb871207aded7c78414502 upstream.

if ns_name is NULL after
1071         error = aa_unpack(udata, &lh, &ns_name);

and if ent->ns_name contains an ns_name in
1089                 } else if (ent->ns_name) {

then ns_name is assigned the ent->ns_name
1095                         ns_name = ent->ns_name;

however ent->ns_name is freed at
1262                 aa_load_ent_free(ent);

and then again when freeing ns_name at
1270         kfree(ns_name);

Fix this by NULLing out ent->ns_name after it is transferred to ns_name

Fixes: 145a0ef21c8e9 ("apparmor: fix blob compression when ns is forced on a policy load
")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -958,6 +958,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 				goto fail;
 			}
 			ns_name = ent->ns_name;
+			ent->ns_name = NULL;
 		} else
 			count++;
 	}


