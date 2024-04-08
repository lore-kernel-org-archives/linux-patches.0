Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A11768EA;
	Mon,  8 Apr 2024 13:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582796; cv=none; b=CMLPFBfpf5hfxivY0IQGJUQ9uhK4UFMuNYZXe3Rm6cF1xiiDtQr/FfmtBMiqec9+qy/V1IS2tPTTqbz45IU1uvg3DcehoaHKQPYONyn3uARGrVFksHihuxLjW2/6KASyzP3IQ2+so4aHh9DdWXTfSyEToyiExmT9C0zAOahbroo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582796; c=relaxed/simple;
	bh=6YBEHVxYjXe25cpSd6sBP2WTDbR1eItjZMQJqD9UyTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnhTdlcLC5+MZiVWBBICAPWOs4A5TFyrFVm2lglN1AB/34S2tN56x3NU4Kkak/WHP2amyYd+X3RsevriW4As18jFIaJsbxwVk/h9Y0FM1JCcVNbLZHhM51spI/5ZdjA2B8r7SZSbS91/HQUSOuILRm6nl8ov0N3Ikfet2ovh0oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YvZ+xo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YvZ+xo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D088C43390;
	Mon,  8 Apr 2024 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582795;
	bh=6YBEHVxYjXe25cpSd6sBP2WTDbR1eItjZMQJqD9UyTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YvZ+xo0CSZ0FDYpHuqBnBnCc2FbOLTgbIYgViHrSWClHoyag7EolvXsfwmy5HOih
	 /5lgYwk32ogwh5W8VixBA6a0Suk+EW439h31wHwvUbapEjGmBtTRAUrK4LcBKyIJL/
	 c8VXpLUP02gvRnquhTFa4Jl6LiaXzRsxnNSOW5Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 134/138] selftests: mptcp: join: fix dev in check_endpoint
Date: Mon,  8 Apr 2024 14:59:08 +0200
Message-ID: <20240408125300.397182348@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 40061817d95bce6dd5634a61a65cd5922e6ccc92 upstream.

There's a bug in pm_nl_check_endpoint(), 'dev' didn't be parsed correctly.
If calling it in the 2nd test of endpoint_tests() too, it fails with an
error like this:

 creation  [FAIL] expected '10.0.2.2 id 2 subflow dev dev' \
                     found '10.0.2.2 id 2 subflow dev ns2eth2'

The reason is '$2' should be set to 'dev', not '$1'. This patch fixes it.

Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240329-upstream-net-20240329-fallback-mib-v1-2-324a8981da48@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh: only the fix has been added, not the
  verification because this modified subtest is quite different in
  v6.1: to add this verification, we would need to change a bit the
  subtest: pm_nl_check_endpoint() takes an extra argument for the
  title, the next chk_subflow_nr() will no longer need the title, etc.
  Easier with only the fix without the extra test. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Notes:
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -725,7 +725,7 @@ pm_nl_check_endpoint()
 			[ -n "$_flags" ]; flags="flags $_flags"
 			shift
 		elif [ $1 = "dev" ]; then
-			[ -n "$2" ]; dev="dev $1"
+			[ -n "$2" ]; dev="dev $2"
 			shift
 		elif [ $1 = "id" ]; then
 			_id=$2


