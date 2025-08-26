Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE0352FFD;
	Tue, 26 Aug 2025 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216820; cv=none; b=U/fO5r4UyohFzELmB3qNAQSXWOAnr6q8tlmiBSgPD2ZdmIxa1aUKyRac3glg+viW5EPWkSlqVh5p2w/d1HydWUnzmNIJjzlIo0SGbw+K27xoMJ70xsWF3cbIjHb2CT9AWig0hNuDDF4Jm5ZsXo0/op8S6JFwauKNz1XufYLe4SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216820; c=relaxed/simple;
	bh=SfKmUmZheLjZBmoIiWcs709HIVlQljh8nqMsNitxIeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q04bPeqFWoiYHcqiQdEG98lGnDom+aOOxprriQvDkMibxS/mOpYdmpMQOLG5HNAHRkOXEF+kf6t/U3Fs5KTodP7Frg69FIncWwf9ockAWL7frMBrEMx69G6MsYXPaWrOd4Guz3uoxBqe1dsnMrUFnHl2niexn+AfIzM7IAPYVCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTQc5p6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTQc5p6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA674C4CEF1;
	Tue, 26 Aug 2025 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216820;
	bh=SfKmUmZheLjZBmoIiWcs709HIVlQljh8nqMsNitxIeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTQc5p6ndujMTJTNIsqw/3Xn5yFfS890OTznlVNlYDrJOO3+XzLRrbBTYh6L1Md8L
	 woaLjt3216sVN0y53KLajmK1lGJlLKE0VrnFF6gt4pKT9vufFJv6ixH4/JEXjfUOFX
	 Gm798CYmqS07y2YS4d3oBZHt1jlAvIGDzTLXtKGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 555/644] selftests: mptcp: add missing join check
Date: Tue, 26 Aug 2025 13:10:46 +0200
Message-ID: <20250826111000.281649161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 857898eb4b28daf3faca3ae334c78b2bb141475e upstream.

This function also writes the name of the test with its ID, making clear
a new test has been executed.

Without that, the ADD_ADDR results from this test was appended at the
end of the previous test causing confusions. Especially when the second
test was failing, we had:

  17 signal invalid addresses     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  add[ ok ] - echo  [ ok ]
                                  add[fail] got 2 ADD_ADDR[s] expected 3

In fact, this 17th test was OK but not the 18th one.

Now we have:

  17 signal invalid addresses     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                  add[ ok ] - echo  [ ok ]
  18 signal addresses race test   syn[fail] got 2 JOIN[s] syn expected 3
   - synack[fail] got 2 JOIN[s] synack expected
   - ack[fail] got 2 JOIN[s] ack expected 3
                                  add[fail] got 2 ADD_ADDR[s] expected 3

Fixes: 33c563ad28e3 ("selftests: mptcp: add_addr and echo race test")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflict in mptcp_join.sh, because commit 86e39e04482b ("mptcp: keep
  track of local endpoint still available for each msk") is not in this
  version and changed the context. The same line can still be applied at
  the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1138,6 +1138,7 @@ signal_address_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "signal addresses race test" 3 3 3
 	chk_add_nr 4 4
 }
 


