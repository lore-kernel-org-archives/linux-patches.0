Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A62E06E4;
	Tue, 25 Aug 2026 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665176; cv=none; b=em6jUawfDQ0O6awiL63jmvLcUA4/4ECLYgit+Cx7yXImlbYABRoL298sl1w7GAROB8pa265aTh4+++i+AAxY1AUgqB+kUdB/XWItGu0pz6oKigEqQr5MbpJRVTzCveftyJYio1OTw3E4vKIR0xmWgSxgxUMj6UAZBtTiY37HVNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665176; c=relaxed/simple;
	bh=vlJ2sDft+a3BYVsQoGBz4ExB88y4pbWECvMHIx0hwww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjUUMgcpV4vgrMzwpC3CyM0Mtuc/QRV/Xi6Eo9NCSNj7rj5qAvIYjJ60n00l+8yRt+xxchCVe+QKHyf+vFX7sTY7wen/33Q3RDUA9XPpWLk+Jizg1d7IQUi+52LRavn8Z6telCLwwzNwIX6Jwqvl9D9oQJdqRLjnAXZpmLGFJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vf3i41TQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vf3i41TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270DE1F000E9;
	Tue, 25 Aug 2026 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665175;
	bh=3b7ut2BXuurYrBhrZBk+UHldNxqhr3LnwhBBcxhrg38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vf3i41TQ4BVnEljrJtn+/brNKzxDvceq+oab2OAe0eNRLgKYoHPBzqLIAb+jYgMwX
	 Y7ulN3nHfqnrOyVGX38c3GG89kDmWhbcoXmjc3pq/Wowxlj++0SvxNiYypaOmi4HMk
	 VFm15d5ApKEhcwgAkTlD/Hx/PUGX6q4VzF6hU6SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 05/94] xfs: rtsummary scrub should treat rtbitmap corruption errors as an xref error
Date: Tue, 25 Aug 2026 15:25:01 +0200
Message-ID: <20260825132542.093060312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 8ed78104722b57df69478b0b1608a408c1036085 ]

LOLLM notes the discrepancy between the comment saying that this is an
xref error and the code, which marks a (non-xref) corruption error.
This appears to be a regression.

Cc: stable@vger.kernel.org # v6.13
Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ changed `xchk_ip_xref_set_corrupt(sc, rbmip)` to `xchk_ino_xref_set_corrupt(sc, rbmip->i_ino)` since the renamed helper is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtsummary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -359,7 +359,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ip_set_corrupt(sc, rbmip);
+		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 	if (error)


