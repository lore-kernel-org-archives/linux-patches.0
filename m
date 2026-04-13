Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAB533D4E2;
	Mon, 13 Apr 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099674; cv=none; b=h9bgK8EjOyJXz2gwR2N1uBD6abfgGvk5k5df1ccpOxs4baL67yCn425Pvie7BP1tqX7nK4TYpH84rsx+g6bJZBqCKPfhTHdmy69HmfCwGGSrka2PWbaRqnAS7lKopfvh2dnx0EdyPTVemBxFIWqHVAQ75N+4OVTftn1QHycyziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099674; c=relaxed/simple;
	bh=g2FvUJV1ltWXKQcyERCAWMnI20BoJGiCE9nnp11rmyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9jDAphlNz5kxaBRnfg9VPgxHCLg8F4DdenWBOHfOCp6prb/lloF2B5ad62G6aBp/cEPfggLm/sK3ti3IymweAT++WXhK28LB3TJfwqWBw1cQwc4s3B2GgBDCWkCvp4VWN0BZ06fql8GOpeitu3dE7mKYe662AyzscSUZxYp+2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qT9yKOok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qT9yKOok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857B2C2BCAF;
	Mon, 13 Apr 2026 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099673;
	bh=g2FvUJV1ltWXKQcyERCAWMnI20BoJGiCE9nnp11rmyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT9yKOokreqc3qLyviXeucNtO68N+RciGi1gCmuVP5fuXFv2S1JUx8mnwKIKVUAJc
	 mvj8+6/e557q/LUfDOOWmb4lwhb36LsDn3Wu1hPrDGD1i59CWJNTLnqAv0n2APKe3f
	 HFudpjPsW8PtzpLKpkpf4jcjGFpM864uF5GxmcRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.10 431/491] apparmor: fix memory leak in verify_header
Date: Mon, 13 Apr 2026 18:01:16 +0200
Message-ID: <20260413155835.164732240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit e38c55d9f834e5b848bfed0f5c586aaf45acb825 upstream.

The function sets `*ns = NULL` on every call, leaking the namespace
string allocated in previous iterations when multiple profiles are
unpacked. This also breaks namespace consistency checking since *ns
is always NULL when the comparison is made.

Remove the incorrect assignment.
The caller (aa_unpack) initializes *ns to NULL once before the loop,
which is sufficient.

Fixes: dd51c8485763 ("apparmor: provide base for multiple profiles to be replaced at once")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |    1 -
 1 file changed, 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -976,7 +976,6 @@ static int verify_header(struct aa_ext *
 {
 	int error = -EPROTONOSUPPORT;
 	const char *name = NULL;
-	*ns = NULL;
 
 	/* get the interface version */
 	if (!unpack_u32(e, &e->version, "version")) {


