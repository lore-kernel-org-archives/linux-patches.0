Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C434508F2;
	Tue, 16 Jun 2026 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625749; cv=none; b=UxYAOG1ledvaRYfskKk218tJHmzxlswcoy511r1rcLhMT09piDC72W9LDTaRSgkKjzoatu4eWpYYik2WHJXSh9Nq0pzFvq+4H3g4WhnSSrmRlUGDeIspUSm5N7/LUIh9Qd+Zc+s67Csolu9unzPJHB32jgGxitvTNhWuHS8Z3hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625749; c=relaxed/simple;
	bh=Fcr9huVC7TkNWTKP8OjxhnBtWgr9GAgB1gKzmctVCRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvKdJMeoygGvpvIiqvyoxXY7b/1fBU/HsZMjajKHSR5FVVOfn2jZ2tKwmx4dLhKycLJk1w3F2dvMnQfPN9GkqLxcfuj8pCDYox5dFCuvq31EpqntRyEi0mgA5PMYQT5L0FTTDOMVZrCv2pgGEUTmRT3IofYQEMlIQZkgtG8mcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBYijrVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBYijrVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0031F000E9;
	Tue, 16 Jun 2026 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625748;
	bh=U6VmfmUJ08O2cAXmbSqGtyqdUsjwG9kCPObezwymIhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBYijrVgLrex9zZqNTWLOx19rHsMsoqhfxUhAkmfWcy1NG6r/pFaqBd0w/+81i2Ns
	 eFyVRjEHNc/AVJhWXQq1MoRPaKATObA8kJRtwP0W7nyDqQ+RgmU4dwcGiQXFdrZqkY
	 om+k0cmHErGJ4nsFOSLlnqGZUVTyRu+YnZE4vpbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 200/325] mptcp: sockopt: set sockopt on all subflows
Date: Tue, 16 Jun 2026 20:29:56 +0530
Message-ID: <20260616145107.957650330@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 7690137e70ab0fb1f8b5a30e6f087f8ee908b680 upstream.

The mptcp_setsockopt_all_sf(), currently used only with TCP_MAXSEG,
stopped when one subflow returned an error.

Even if it is not wrong, this is different from the other helpers trying
to set the option on all subflows, and then returning an error if at
least one of them had an issue.

Follow this behaviour, for a question of uniformity.

Fixes: 51c5fd09e1b4 ("mptcp: add TCP_MAXSEG sockopt support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-8-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -811,10 +811,11 @@ static int mptcp_setsockopt_all_sf(struc
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err;
 
-		ret = tcp_setsockopt(ssk, level, optname, optval, optlen);
-		if (ret)
-			break;
+		err = tcp_setsockopt(ssk, level, optname, optval, optlen);
+		if (err < 0 && ret == 0)
+			ret = err;
 	}
 
 	if (!ret)


