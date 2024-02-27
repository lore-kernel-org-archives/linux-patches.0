Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069E313EFE9;
	Tue, 27 Feb 2024 13:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042166; cv=none; b=Mw7JBzwarXFtyEXiAuM38j3YUu5rTfiqOm/H1/3nKvTBJTPBCANn6A8mTq2dN7roRH+gyfIhlGeUQnrC1MprzLzYLyimnGweRPTbxFvKksAjP6HXqNEu5bDJSYTrEszILcZtSru/J14MgKY6dbq55hwyu+PB64B+2PiBf1DV59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042166; c=relaxed/simple;
	bh=vQ1rtxZmbNLumLWD+mNC3kvFf5pUeGYxGGiRvowrjac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TntvCq1Cu1MTjCkh//ts3ybKJKWnsZOa6Y+hIbbSD3OZCUYHVKoJiJ4LQQsN7k72QjVbutceUsf0ec6Js1eIty7GkM+AHfCP19Zyge13iA/CgfbmDBL+qb6yDj5jP1MyuASaix3p0FzBpOW4kJgzV1lDJsZ/54QKNda1Pv4D5Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZRDDOw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZRDDOw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86958C433F1;
	Tue, 27 Feb 2024 13:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042165;
	bh=vQ1rtxZmbNLumLWD+mNC3kvFf5pUeGYxGGiRvowrjac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZRDDOw8tSwrtrwE15qnJFyRno7yutRpLEQ9OBAPLslIvCBdZhaggFqX8fNCjThiY
	 450SO4Nx38JDzsrj49z1rdBYryK9r3aJHWHzbs8IV1B5M0lwPMSH+RhSKzLlLvHDJ1
	 cdlpPO29TK1hmuVYzg7XKLTJ6lJyKquyLZpZqrWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 202/299] selftests: mptcp: diag: fix bash warnings on older kernels
Date: Tue, 27 Feb 2024 14:25:13 +0100
Message-ID: <20240227131632.307720815@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 694bd45980a61045eb5ec07799e3b94c76db830e upstream.

Since the 'Fixes' commit mentioned below, the command that is executed
in __chk_nr() helper can return nothing if the feature is not supported.
This is the case when the MPTCP CURRESTAB counter is not supported.

To avoid this warning ...

  ./diag.sh: line 65: [: !=: unary operator expected

... we just need to surround '$nr' with double quotes, to support an
empty string when the feature is not supported.

Fixes: 81ab772819da ("selftests: mptcp: diag: check CURRESTAB counters")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/diag.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -62,8 +62,8 @@ __chk_nr()
 	nr=$(eval $command)
 
 	printf "%-50s" "$msg"
-	if [ $nr != $expected ]; then
-		if [ $nr = "$skip" ] && ! mptcp_lib_expect_all_features; then
+	if [ "$nr" != "$expected" ]; then
+		if [ "$nr" = "$skip" ] && ! mptcp_lib_expect_all_features; then
 			echo "[ skip ] Feature probably not supported"
 			mptcp_lib_result_skip "${msg}"
 		else


