Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187DB1990B3;
	Thu,  5 Sep 2024 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530039; cv=none; b=FYmYyxG7CAohx92gA7KCSlr+IpBUxE3E6MashwxzpX8R8WJpzn8Dk7Fl0BpNGTmT4qTGaAE5z7dHUT3T68UGNzOW7rpCY+r3pvdDAEmdy/40MnXzmghwSo6DiFRt2xuB0Kngzqxp2vYGw2ZVe/Ql+fxqft3k2WbsWfVdqBR5B2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530039; c=relaxed/simple;
	bh=LSUDRNvOclBYcRWNZURKvxpkdGS68O2gQekntXN/LV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD+j5Rpe71uzOgiwHB3y9cLcf+xW/nrm/2r412weYMPlbvfaSlthk+ScRVCXSloSz6TfYVFfy2Q52CdsvTi8+cCu3tNmnuXYHMnXqznESFxHvR9Gy2ni/75pawq8RTzqVO+QrKYe+wTB3unfa6FIuNlCskvoQ0n3sS9rza6c+dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjormtvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjormtvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E2FC4CEC6;
	Thu,  5 Sep 2024 09:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530038;
	bh=LSUDRNvOclBYcRWNZURKvxpkdGS68O2gQekntXN/LV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjormtvp71wxZzY/5bLAi0fy6D+O/dioAl1lzXGFRpWNjK6/sG0fwk4FsPGWBm2+4
	 xlAtPlqlKnWZsW7FuMeL5lQsOLt4HLrRds9nuY/7+km8/QO0UGGjcio6RgM0gmIKUL
	 zh4NHpE5tpE/f7fRSST4lNX7GUjd6b1fs3znnV1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.6 036/132] selftests: mptcp: join: disable get and dump addr checks
Date: Thu,  5 Sep 2024 11:40:23 +0200
Message-ID: <20240905093723.646972220@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

These new checks have been recently queued to v6.6 [1] with the backport
of commit 38f027fca1b7 ("selftests: mptcp: dump userspace addrs list"),
and commit 4cc5cc7ca052 ("selftests: mptcp: userspace pm get addr
tests").

On v6.6, these checks will simply print 'skip', because the associated
features are not available in this version. That's fine, except that the
MPTCP CI sets the SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES=1 env var,
which will force these subtests to fail when using the selftests from
v6.6 on a v6.6 kernel, because the feature is not available.

To ease the backports (and possible future ones), I suggest to keep the
recent backports, but skip calling mptcp_lib_kallsyms_has() not to have
the CIs setting this env var complaining about the associated features
not being available.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=bd2122541bd8 [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3472,7 +3472,7 @@ userspace_pm_chk_dump_addr()
 
 	print_check "dump addrs ${check}"
 
-	if mptcp_lib_kallsyms_has "mptcp_userspace_pm_dump_addr$"; then
+	if false && mptcp_lib_kallsyms_has "mptcp_userspace_pm_dump_addr$"; then
 		check_output "userspace_pm_dump ${ns}" "${exp}"
 	else
 		print_skip
@@ -3487,7 +3487,7 @@ userspace_pm_chk_get_addr()
 
 	print_check "get id ${id} addr"
 
-	if mptcp_lib_kallsyms_has "mptcp_userspace_pm_get_addr$"; then
+	if false && mptcp_lib_kallsyms_has "mptcp_userspace_pm_get_addr$"; then
 		check_output "userspace_pm_get_addr ${ns} ${id}" "${exp}"
 	else
 		print_skip


