Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C88D55E4C;
	Tue,  9 Jul 2024 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523930; cv=none; b=NxRdtpJedmuBIuNrlx97/vxjg7M6D/M9Owi614yF1W8FYEQT9fWy+6bbKEOTaslcNJS4h3hQxZ3VltT7LhCXnqWWUwVVlBbWovLSReCSc2UK1b7YFZAkQZQ/+gzajl2RqSBQ5owGdh17KKZmyNKlDKHVEwFpHaXbh/Sy0AOWa10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523930; c=relaxed/simple;
	bh=8csrSV7qULwGMcyno5auIuWdIXPRLH1gASc6fKYOxzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mq9WoRiZmsFlkmcyQ92SUr6coiIY7G6eLbG29jvnvEhURyYA36aHhffx2stb0ZH2w1RPbGqYRf7fy+ncw22mI3NOAow8t6KIiY/3vr7WK+OGT29J/c8PNhgw3GoaCfqGgplxxeom/KPBDmm+LNbgFwzWRCeWtVO6o6Jn9dYtcOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1EewR8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1EewR8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99042C3277B;
	Tue,  9 Jul 2024 11:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523930;
	bh=8csrSV7qULwGMcyno5auIuWdIXPRLH1gASc6fKYOxzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1EewR8h3N1Y45FgTu+cKUubHO3k/cTvZOcLvRphf1a68wnDlbm9xbOAFvsbX03rw
	 F/IguFQLTkvAmO6orQiOYaKtF6c71l/Dm1IOqXfsITs7Hx4zG6Q0tPno6cUlNoP9jg
	 JCpDDrkfrErnyUZyqfhvNSdKQZwa8ATHTyQU87rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jemarch@gnu.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 016/197] bpf: mark bpf_dummy_struct_ops.test_1 parameter as nullable
Date: Tue,  9 Jul 2024 13:07:50 +0200
Message-ID: <20240709110709.542779305@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 1479eaff1f16983d8fda7c5a08a586c21891087d ]

Test case dummy_st_ops/dummy_init_ret_value passes NULL as the first
parameter of the test_1() function. Mark this parameter as nullable to
make verifier aware of such possibility.
Otherwise, NULL check in the test_1() code:

      SEC("struct_ops/test_1")
      int BPF_PROG(test_1, struct bpf_dummy_ops_state *state)
      {
            if (!state)
                    return ...;

            ... access state ...
      }

Might be removed by verifier, thus triggering NULL pointer dereference
under certain conditions.

Reported-by: Jose E. Marchesi <jemarch@gnu.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240424012821.595216-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/bpf_dummy_struct_ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
index de33dc1b0daad..fdbe30ad8db2f 100644
--- a/net/bpf/bpf_dummy_struct_ops.c
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -230,7 +230,7 @@ static void bpf_dummy_unreg(void *kdata)
 {
 }
 
-static int bpf_dummy_test_1(struct bpf_dummy_ops_state *cb)
+static int bpf_dummy_ops__test_1(struct bpf_dummy_ops_state *cb__nullable)
 {
 	return 0;
 }
@@ -247,7 +247,7 @@ static int bpf_dummy_test_sleepable(struct bpf_dummy_ops_state *cb)
 }
 
 static struct bpf_dummy_ops __bpf_bpf_dummy_ops = {
-	.test_1 = bpf_dummy_test_1,
+	.test_1 = bpf_dummy_ops__test_1,
 	.test_2 = bpf_dummy_test_2,
 	.test_sleepable = bpf_dummy_test_sleepable,
 };
-- 
2.43.0



