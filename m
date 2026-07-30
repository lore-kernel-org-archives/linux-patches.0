Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCDD430CC6;
	Thu, 30 Jul 2026 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421529; cv=none; b=spNtgvQt2K7pZj4yA7w8ucvDlvwUBmuIunFapXOZOvJJM+pmgkXouzIj5FYhJulyyWCAwVqqoQnjTtLEfXxQfpCtKjDJ89BzXBmQTvrnDHdEL8oGVXGkF6k/6HkVngIsp4YsnNnTyOWWml95Cmgx3J5bUi7vwAm2vzsUgftPhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421529; c=relaxed/simple;
	bh=TJ/111OAxGRpVQLIKMLb0rlaQnpn9uP150JuVspPDtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1H4xffP5v4XGw2cgXkMikB7HqWpAjlXRuBl8myMj7b9Nw2y00mmIyDrsntebvq87z3jhnfmbRuEvEpqudwuBGipLPVEVvAq0qv3eJiejOoG4tfIqTd1DtIbS65/aDK7r4BtkgmrjprAFjJ3jEB/7Xreqsp/UNkDTcZ1YUtX3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmaBSPeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmaBSPeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E41D1F000E9;
	Thu, 30 Jul 2026 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421527;
	bh=cAuxVwaF/4Rm6dGuSvCJkqzDDwaptI8veDmQsnCyIDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmaBSPeWtuEqkL9m9ZqdiQ5OPEFjrm3YXnSeB5ftkWWGoaZcW13vutqLCnByAQrCe
	 FCLpVnTUojbPJotDIHFUVEsALADRBq3SkGc6XJ/X4niezlOQJVRDYUkwHu7iHifj6u
	 DKr0IZ25Y2Zvu1WXdSxyRq2Z4i/2nCD33wcw0yHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Andre Carvalho <asantostc@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 135/744] selftests: netconsole: only restore MAC when it changed on resume
Date: Thu, 30 Jul 2026 16:06:48 +0200
Message-ID: <20260730141447.149801397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Carvalho <asantostc@gmail.com>

[ Upstream commit 04aeddf2dadd0eb7ad016a766dcbe9c983311f09 ]

The "mac" bind mode reactivation downs the interface, restores the saved
MAC and renames it to trigger a target resume. This assumes the recreated
interface comes back with a different MAC, which is true under
MACAddressPolicy=none (as on the Netdev CI) but not when MACs are
persistent. In the persistent case netconsole resumes the target on its
own, and the down/restore/rename flow instead drops it and fails the test.

Guard the block on the MAC having actually changed so the test passes
under both policies.

Fixes: 6ecc08329bab ("selftests: netconsole: validate target resume")
Reported-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Closes: https://lore.kernel.org/netdev/f398373e-2cb4-4649-a491-9763df94d98b@kernel.org/
Signed-off-by: Andre Carvalho <asantostc@gmail.com>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260710-netcons-mac-reload-v1-1-3fb1bcc70b4a@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/drivers/net/netconsole/netcons_resume.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netconsole/netcons_resume.sh b/tools/testing/selftests/drivers/net/netconsole/netcons_resume.sh
index cb59cf436dd0a3..d9111f2102bcd1 100755
--- a/tools/testing/selftests/drivers/net/netconsole/netcons_resume.sh
+++ b/tools/testing/selftests/drivers/net/netconsole/netcons_resume.sh
@@ -44,7 +44,8 @@ function trigger_reactivation() {
 	# Restore MACs
 	ip netns exec "${NAMESPACE}" ip link set "${DSTIF}" \
 		address "${SAVED_DSTMAC}"
-	if [ "${BINDMODE}" == "mac" ]; then
+	if [ "${BINDMODE}" == "mac" ] &&
+		[ "$(mac_get "${SRCIF}")" != "${SAVED_SRCMAC}" ]; then
 		ip link set dev "${SRCIF}" down
 		ip link set dev "${SRCIF}" address "${SAVED_SRCMAC}"
 		# Rename device in order to trigger target resume, as initial
-- 
2.53.0



