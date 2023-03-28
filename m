Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F38BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D56C433D2;
	Tue, 28 Mar 2023 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015461;
	bh=PhObNGJPHGlYcK6PumO1SHpmmjeshhIaCthePBXbGTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jExpUHCoFqcG9jizC7zavfzLYDGgdwrX6Blyyd2SKE2Uw4Il96d7LB31u5kCBDIsL
	 Ba4UHXCfXAPgu/gN7fTYBy37orAAJwFhgprFTm3oL9VCKTQ7mWNthCz8vCP66tyyPg
	 7o/5clvK4ZRvVckwA74gX4Oogb712hFygr7MD03I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Wiesinger <pprkut@slackware.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/224] bootconfig: Fix testcase to increase max node
Date: Tue, 28 Mar 2023 16:40:54 +0200
Message-Id: <20230328142619.782059435@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit b69245126a48e50882021180fa5d264dc7149ccc ]

Since commit 6c40624930c5 ("bootconfig: Increase max nodes of bootconfig
from 1024 to 8192 for DCC support") increased the max number of bootconfig
node to 8192, the bootconfig testcase of the max number of nodes fails.
To fix this issue, we can not simply increase the number in the test script
because the test bootconfig file becomes too big (>32KB). To fix that, we
can use a combination of three alphabets (26^3 = 17576). But with that,
we can not express the 8193 (just one exceed from the limitation) because
it also exceeds the max size of bootconfig. So, the first 26 nodes will just
use one alphabet.

With this fix, test-bootconfig.sh passes all tests.

Link: https://lore.kernel.org/all/167888844790.791176.670805252426835131.stgit@devnote2/

Reported-by: Heinz Wiesinger <pprkut@slackware.com>
Link: https://lore.kernel.org/all/2463802.XAFRqVoOGU@amaterasu.liwjatan.org
Fixes: 6c40624930c5 ("bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/test-bootconfig.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/bootconfig/test-bootconfig.sh b/tools/bootconfig/test-bootconfig.sh
index f68e2e9eef8b2..a2c484c243f5d 100755
--- a/tools/bootconfig/test-bootconfig.sh
+++ b/tools/bootconfig/test-bootconfig.sh
@@ -87,10 +87,14 @@ xfail grep -i "error" $OUTFILE
 
 echo "Max node number check"
 
-echo -n > $TEMPCONF
-for i in `seq 1 1024` ; do
-   echo "node$i" >> $TEMPCONF
-done
+awk '
+BEGIN {
+  for (i = 0; i < 26; i += 1)
+      printf("%c\n", 65 + i % 26)
+  for (i = 26; i < 8192; i += 1)
+      printf("%c%c%c\n", 65 + i % 26, 65 + (i / 26) % 26, 65 + (i / 26 / 26))
+}
+' > $TEMPCONF
 xpass $BOOTCONF -a $TEMPCONF $INITRD
 
 echo "badnode" >> $TEMPCONF
-- 
2.39.2



