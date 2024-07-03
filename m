Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA5B17B4F7;
	Wed,  3 Jul 2024 11:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004664; cv=none; b=Tn4jSYEITOM9a2lvUlR/JAdQ5+ZXCig4GfU/+/PIt5aERie9atRkd72BO5tYpvcHlLj5dYeDsK6Y6aB+uvx7eRHjDpXI43D5d7aZEI/2NJlJUqes6fHNnbhEtAXfR9SHk11prh3PlSzrVNA8cZc24htaiODmdEJl/Z8sdg6Kxqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004664; c=relaxed/simple;
	bh=caaNtMR1VKdbscUm/hxk/SxChqZmMnI7bVlpwXBGCVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peMVND0KW0GgFBn6ivJgVLPKaIg1q3q6BClX2nViZwWp0hgAoVms7g5/bPhYDa21oEm1GvXwjWXTK1DxCSKyyD72o/ZrcB3JiI3DY5FgJgiq3GeaOkjlcLsT+cI/uWkWBBF+ikHZq3nwXr9PSM+0LvnqTBsh5LHrVPsk/bumkDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMrKILld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMrKILld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3A5C4AF0B;
	Wed,  3 Jul 2024 11:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004664;
	bh=caaNtMR1VKdbscUm/hxk/SxChqZmMnI7bVlpwXBGCVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMrKILldgaxh+bIVL757HEXn3fvD5NHezjMaIPcIX8mpvbBD0drjqytXvEHMMTvNN
	 fI9yjKMPLrmFwQ8IhctPTPpdCHpbZ2q+5MS+dbsy1BbBt2LKlrLlzjrnkDLqFoIkaG
	 hovqEZMrMoshBaoZsxS1zNslREWeplvvbZwdEA7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/290] kselftest: arm64: Add a null pointer check
Date: Wed,  3 Jul 2024 12:38:17 +0200
Message-ID: <20240703102908.573645022@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 80164282b3620a3cb73de6ffda5592743e448d0e ]

There is a 'malloc' call, which can be unsuccessful.
This patch will add the malloc failure checking
to avoid possible null dereference and give more information
about test fail reasons.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240423082102.2018886-1-chentao@kylinos.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/tags/tags_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/arm64/tags/tags_test.c b/tools/testing/selftests/arm64/tags/tags_test.c
index 5701163460ef7..955f87c1170d7 100644
--- a/tools/testing/selftests/arm64/tags/tags_test.c
+++ b/tools/testing/selftests/arm64/tags/tags_test.c
@@ -6,6 +6,7 @@
 #include <stdint.h>
 #include <sys/prctl.h>
 #include <sys/utsname.h>
+#include "../../kselftest.h"
 
 #define SHIFT_TAG(tag)		((uint64_t)(tag) << 56)
 #define SET_TAG(ptr, tag)	(((uint64_t)(ptr) & ~SHIFT_TAG(0xff)) | \
@@ -21,6 +22,9 @@ int main(void)
 	if (prctl(PR_SET_TAGGED_ADDR_CTRL, PR_TAGGED_ADDR_ENABLE, 0, 0, 0) == 0)
 		tbi_enabled = 1;
 	ptr = (struct utsname *)malloc(sizeof(*ptr));
+	if (!ptr)
+		ksft_exit_fail_msg("Failed to allocate utsname buffer\n");
+
 	if (tbi_enabled)
 		tag = 0x42;
 	ptr = (struct utsname *)SET_TAG(ptr, tag);
-- 
2.43.0



