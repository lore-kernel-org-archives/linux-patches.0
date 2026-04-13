Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41FF27280A;
	Mon, 13 Apr 2026 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096972; cv=none; b=V8v8nj/eFml+sKEFDJgyIEu5XMpYplwyX1+c18Z50Ymh5r4bpqa1Udsd7W53EWhi6tsBR232viN0YAhuPgRNpvpoE6roZh6K5pChVZS34cBWMI6hGrKmLCDMr/ZQhq3GaEfJIiEr5KAx4n+dzzmKEOID1j6Cu8B9NVH0gW8ZIVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096972; c=relaxed/simple;
	bh=9O9Chh7j5eHnMSAnaFbrAwSPbI05EPBcLLTUk5YLyE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeoUfbOuXyD8AH9J265Q4IQdhspD8+mPMMjZpa8n9OrA7RYg+FU28n+8Wb3x7Lm3ZPx5r+8fStzCwdDyZSe9V5ERLUfe1plcvqvcmbVn7Sgoa7kiWytEtVWvdRhVwGxOboTDKfIOeyefoVY+ek0cpQEym5qoMYftSlkXftLXUrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sH9axO8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sH9axO8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE34C2BCAF;
	Mon, 13 Apr 2026 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096972;
	bh=9O9Chh7j5eHnMSAnaFbrAwSPbI05EPBcLLTUk5YLyE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sH9axO8hsMUMryArEi/qUlkBl6b9L6wMfxOJsE46pxaJKGFrdF9rzQICqxxi0Wl1k
	 lqp+2JvwUoCwqLDSCShjmbx+tjuYGxCoxgQY8ZecXEb5dLNxVk3w9oMpstMWySQDNA
	 7RIkpGOc6h9+Aw5v3DvZJ+PXd0HmJgjdVDMbrYSo=
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
Subject: [PATCH 6.1 13/55] apparmor: fix memory leak in verify_header
Date: Mon, 13 Apr 2026 18:00:47 +0200
Message-ID: <20260413155725.323691282@linuxfoundation.org>
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
@@ -959,7 +959,6 @@ static int verify_header(struct aa_ext *
 {
 	int error = -EPROTONOSUPPORT;
 	const char *name = NULL;
-	*ns = NULL;
 
 	/* get the interface version */
 	if (!aa_unpack_u32(e, &e->version, "version")) {


