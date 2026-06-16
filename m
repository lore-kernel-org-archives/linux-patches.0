Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32EC44CF44;
	Tue, 16 Jun 2026 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625754; cv=none; b=tgYYcfu6x2t+EQSwh9IVt40y1yqeHZEIhIcRUWM0S8ptczoyTgUtJozBDME8LvcNFN1cE8PqJ4evqUsjK+juxaK6KOF7lLKso1KUASBSF36WREjcrqbVKdfriS6nLalWYHHFBoP/xI3Y5+woZvcSoF/JlLM7LUineMG/eb0MPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625754; c=relaxed/simple;
	bh=WWonGfmLrJPcK1tZ1r+sXf736OGpAfPmzSWzSiII/FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFOzZDSkg/ajDE53wgFHkRetLLc+WMvWuvhmW9YtJSf57VKp0dOu+X5vYd38Moio9FP8V4GjtaAXKocfbDQ6fRVGM3QS3ThRyBRgvdnn6Ly1S03Iu34u0YgYgrqAKANOvWNJGd0H4Syexxqv9CVOcbkxRyyVjiRUcrD0Ghsuix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/P5WwHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/P5WwHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AA91F000E9;
	Tue, 16 Jun 2026 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625753;
	bh=yWJTH2rkGBicfaHlbs+Vzurpy2dPmjtAGFLevHG98rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/P5WwHlzaFErmEP5PzNKGUll3wrESvRf9SLGJWdlVkjXMnQXmDQXUSWz42637P03
	 MSuE8fTix647qSJwV9xK2GdEJCxYa3Az7KIyRWkmbcz48rQXVKo7Sk+DYcQ/04haMH
	 j37FbGJsu/WqUKQcV2+uT5aOpyVMCd8wyaMrMpNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 201/325] selftests: mptcp: add test for extra_subflows underflow on userspace PM
Date: Tue, 16 Jun 2026 20:29:57 +0530
Message-ID: <20260616145108.021799056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit 06fd2bec7aebf393288e4b78924482fe170caabc upstream.

Add a test to verify that when userspace PM fails to create a subflow
(e.g. using an unreachable address), the extra_subflows counter is not
decremented below zero.

Fixes: 77e4b94a3de6 ("mptcp: update userspace pm infos")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-6-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3924,6 +3924,10 @@ userspace_tests()
 		chk_rm_nr 0 1
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
+		# check counters are not affected by errors at creation time
+		userspace_pm_add_sf $ns2 10.0.12.2 10 2>/dev/null
+		chk_mptcp_info subflows 0 subflows 0
+		chk_subflows_total 1 1
 		kill_events_pids
 		mptcp_lib_kill_group_wait $tests_pid
 	fi


