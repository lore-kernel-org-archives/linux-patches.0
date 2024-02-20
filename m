Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813B914F9C8;
	Tue, 20 Feb 2024 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464411; cv=none; b=uhm8GgTfsMNTMqvW8Wb5Dl/9WqkcxDX5+6CnA1pMuwbHUPrnEVv/vek1K17N896n+zeE6crO1tss/xGJXr6DEikKhYGR/4KvJGnm3eChNGdvkmi1DH5Qbw9A7YztfX2d75iHBCRM/CID3OHGHCbxjXVOP7LRxRO2d2eT+g+whdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464411; c=relaxed/simple;
	bh=iuIMTSktW5AZffAcaZblpyZL9x8zFXvaSccJ0JdonY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUFVM9aN6PFY7rc9mans8/OMPG0yPdiUEKTD6yYqz4QNQ8APzbSOuyrK1L6gzAtFYfkxpwEq7rViIXPhzkliOEAISI/qhDUFdoQwE+78VJjn/to74u7L4ijwfft8wOEyCYDQWtxqHUnfKxQ0bVrDCbOhcHi959+nSurXp49mPjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eej3Tegd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eej3Tegd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B18C433F1;
	Tue, 20 Feb 2024 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464411;
	bh=iuIMTSktW5AZffAcaZblpyZL9x8zFXvaSccJ0JdonY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eej3TegdR/8KjwzrYqIwyd4/I2L+FshEV7qsSFZWaz6znj9su9qqKi+Sj9nhZmPlf
	 HBw/AIfWPryvng2OsRybMXZYuzjFWv9yo+rZMrd+FWugoiyBos/mUoFZ9VkQWz5qmY
	 lsKC9Gzq60wt/3B1br18SS+TtWx2ZMNO5G8BX73Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 017/309] kselftest: dt: Stop relying on dirname to improve performance
Date: Tue, 20 Feb 2024 21:52:56 +0100
Message-ID: <20240220205633.701678922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 6154fb9c2134f8d9534b2de10491aa3a22f3c9ff ]

When walking directory trees, instead of looking for specific files and
running dirname to get the parent folder, traverse all folders and
ignore the ones not containing the desired files. This avoids the need
to call dirname inside the loop, which drastically decreases run time:
Running locally on a mt8192-asurada-spherion, which reports 160 test
cases, has gone from 5.5s to 2.9s, while running remotely with an
nfsroot has gone from 13.5s to 5.5s.

This change has a side-effect, which is that the root DT node now
also shows in the output, even though it isn't expected to bind to a
driver. However there shouldn't be a matching driver for the board
compatible, so the end result will be just an extra skipped test:

ok 1 / # SKIP

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/310391e8-fdf2-4c2f-a680-7744eb685177@sirena.org.uk
Fixes: 14571ab1ad21 ("kselftest: Add new test for detecting unprobed Devicetree devices")
Tested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240122-dt-kselftest-dirname-perf-fix-v2-1-f1630532fd38@collabora.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/dt/test_unprobed_devices.sh | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/dt/test_unprobed_devices.sh b/tools/testing/selftests/dt/test_unprobed_devices.sh
index b07af2a4c4de..7fae90293a9d 100755
--- a/tools/testing/selftests/dt/test_unprobed_devices.sh
+++ b/tools/testing/selftests/dt/test_unprobed_devices.sh
@@ -33,8 +33,8 @@ if [[ ! -d "${PDT}" ]]; then
 fi
 
 nodes_compatible=$(
-	for node_compat in $(find ${PDT} -name compatible); do
-		node=$(dirname "${node_compat}")
+	for node in $(find ${PDT} -type d); do
+		[ ! -f "${node}"/compatible ] && continue
 		# Check if node is available
 		if [[ -e "${node}"/status ]]; then
 			status=$(tr -d '\000' < "${node}"/status)
@@ -46,10 +46,11 @@ nodes_compatible=$(
 
 nodes_dev_bound=$(
 	IFS=$'\n'
-	for uevent in $(find /sys/devices -name uevent); do
-		if [[ -d "$(dirname "${uevent}")"/driver ]]; then
-			grep '^OF_FULLNAME=' "${uevent}" | sed -e 's|OF_FULLNAME=||'
-		fi
+	for dev_dir in $(find /sys/devices -type d); do
+		[ ! -f "${dev_dir}"/uevent ] && continue
+		[ ! -d "${dev_dir}"/driver ] && continue
+
+		grep '^OF_FULLNAME=' "${dev_dir}"/uevent | sed -e 's|OF_FULLNAME=||'
 	done
 	)
 
-- 
2.43.0



