Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A476FB1;
	Tue,  5 Dec 2023 03:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgkhdXtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DE3C433C8;
	Tue,  5 Dec 2023 03:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747161;
	bh=i58eVIeVTNba6351h/c5Z1IW3343ucNmxessJwZ7HQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgkhdXtmITqhsJUZDfEuNJlMa1LgnRGpBZmLepyPwSFt1A6AaCixeyKswQp23abYp
	 uymk/eTLALngGER0K7xgNoP6sp/NjReUJ4LJnpyaI+qH6mPr3POhhv8kV/wLzfbt0s
	 QTpx5c2x5Sx6dAn5s3VuBh28Nctzytgw8h8VjML4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Willem de Bruijn <willemb@google.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/107] selftests/net: mptcp: fix uninitialized variable warnings
Date: Tue,  5 Dec 2023 12:16:39 +0900
Message-ID: <20231205031535.424278606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/net/mptcp/mptcp_inq.c     | 11 ++++-------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 7df6b9b6f9a84..e6b514cb7bdda 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -18,6 +18,7 @@
 
 #include <sys/ioctl.h>
 #include <sys/poll.h>
+#include <sys/random.h>
 #include <sys/sendfile.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
@@ -1050,15 +1051,11 @@ int main_loop_s(int listensock)
 
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
diff --git a/tools/testing/selftests/net/mptcp/mptcp_inq.c b/tools/testing/selftests/net/mptcp/mptcp_inq.c
index 8672d898f8cda..218aac4673212 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_inq.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_inq.c
@@ -18,6 +18,7 @@
 #include <time.h>
 
 #include <sys/ioctl.h>
+#include <sys/random.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/wait.h>
@@ -519,15 +520,11 @@ static int client(int unixfd)
 
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



