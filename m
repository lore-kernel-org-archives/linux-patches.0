Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498F9308F2E;
	Wed, 28 Jan 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615831; cv=none; b=FpJA2od0MLkNLz5ymZIUFBxcAK7HC4nOz42Amg9VKFBAidbPAqq0x8f4m61/153AoVqqu/thBUoUN2rd7FwUPYh5gLrJwRjCNAB5SLbLPmNjzGj6TjQ5cv1BUWDioFw0g3rwallGY5/4MmBLxVknonw6zUES9p40e9gjRphacQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615831; c=relaxed/simple;
	bh=Unt0DL+KDhO0hKWinnlk6LisZuNV9Vls5Yq5jYLige4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WijzR18S6j9IeDm5UypAj9/QpF3U+TrNsfx5J4D+h8m6jBhPK1appuxaY10qLCdlpd2hrojIP/s9UC23Ylf7OduuYYOnk3neoqO3hIPPACfAbafLxAwx7InF4RRHdSDFk+qrltz0Rm+3vCf4qYOJJlWjsW9kWO3gSS0aDRpUzf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRc5Z3Vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRc5Z3Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8005C2BC86;
	Wed, 28 Jan 2026 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615831;
	bh=Unt0DL+KDhO0hKWinnlk6LisZuNV9Vls5Yq5jYLige4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRc5Z3VmGY9VjhRxs8+Llwt2zZT6K5YnZ157dE4mcsGf2MraJKxVnaAPMxq/s+3U0
	 R2RZcpCuCuxgiK1PLerQJkAI8vqf9KqO4TIXKOisXUxJsjzRoJ4P9+fZQKpWy2nkZN
	 uNorLkRcKfesej6+VcSABOErJwXRviJafjgb7kto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/227] selftests/ublk: fix garbage output in foreground mode
Date: Wed, 28 Jan 2026 16:22:51 +0100
Message-ID: <20260128145348.997730063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit e7e1cc18f120a415646be12470169a978a1adcd9 ]

Initialize _evtfd to -1 in struct dev_ctx to prevent garbage output
when running kublk in foreground mode. Without this, _evtfd is
zero-initialized to 0 (stdin), and ublk_send_dev_event() writes
binary data to stdin which appears as garbage on the terminal.

Also fix debug message format string.

Fixes: 6aecda00b7d1 ("selftests: ublk: add kernel selftests for ublk")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/kublk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ublk/kublk.c b/tools/testing/selftests/ublk/kublk.c
index 9c05f046ad5ee..cbd23444c8a98 100644
--- a/tools/testing/selftests/ublk/kublk.c
+++ b/tools/testing/selftests/ublk/kublk.c
@@ -1221,7 +1221,7 @@ static int __cmd_dev_add(const struct dev_ctx *ctx)
 	}
 
 	ret = ublk_start_daemon(ctx, dev);
-	ublk_dbg(UBLK_DBG_DEV, "%s: daemon exit %d\b", ret);
+	ublk_dbg(UBLK_DBG_DEV, "%s: daemon exit %d\n", __func__, ret);
 	if (ret < 0)
 		ublk_ctrl_del_dev(dev);
 
@@ -1566,6 +1566,7 @@ int main(int argc, char *argv[])
 	int option_idx, opt;
 	const char *cmd = argv[1];
 	struct dev_ctx ctx = {
+		._evtfd         =       -1,
 		.queue_depth	=	128,
 		.nr_hw_queues	=	2,
 		.dev_id		=	-1,
-- 
2.51.0



