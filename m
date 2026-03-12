Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAA2C032C;
	Thu, 12 Mar 2026 20:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345897; cv=none; b=mrTmVdeq6mIV5KBd1NElNu4z1uOosyC/ggr0LzisZYsJ1ZsNRg3nqRJm3NfKuCSlluPmPLvbjBPt0589vKYoQ5LpXk8bkZHh8wEhhrwOgvL5dv+eWc/m1Wlt/8PRMTGGZdhdYIllc1x1GIzXrCwtnqjt4vQlgj3mcclgEs+whzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345897; c=relaxed/simple;
	bh=DqdijEHRsBZAVoDVUxzZIc9ch6kFKvow//pXumpEVYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN58nAudZskfLUMQ4OfBaN/hYRRvMkxh+0Fzo1/7g6FC8FD1WufCQSbvQLODdWw3vlnijhryEzqAF+LbIfBUuR8A6cpGLlL2pFiU31OHkYaOxKdvxiv+T6FdgOsaRJ6jnQK07IdQGuo+u8oO59eNmDwxTGXATGIXPyyt65fK3tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9vvXQS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9vvXQS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43945C4CEF7;
	Thu, 12 Mar 2026 20:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345897;
	bh=DqdijEHRsBZAVoDVUxzZIc9ch6kFKvow//pXumpEVYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9vvXQS9EJGEGEgurAQgA1ew7BG40v9jUtUM0D61eMfaHWoNaMhNGuYgIRXPo4WoT
	 QewkwlmmWrncQdoTTpdUi6DOUQo++rzcsqNnsBH2f7vCI8Rhusox39WLKy/ynvHrrt
	 Sy3bz3dOwXoUo4YnN8jpowwqSFbDx0vLHIUd5r7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.19 09/13] apparmor: Fix double free of ns_name in aa_replace_profiles()
Date: Thu, 12 Mar 2026 21:03:41 +0100
Message-ID: <20260312200322.014295605@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1149,6 +1149,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 				goto fail;
 			}
 			ns_name = ent->ns_name;
+			ent->ns_name = NULL;
 		} else
 			count++;
 	}


