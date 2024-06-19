Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789B312FB31;
	Wed, 19 Jun 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802647; cv=none; b=LIwyhJFCu+JbiiLEovT+ysPpMUNJW6NqUDjYwg1baukIpk2UxlW2VOZ41QIoYaKfBeb+ssFuAqUQegailRXl1DpjnnXA4UUTgAwUcxYm0QiWsDvV3fcsRVuBRE6SFhID77SIG5mUeSEAbH6RDNwy9T9fYRFjoBYwjWtxPMKA0bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802647; c=relaxed/simple;
	bh=qlyZzCGD4vkj0rY4TB3tZIx9RoBKNBJ0G2cVGxlv144=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roXLfdLYHdOciXyAS3G/zDeAjlAQE6rynromtzTEv9C/TDuHEQFAWIEwj/vIyMT/kEUAaej1KrigzLXN/3mQkDWuGNyAbwVsFPifSSRC4bTa6iyNeGybw3XpnAdUZa6l8wWeqBtxZ34xfOFhDEkhFvW3ZtsK1JIJKvKciAqtkYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2+9tiEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2+9tiEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02D2C2BBFC;
	Wed, 19 Jun 2024 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802647;
	bh=qlyZzCGD4vkj0rY4TB3tZIx9RoBKNBJ0G2cVGxlv144=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2+9tiEMpY81Pquv0eGDfWQYmoKWZtq2bmTHoWcDwPXI5/lvZ/3feisO3r54G1INK
	 m9piRpTl0FDaik3a9rxNCATtYGCSRWsIK7jK4kqHxzZ8ylu2OJq2PV5o85Pz4OSTOq
	 viE3U44XfaQYwEQ70aoYdIdiC1kATYRRUPU3R/OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 253/267] selftests: net: lib: support errexit with busywait
Date: Wed, 19 Jun 2024 14:56:44 +0200
Message-ID: <20240619125616.028227612@linuxfoundation.org>
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
@@ -22,9 +22,7 @@ busywait()
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


