Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24FC2C17A0;
	Thu, 12 Mar 2026 20:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345879; cv=none; b=sgWnIah1KqjdosAI27ZfiK6aA2DamTfKzFC8EZ/9v2OD7PCqeHxkDhCWK/FOgbfg2XKAYewxBdVN/9R4pcjql/bPTLOoz1lm7Kx1zyJ993kLn1F272PtK9jmUe6WV7S42w7sjZQw9sXd3tSlGk+0YUHeDVbJrmkQ/5IkvdPymvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345879; c=relaxed/simple;
	bh=1UYFNucSuwLme+T3UMlM7VTTsrfz8NVyPQr+az6AmnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ9Qqp/LQR00Tk/5yostaqAjQ4wBbga/T4v1BpdF1S+xChF9s1cyB9bojZFkz6fTvnJJ/oeHLaXIOpIFjFLYuC6mPaovnjx5g8YJmE6e4el2VZa8gPwEm+hN3qHjxWj+BGF4aYjgrX9zGOHJaIuF0nPp4ZlTcDd8dRjJ7sVZkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7CDthNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7CDthNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567B1C4CEF7;
	Thu, 12 Mar 2026 20:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345878;
	bh=1UYFNucSuwLme+T3UMlM7VTTsrfz8NVyPQr+az6AmnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7CDthNjG0uqapxUKATP4e5opQU7ZguRcy3C3DpOtLI2wO1B7a9POiCB+ZuoZiTOH
	 gNgUT+nlmPySLAEuH6/QB8/iSLYTdxHMEmo7gvF8OKctkSv1SOvz5gnTBu+Rn22/Jy
	 oRvu6Rh1EdE6GVaHEJawEUAQ/wZJ50SdY+vxu2Xw=
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
Subject: [PATCH 6.19 04/13] apparmor: fix memory leak in verify_header
Date: Thu, 12 Mar 2026 21:03:36 +0100
Message-ID: <20260312200321.835243502@linuxfoundation.org>
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


