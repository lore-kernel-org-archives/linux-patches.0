Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DEC401A2B;
	Thu, 12 Mar 2026 20:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345928; cv=none; b=IyMYJ5aEqg6dmFMSEctDe+gucI8P1Cd2gzxoPZ3GYSk6zARxTdqVGQCdeOKSU5BXs9FpJi2bFO2AOqcIn5GVMfatR47iUVdtQQBZI7q2C6K3rTzaLMt1CiREk8w2p9Htk4zhPVOfmAFT81YSNjIeGp304rZfLNI0QdRuI8+nr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345928; c=relaxed/simple;
	bh=jcU8SYnwHZnGQCG1W/XeIPF1V+r+onyS9393KuBPT7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcw1XsfGnevdevFBIcNMJlFCRKeVi7ihNytWNIRMZzqXjA/PtxJsdNCwY0xyF0MgLuCfkq5v/VDyPiNV/4cU3x3HgsQf2vK1in2TvDaLnfEezTLAaIRKKtwHFOaY7epcyQFSE2J2VbdzluW7PGUzqKd5CYrw5wu/w9i1qUeQOAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGWRGEHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGWRGEHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D34C19425;
	Thu, 12 Mar 2026 20:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345927;
	bh=jcU8SYnwHZnGQCG1W/XeIPF1V+r+onyS9393KuBPT7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGWRGEHbnFEAXNmk8aPTLhkn33IUPjhzIrGOttnHAqEQOT26T/vI05BSnyi9l9E7k
	 LOPORZ1YG+7xeI0a3FLtxxyaLJcRLL0he+MNPC68SqqxoTnfIS7F7BUMnxAJ5pyhS5
	 4bDm0ne/HtO19oIWRW/XhVPK5xOrcomb4ZBpAph0=
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
Subject: [PATCH 6.18 04/13] apparmor: fix memory leak in verify_header
Date: Thu, 12 Mar 2026 21:03:45 +0100
Message-ID: <20260312200326.409481409@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1177,7 +1177,6 @@ static int verify_header(struct aa_ext *
 {
 	int error = -EPROTONOSUPPORT;
 	const char *name = NULL;
-	*ns = NULL;
 
 	/* get the interface version */
 	if (!aa_unpack_u32(e, &e->version, "version")) {


