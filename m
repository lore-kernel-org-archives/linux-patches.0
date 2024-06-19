Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1162E14A609;
	Wed, 19 Jun 2024 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802671; cv=none; b=aX5qxK8VkPBCdoxd6aGygt2RlyLDqpMDYhV2ZJuSlmeZ8W5TUMUOHoNrTdWxWaiuLGbLuctvGtblcJc76ZQ7QHNUldqvGdpHskKWZSStf6A4FRM8nOze+K6H4ctrHNd7wJvRa/7MYhcIig++RnAut+Bs+BjIvZ5eIHednbgiHDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802671; c=relaxed/simple;
	bh=/lNQcPvVnfcNhfaBYdCq8/0r96ZNK9OUGQ1+SlTCBCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTlBHCyx76a/pXmXJ1hb5oTk+BCiWsGM2Ng90M9Xw5AQJBv+jh/K5I2EpY1zdu3SGKTZxbH/G2pBDcDuddjpLh8rBRqEKuD8NZ+4yzC75gDU1fjG0G6Lj8ieXX+ejkwK0LQ2vcxj2yRyytm9ZMN0KKYYUb287zyCDF57dHSR1WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsUmNbNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsUmNbNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D60C4AF55;
	Wed, 19 Jun 2024 13:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802670;
	bh=/lNQcPvVnfcNhfaBYdCq8/0r96ZNK9OUGQ1+SlTCBCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsUmNbNOM9XQ6pqCunraH1Ko+UW2xt5JqJazXG34nf2fPSe9LWEaJmqY+niryJydm
	 zZOei9WM0Gv0PfUFAC4odgoPX2rXH5hjUn5TiMcW1QFWCfHeHkctN/pFBqkTqbCjH2
	 ujvRGJpwx/gP30nP1Kj2kuvVoNOyV9mZXvQemq/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 251/267] selftests/net/lib: update busywait timeout value
Date: Wed, 19 Jun 2024 14:56:42 +0200
Message-ID: <20240619125615.953274662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

commit fc836129f708407502632107e58d48f54b1caf75 upstream.

The busywait timeout value is a millisecond, not a second. So the
current setting 2 is too small. On slow/busy host (or VMs) the
current timeout can expire even on "correct" execution, causing random
failures. Let's copy the WAIT_TIMEOUT from forwarding/lib.sh and set
BUSYWAIT_TIMEOUT here.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240124061344.1864484-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -4,6 +4,9 @@
 ##############################################################################
 # Defines
 
+WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
+BUSYWAIT_TIMEOUT=$((WAIT_TIMEOUT * 1000)) # ms
+
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 # namespace list created by setup_ns
@@ -48,7 +51,7 @@ cleanup_ns()
 
 	for ns in "$@"; do
 		ip netns delete "${ns}" &> /dev/null
-		if ! busywait 2 ip netns list \| grep -vq "^$ns$" &> /dev/null; then
+		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
 			ret=1
 		fi


