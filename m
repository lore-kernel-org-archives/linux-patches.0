Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C567143C7E;
	Thu, 13 Jun 2024 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279469; cv=none; b=pna1Y3WyjNjZ+zwppq+daeargdmEZKldtq6HQ9x3KHmea5PflnMSi2nbCpOUP9+fB/3LinGGbW6ufSGHp0ErNtvKKtl5yrTagmNSCOBr54DisZ56O7Cbjy4ksfrxZR/TITk8542Cr8Wtf5qQNBa9acQSEJ5lvQ0uFZ9duHoZIec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279469; c=relaxed/simple;
	bh=pG3UwjcctmKV5cBEqEeYFmkfyi3JXfl/h+l0PCrUhzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8gY8OvcG/5P3CIKd5XIHVfekOa6Zf/xCNbDcXB9P9MQsxTpdZ2lMeipLks0w2t7QCvFRENjred0DLDnuKhxGBFToyQ/ALsKehVfrqSxB+28M+znFKo5P6NEXWZt8f/hnaproKqhGCJvWXz1HbPqn0AcOHoC54cwpRknl/H1LQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPsiD9g5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPsiD9g5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E920EC32786;
	Thu, 13 Jun 2024 11:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279469;
	bh=pG3UwjcctmKV5cBEqEeYFmkfyi3JXfl/h+l0PCrUhzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPsiD9g54ypwBtQSWYKbZgaWCkouEFuuio/LCrFCsZniJCedhfoIV+0olES0BT4BZ
	 HKsPhVr87hZ/+LGrT7SxBVw9QPY/dMZIxtPxPkPzaL1E8/fzzie9q89XNl/MLjXkFM
	 aThkzwDl8AIBcgGpc84OSer4gpQCj8O0A2rpGVBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 085/157] selftests: net: lib: support errexit with busywait
Date: Thu, 13 Jun 2024 13:33:30 +0200
Message-ID: <20240613113230.714557075@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 41b02ea4c0adfcc6761fbfed42c3ce6b6412d881 upstream.

If errexit is enabled ('set -e'), loopy_wait -- or busywait and others
using it -- will stop after the first failure.

Note that if the returned status of loopy_wait is checked, and even if
errexit is enabled, Bash will not stop at the first error.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Cc: stable@vger.kernel.org
Acked-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20240605-upstream-net-20240605-selftests-net-lib-fixes-v1-1-b3afadd368c9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -63,9 +63,7 @@ loopy_wait()
 	while true
 	do
 		local out
-		out=$("$@")
-		local ret=$?
-		if ((!ret)); then
+		if out=$("$@"); then
 			echo -n "$out"
 			return 0
 		fi


