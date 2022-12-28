Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89091C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CF9C433D2;
	Wed, 28 Dec 2022 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245764;
	bh=hWWyl7jUQijlVAmDgfQH9uGQhvU0smuLPmuN63nxNYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRsCsVMM3lJG92y5P9Q2+vgz6vG39RK0ry2yXok2xTVh4Jg+aHRo+WQZnlh9VprdO
	 kaVPrg9DWf/bZlpltNJ6F58VPjqr7BiDu1XNKCmShR13hU+WUPTW0aO9f4OdPieZAl
	 ue+vNadIoGqa62iC1+gUZwy01l514ZiZ2dQXBZD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0918/1146] selftests: devlink: fix the fd redirect in dummy_reporter_test
Date: Wed, 28 Dec 2022 15:40:57 +0100
Message-Id: <20221228144355.187505470@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2fc60e2ff972d3dca836bff0b08cbe503c4ca1ce ]

$number + > bash means redirect FD $number, e.g. commonly
used 2> redirects stderr (fd 2). The test uses 8192> to
write the number 8192 to a file, this results in:

  ./devlink.sh: line 499: 8192: Bad file descriptor

Oddly the test also papers over this issue by checking
for failure (expecting an error rather than success)
so it passes, anyway.

Fixes: ff18176ad806 ("selftests: Add a test of large binary to devlink health test")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9de1d123f4f5..a08c02abde12 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -496,8 +496,8 @@ dummy_reporter_test()
 
 	check_reporter_info dummy healthy 3 3 10 true
 
-	echo 8192> $DEBUGFS_DIR/health/binary_len
-	check_fail $? "Failed set dummy reporter binary len to 8192"
+	echo 8192 > $DEBUGFS_DIR/health/binary_len
+	check_err $? "Failed set dummy reporter binary len to 8192"
 
 	local dump=$(devlink health dump show $DL_HANDLE reporter dummy -j)
 	check_err $? "Failed show dump of dummy reporter"
-- 
2.35.1



