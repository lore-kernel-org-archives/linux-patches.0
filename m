Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39C31E871;
	Fri,  6 Dec 2024 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497301; cv=none; b=Hgc53mYG5xsqDn2YAI7mVtT48sOVYIj0Am4Zmgn9bcmp0lOR6c7JO6Ju1FnYj/H+OxsWi2guZZ33Szw3uYi4VbkPs/FPDwGRkWUoWtge5lbZtKmKkizViEBDA98RI6sG7HdVPWpXZtkNFePXStBkDCuf/tF9Ly1gyyhwlclIrLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497301; c=relaxed/simple;
	bh=KqZO6uSHWWhcP9/GWVumhjFJ1Yjm3bWHH2NvhrR9VXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc5nbDb/IPmN3Xyzh1KrP/CtW2ESDaoWREVNMCuTycgbv7L7OIieEnk+jH6jZcH3ARf9rL2k0VgcexKAjbNYM5B/DD/p6byM6fX1eboKFDZ0uxkuUZfFVD+88zBdK6CNM3uj/9phpoMopeKCMIuU8nGJwsucnh08nearDM8OMYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q92K33od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q92K33od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FCCC4CED1;
	Fri,  6 Dec 2024 15:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497300;
	bh=KqZO6uSHWWhcP9/GWVumhjFJ1Yjm3bWHH2NvhrR9VXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q92K33odASRAP4lRD0t9Mird1vziVGfT1FMNe+QuWEsQeOKtkwlh0c50JtttNGXMR
	 2w+arraJpc9hh5EQ3ofjcfEczyPKRpJth7E5hlIK+mX2bRa660h9Lw0RDvslsRMP84
	 sQriAAkoSsd9k2p+3BBD1AS0Pe+wcoF0caJ3I7jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/676] selftests: net: really check for bg process completion
Date: Fri,  6 Dec 2024 15:31:04 +0100
Message-ID: <20241206143702.901696430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 52ed077aa6336dbef83a2d6d21c52d1706fb7f16 ]

A recent refactor transformed the check for process completion
in a true statement, due to a typo.

As a result, the relevant test-case is unable to catch the
regression it was supposed to detect.

Restore the correct condition.

Fixes: 691bb4e49c98 ("selftests: net: avoid just another constant wait")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/0e6f213811f8e93a235307e683af8225cc6277ae.1730828007.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index d65fdd407d73f..1c0dd2f781678 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1961,7 +1961,7 @@ check_running() {
 	pid=${1}
 	cmd=${2}
 
-	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "${cmd}" ]
 }
 
 test_cleanup_vxlanX_exception() {
-- 
2.43.0



