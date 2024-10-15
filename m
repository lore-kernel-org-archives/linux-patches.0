Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785241EBFFC;
	Tue, 15 Oct 2024 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994148; cv=none; b=c8D80fsjWkb/wNwzMmN3JYXdSRhsd4pGs5TFo1q8wtHVW2oFbN9Zblg/4bmozB75h7UASSGcnFc1uVSQA7u9m0g8Q5NvKOsY6ns6B7LgA9rMvL74crSIB+hAgLSTxXgmVkMFFr8egaIphbPL5r47UwwxGH2m6mgy4Go73bvb2W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994148; c=relaxed/simple;
	bh=AFyoNz4UyhF7hNBDappx67anYvJfWB4+iCoLWHmKVig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7mPHq/ZAQMVev+Lyoxp8D3QlR3IHPSq/yxdo66jurSgSBFAPa+aZ26V742rKH6aXH+Tphf3OB3jvLvugHNzyRjoeh3Aqte0OtaJVdJ4gjuBhgkwkCetLsySqNbW0OR7BuxtfVx4FQTdcDkieulqwRg1WqLaZ2GBE0RpRD4Yhzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k92aYO/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k92aYO/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05E1C4CECE;
	Tue, 15 Oct 2024 12:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994148;
	bh=AFyoNz4UyhF7hNBDappx67anYvJfWB4+iCoLWHmKVig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k92aYO/ZXSntTIFyb0NWULcDY7kUGIlZZmP2UOo/Bjl2qBIDYPrMPZ3y3jlp/jhal
	 iwyq6+ERoIMAn/LkovI6I2RJVqky0dTfr09ZR16elwABkjyve3Zlumh0pWDLWkMk3k
	 QIXulXw+6xXBrc2OeDuLD3ahyE1QcJJ7cyCRlDQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Thierry <athierry@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 590/691] selftests/net: give more time to udpgro bg processes to complete startup
Date: Tue, 15 Oct 2024 13:28:58 +0200
Message-ID: <20241015112503.765629732@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit cdb525ca92b196f8916102b62431aa0d9a644ff2 ]

In some conditions, background processes in udpgro don't have enough
time to set up the sockets. When foreground processes start, this
results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
refused". For instance, this happens from time to time on a Qualcomm
SA8540P SoC running CentOS Stream 9.

To fix this, increase the time given to background processes to
complete the startup before foreground processes start.

Signed-off-by: Adrien Thierry <athierry@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9d851dd4dab6 ("selftests: net: Remove executable bits from library scripts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh       | 4 ++--
 tools/testing/selftests/net/udpgro_bench.sh | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index ebbd0b2824327..6a443ca3cd3a4 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -50,7 +50,7 @@ run_one() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	wait $(jobs -p)
@@ -117,7 +117,7 @@ run_one_2sock() {
 		echo "failed" &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args} -p 12345
 	sleep 0.1
 	# first UDP GSO socket should be closed at this point
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index fad2d1a71cac3..8a1109a545dba 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -39,7 +39,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
 	# Hack: let bg programs complete the startup
-	sleep 0.1
+	sleep 0.2
 	./udpgso_bench_tx ${tx_args}
 }
 
-- 
2.43.0



