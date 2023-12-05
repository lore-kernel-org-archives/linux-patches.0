Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F66FB1;
	Tue,  5 Dec 2023 03:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECjASwWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDFFC433C7;
	Tue,  5 Dec 2023 03:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747488;
	bh=rsJhHzCfx79wJatSqZEnZ1vjhI2yLOq5h3TJW4SJhEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECjASwWwiaAhd7uQZRJkF80P7/1xz2kdY8yrjHkISxTOApzt49kVmibSmSW2jFugl
	 bX/ktSoe448mgIQffaBshRg3H/zk8pDMhkCWWgi86nnzVtNNpcFkSHeuSZdwT3eH2O
	 nk4Wq/ILS/IJmCI7O0PXsEF0m8kyVdF+yDW5Dawo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Willem de Bruijn <willemb@google.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/135] selftests/net: mptcp: fix uninitialized variable warnings
Date: Tue,  5 Dec 2023 12:16:56 +0900
Message-ID: <20231205031536.627665608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 00a4f8fd9c750f20d8fd4535c71c9caa7ef5ff2f ]

Same init_rng() in both tests. The function reads /dev/urandom to
initialize srand(). In case of failure, it falls back onto the
entropy in the uninitialized variable. Not sure if this is on purpose.
But failure reading urandom should be rare, so just fail hard. While
at it, convert to getrandom(). Which man 4 random suggests is simpler
and more robust.

    mptcp_inq.c:525:6:
    mptcp_connect.c:1131:6:

    error: variable 'foo' is used uninitialized
    whenever 'if' condition is false
    [-Werror,-Wsometimes-uninitialized]

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Fixes: b51880568f20 ("selftests: mptcp: add inq test case")
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Willem de Bruijn <willemb@google.com>

----

When input is randomized because this is expected to meaningfully
explore edge cases, should we also add
1. logging the random seed to stdout and
2. adding a command line argument to replay from a specific seed
I can do this in net-next, if authors find it useful in this case.
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>

Link: https://lore.kernel.org/r/20231124171645.1011043-5-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 77bb62feb8726..37c1ec888ba2e 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include <sys/poll.h>
+#include <sys/random.h>
 #include <sys/sendfile.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
@@ -734,15 +735,11 @@ int main_loop_s(int listensock)
 
 static void init_rng(void)
 {
-	int fd = open("/dev/urandom", O_RDONLY);
 	unsigned int foo;
 
-	if (fd > 0) {
-		int ret = read(fd, &foo, sizeof(foo));
-
-		if (ret < 0)
-			srand(fd + foo);
-		close(fd);
+	if (getrandom(&foo, sizeof(foo), 0) == -1) {
+		perror("getrandom");
+		exit(1);
 	}
 
 	srand(foo);
-- 
2.42.0



