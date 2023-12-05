Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDFE8BEA;
	Tue,  5 Dec 2023 03:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaLinGYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E1C433C8;
	Tue,  5 Dec 2023 03:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746612;
	bh=MmMh8zL/6az6dD8s6GNWtp2ebuq6moGyk0b+5w6Vdck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaLinGYqwozyp7rCiQs4MD60I62CWp58ptIDoUzxI+tLP6XyHEV5//Ep3gBYE4JqD
	 WohtIolpKS6tE+MctA19eKu8bJipeRTWVhO5WFgMDsTeZWp48I0JsBbRFhf6o40l/k
	 zTo/Bp3X7CLKD0WNKjS9sSv5TYLdJvl8h4uFBvmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/134] selftests/net: ipsec: fix constant out of range
Date: Tue,  5 Dec 2023 12:16:03 +0900
Message-ID: <20231205031541.235789578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 088559815477c6f623a5db5993491ddd7facbec7 ]

Fix a small compiler warning.

nr_process must be a signed long: it is assigned a signed long by
strtol() and is compared against LONG_MIN and LONG_MAX.

ipsec.c:2280:65:
    error: result of comparison of constant -9223372036854775808
    with expression of type 'unsigned int' is always false
    [-Werror,-Wtautological-constant-out-of-range-compare]

  if ((errno == ERANGE && (nr_process == LONG_MAX || nr_process == LONG_MIN))

Fixes: bc2652b7ae1e ("selftest/net/xfrm: Add test for ipsec tunnel")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://lore.kernel.org/r/20231124171645.1011043-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ipsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index 9a8229abfa026..be4a30a0d02ae 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -2263,7 +2263,7 @@ static int check_results(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int nr_process = 1;
+	long nr_process = 1;
 	int route_sock = -1, ret = KSFT_SKIP;
 	int test_desc_fd[2];
 	uint32_t route_seq;
@@ -2284,7 +2284,7 @@ int main(int argc, char **argv)
 			exit_usage(argv);
 		}
 
-		if (nr_process > MAX_PROCESSES || !nr_process) {
+		if (nr_process > MAX_PROCESSES || nr_process < 1) {
 			printk("nr_process should be between [1; %u]",
 					MAX_PROCESSES);
 			exit_usage(argv);
-- 
2.42.0



