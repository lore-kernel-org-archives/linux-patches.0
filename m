Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476DF1A680C;
	Mon, 13 Apr 2026 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098414; cv=none; b=OMHLHf43Oaf4e9SOxCqcYU1rsqZG5u/K2dqRJxiZf0X9sy3FxelksoaL6HNxaqRDLf8vuFYcfBKwgF4rgNwjQYCRYommdBGcjDG5y8YqW2NixdxJ8iRPYRCTFUsMjI8VlFXqvLARsBzbLbGUhe/Cqo8MC79rTP+5m8emUzfVGCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098414; c=relaxed/simple;
	bh=ZJIBRaZM9zbElUd9B2m8zByh9HzqgJ+jpNkJBoJuD4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDgTkWA35Hnh4cutLi6at8oaEWvr2a6yniGlUwWnTlbfBGVPDzkNgHko2Nvz2v7Yfvgm/8oIK99+43OssZQx4+mFAGDTxId410wqGW9Ukf9Xd+HSm+dq1XGgd2GVqzkvRngb5h/G6s1MKAQXgQ2jkBSX7jgsIBo5zKboANPE3+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+048z6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+048z6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14C6C2BCAF;
	Mon, 13 Apr 2026 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098414;
	bh=ZJIBRaZM9zbElUd9B2m8zByh9HzqgJ+jpNkJBoJuD4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+048z6Rw90Q+ccXQiQpunQgXKOxTDtHqEIj63T+HUGWL2WmrbHi6bPy29wHGVq8C
	 z7+pYXVUM7IiFVG3VvWKF3f0Ti1FxQNq/SkEbKuUbcGdDd/XhdAz5yuVbPizss9vGj
	 kcVCtYQZNqQp4LvAIoFaml7XbE4VouK1U4itZ2uk=
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
Subject: [PATCH 5.15 516/570] apparmor: fix memory leak in verify_header
Date: Mon, 13 Apr 2026 18:00:47 +0200
Message-ID: <20260413155849.778088558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


