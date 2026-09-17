Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7514ED1BA;
	Thu, 17 Sep 2026 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660571; cv=none; b=AXvOj9nVxFJQCavx074wOUO0m9fErPC6eQ29zqdIRPKhOVJk33/Xf91WAa8+hsQfe1BlS1H/eMJn4lQVz3UsmlboJ2onji/Fawah7PYbhaQIDz+vPytsoKsk1PTG6hzwexYZERpZygPnk8KFn+6lww5Vd12lx7taaek/GUKW/Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660571; c=relaxed/simple;
	bh=m0LulyMdre23i9Il+cdBNTkZNkR6W1gE3RCSzI8IWzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxjqix+r0V+0RGqhxVEUBb0uFzDXaKKoFOiwjy99zHavNDrLi4IuUDLj7R3SD7kchM/VlQhQKgKXNQ977h2ATYM61TAEYGNx1SyxO/GwKukljeaOnxrWSpBKO23Mh/WB2mZccd/inSlJ2SfbIdwm84MFY8RXzLYBa7nsMVM23vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kglnw1pi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kglnw1pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28D51F000FF;
	Thu, 17 Sep 2026 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660570;
	bh=un4pBvTL8u93gi/bc91xCPfIzJk5Xeot5ghR2JhL6Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kglnw1pii6hH9ZgQnufu6sIGmUdqnh73Up3dbZ1Nq2gIBlwTKrx5fdSAMAQhsc8uT
	 L2lEuX80/qKmFNvrgBPBlgJyCxNCs+kMAun7hXPrWUWR4yKbAzENt/2HIIMXq8P3+O
	 Y0R0odOBC5oGFUD/IopTXz9eEVqFO5ckAoRaSQHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 619/733] selftests: mptcp: lib: get counters for the right test
Date: Thu, 17 Sep 2026 16:15:27 +0100
Message-ID: <20260917151407.957616584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit d23c41366e85f149b48323d66adc36c4a9f18cbd upstream.

When the value for a MIB counter is required, mptcp_lib_get_counter is
called. It tries to use the cache, if available. If not it falls back to
calling 'nstat' directly by looking at the absolute counters.

That's an issue for tests that don't recreate the netns for each
subtest. In this case, 'nstat -a' will look at the counters for the
netns.

Instead, it should look at the increment for the current test, by using
the history recorded in /tmp/<ns>.nstat, if available, and not using
'-a' which was dumping the absolute values.

While at it, rename the previous 'hist' variable to 'cache' as it was
used to look at the cache, not the nstat history.

Fixes: 71388a9f331d ("selftests: mptcp: lib: get counters from nstat history")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-12-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_lib.sh b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
index da1da414c30f..b9d14647f401 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -416,19 +416,21 @@ mptcp_lib_nstat_get() {
 }
 
 # $1: ns, $2: MIB counter
-# Get the counter from the history (mptcp_lib_nstat_{init,get}()) if available.
-# If not, get the counter from nstat ignoring any history.
+# Get the counter from the cache (mptcp_lib_nstat_{init,get}()) if available.
+# If not, get the counter from nstat ignoring any cache, but using the history.
 mptcp_lib_get_counter() {
 	local ns="${1}"
 	local counter="${2}"
-	local hist="/tmp/${ns}.out"
+	local cache="/tmp/${ns}.out"
+	local hist="/tmp/${ns}.nstat"
 	local count
 
-	if [[ -s "${hist}" && "${counter}" == *"Tcp"* ]]; then
-		count=$(awk "/^${counter} / {print \$2; exit}" "${hist}")
+	if [[ -s "${cache}" && "${counter}" == *"Tcp"* ]]; then
+		count=$(awk "/^${counter} / {print \$2; exit}" "${cache}")
 	else
-		count=$(ip netns exec "${ns}" nstat -asz "${counter}" |
-			awk 'NR==1 {next} {print $2}')
+		count=$(NSTAT_HISTORY="${hist}" ip netns exec "${ns}" \
+			nstat -sz "${counter}" |
+				awk 'NR==1 {next} {print $2}')
 	fi
 	if [ -z "${count}" ]; then
 		mptcp_lib_fail_if_expected_feature "${counter} counter"
-- 
2.55.0



