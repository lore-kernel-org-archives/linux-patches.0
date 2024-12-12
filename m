Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D98A4F218;
	Thu, 12 Dec 2024 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023993; cv=none; b=MMzEJ6yFE38tEsjIbl93XGqoF8mwdtCiIYkGuEz/Y28yqeTLK0L7yxEfGv0ghTZs49HN+FlyczlnpilerahqFR5U7rH0nDyX2Ba7lZZwSfC7hAaSpOhOOncpD1ggRNDwY+gpsv7qcxOpjGVOy5ychV36UOqrJL2y4SG9sXcbyyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023993; c=relaxed/simple;
	bh=P6e0krtkgBbbzgdEXCcQApvTuRv2+6TRzV9pXO/jZW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPkgCjaDHrSHZQzR742Le0rKNxN6yb8Z3W3lmq+5wldYW/xCxgyNmGEBG1+E0BsgQqCxp+SnkYb2RDPMS4I3cO1RhR21z0RyjmHxrUYP4xCiKcPE+liT4UZW0oq4X3d9eS3AIlrWoXL3xPB7Nj63OxS0yTTb+WLLcoc90I3J8fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYg6jBep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYg6jBep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8A5C4CECE;
	Thu, 12 Dec 2024 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023993;
	bh=P6e0krtkgBbbzgdEXCcQApvTuRv2+6TRzV9pXO/jZW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYg6jBepq893Z0ynRD2G3BE0AT8/dCCpa/5tu8YfttzTKdgUZVMK4j1oxG2UaPi5P
	 7cQYx8TC3MdXVvmvhDBoR2JvUIlTE3z2IzJojrp62v2VII/zPcsqcFH4xcxABAzMQw
	 D3I7Cy+PKlQ7e01jZ+0nTaaoDYJIsoZ3m74Vxu2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/459] selftests: net: really check for bg process completion
Date: Thu, 12 Dec 2024 15:58:07 +0100
Message-ID: <20241212144259.398469299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 52ed077aa6336dbef83a2d6d21c52d1706fb7f16 ]

A recent refactor transformed the check for process completion
in a true statement, due to a typo.

As a result, the relevant test-case is unable to catch the
regression it was supposed to detect.

Restore the correct condition.

Fixes: 691bb4e49c98 ("selftests: net: avoid just another constant wait")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/0e6f213811f8e93a235307e683af8225cc6277ae.1730828007.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 9cd5cf800a5b5..f4116f0723e3f 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1587,7 +1587,7 @@ check_running() {
 	pid=${1}
 	cmd=${2}
 
-	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "${cmd}" ]
 }
 
 test_cleanup_vxlanX_exception() {
-- 
2.43.0



