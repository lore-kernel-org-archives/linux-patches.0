Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C68274FE3;
	Fri, 21 Nov 2025 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731564; cv=none; b=hd4QKfwq+PYGPR9cNKU3UsK6MFn4REy+ljwmRk6PA9qNKJuv7CDsm4RREDgiJSQbWEWm+wTqnB0Q5MJDPlutkuaYSv/2ez0iTavSxPgDj6jWEClKzBi25LeJSBLgcpTbR9LPdxNgdcuLuCaUd6q1F3T6r8HDiPCdQZRXG7vEGf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731564; c=relaxed/simple;
	bh=tJrhTZcLj39nLvgSDpemiszWzI4diyURUJNk60wN6Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLkE5VmDmjgfdmGl7TZjDN+tMrKkXss/x16RnJqtuglDrLyy7bNmpdOEahznvqotJQHkLo9TE/L4lPDbK9uNiI2M5R7UrlWIN7fstxumog/P3OMkErx3ivHtTMskeCH7lJMgeGEjqa/u+bmv7SLph7RbqaaZAORI/GN/yLCpd2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQStGtPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQStGtPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA6FC4CEF1;
	Fri, 21 Nov 2025 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731563;
	bh=tJrhTZcLj39nLvgSDpemiszWzI4diyURUJNk60wN6Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQStGtPRPL9VW07/8eM1t9y2QFUU7NfWKlm4caBgwBwNLYOMBJU/qOGMl8Z36HFYr
	 26TnJ0TeRgEn9dxGUkuQ+7w3SvtDHiTNlb857VWu7qerSFBmsQSChWcpbnbfPl/Da9
	 VP6Ea7DrEXsNWKjXLZ9gZBfqZSLkF1mecv2xSJmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 230/247] selftests: mptcp: connect: fix fallback note due to OoO
Date: Fri, 21 Nov 2025 14:12:57 +0100
Message-ID: <20251121130202.989974740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 63c643aa7b7287fdbb0167063785f89ece3f000f upstream.

The "fallback due to TCP OoO" was never printed because the stat_ooo_now
variable was checked twice: once in the parent if-statement, and one in
the child one. The second condition was then always true then, and the
'else' branch was never taken.

The idea is that when there are more ACK + MP_CAPABLE than expected, the
test either fails if there was no out of order packets, or a notice is
printed.

Fixes: 69ca3d29a755 ("mptcp: update selftest for fallback due to OoO")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-1-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -492,7 +492,7 @@ do_transfer()
 				  "than expected (${expect_synrx})"
 		retc=1
 	fi
-	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ] && [ ${stat_ooo_now} -eq 0 ]; then
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ]; then
 		if [ ${stat_ooo_now} -eq 0 ]; then
 			mptcp_lib_pr_fail "lower MPC ACK rx (${stat_ackrx_now_l})" \
 					  "than expected (${expect_ackrx})"


