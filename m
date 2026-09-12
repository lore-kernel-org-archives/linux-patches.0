Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409739F18A;
	Sat, 12 Sep 2026 19:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240137; cv=none; b=jbQfdbJLmXy5ruaymLI2KD3/0Qy1xS6+wDUAxfRPn7PYBOT112EpTGhHRHyWkq/7ya5pi1tt2PxD2gsz1zmYmWhsTef7R0fm3+SvxV6dgh9ngHNoAhcNIlXAfOlXRHkVuLh9itQ0fvVc14TLHdJbmyEurERGr9t7MhB+8m7RoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240137; c=relaxed/simple;
	bh=UvGxl8LTKwq4HX/Dons4dXgNLT9kjjgeltpdeTFdfN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k0HVMzSK5yLX0TpujHmKMXTUanXki/ukKO1j7o4o9odW+CvRHmLznBzOE7gorIhIF2NJV4e/e1DIIQhmS8PdJwyl5nTjfCNBPNzDF9zsP7SgD8KnELbTLV6sdowp9PCMQMXEwPQhFsAX9kMz7mSrQbz5rS5FRz9AIY9wTLLY04c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7Kw1LGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7Kw1LGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127AF1F000FF;
	Sat, 12 Sep 2026 19:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240136;
	bh=TpM9rTKMfZGAomgoFn1Y9EnNXQdWqJ8k4KbrnfQwKQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7Kw1LGm6dCmoRLIQpYLO0OEAVznXUVjHyrzIlThfAmsalslTWX2AWhGzQlcJmncs
	 aNGcIT749YmojCYhrI4KTjH3wDelBb7UY02S+yRfhqA4O88kzDns32ekr61lFOJild
	 y1NYsvtkZTs2C4uo+8nm4LeUTYPDH04fIFUy1Q9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Xu <dxu@dxuuu.xyz>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 805/935] selftests/bpf: Fix vmtest.sh getopts optstring
Date: Sat, 12 Sep 2026 09:03:55 +0200
Message-ID: <20260912065545.302555111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit a7be0ab1eb1949f3564739784b4360e1233305f6 ]

Before, you could see the following errors:

  $ ./vmtest.sh -j
  ./vmtest.sh: option requires an argument -- j
  ./vmtest.sh: line 357: OPTARG: unbound variable

  $ ./vmtest.sh -z
  ./vmtest.sh: illegal option -- z
  ./vmtest.sh: line 357: OPTARG: unbound variable

Fix by adding ':' as first character of optstring. Reason is that getopts
requires ':' as the first character for OPTARG to be set in the `?` and `:`
error cases.

Note that the ':' as the first character of the optstring switches getopts
to silent mode. The desire to run in this mode seems to have been there all
along, as the script takes care of reporting errors.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Müller <deso@posteo.net>
Link: https://lore.kernel.org/bpf/0f93b56198328b6b4da7b4cf4662d05c3edb5fd2.1660064925.git.dxu@dxuuu.xyz
Stable-dep-of: 3a59f11e0f98 ("selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/vmtest.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 5e43c79ddc6e6..e0c733cf705ba 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -304,7 +304,7 @@ main()
 	local exit_command="poweroff -f"
 	local debug_shell="no"
 
-	while getopts 'hskid:j:' opt; do
+	while getopts ':hskid:j:' opt; do
 		case ${opt} in
 		i)
 			update_image="yes"
-- 
2.53.0



