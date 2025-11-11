Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA97255F5E;
	Tue, 11 Nov 2025 01:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824203; cv=none; b=orOlL6qlz8IQxO/o6fRLg0MtyXZCrqLD+p7WebBiTLjMixfOQ4tCDdNbvHYLSJ5LxvKrHjVT9rnRohYc7t3Ma2rDtKSx96cM5NF2j+28vewCd5UgMg/kb91Ed7srtKaHdLyCCuDiF5cjaqNivUeG4SYS4kzgNjxX05TdMt9D03s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824203; c=relaxed/simple;
	bh=yYEHAgJwx+nPs4tHVlzx/48GTiGQwonKWsXgxnWKgHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOVX8a+kgLD6B4V4Zs4EhW9hl9/SOxuzlJhHK+BFpoToiKwyuPgFKWk6C+EMHocOrbsEC7pqEiyVmP7/cn7nHYd4lzl0gtTA750DR0hpaHTw4KG0cTV6iAKl8zKT3W5EfCD1o/qposGA3eD+d6iKEMIOuUBxumV9opdUPCrMqjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkXlRgeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkXlRgeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06796C16AAE;
	Tue, 11 Nov 2025 01:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824203;
	bh=yYEHAgJwx+nPs4tHVlzx/48GTiGQwonKWsXgxnWKgHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkXlRgeQvJ0y4BbCAsiH4T0Hqd+bKshlkvSkE76iZjFYoPnKw4nwRbzfWdNX3jPLe
	 tTudQEEP6ksJwSevSF7uAolqf/v5tX+g4L04IDyVj0sps6eo4Tk2dGVtrPSz23e2Qa
	 FF9S8O1HmnhiuKF+5bD1em5GOOJwUUwlc8g1Ff44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 461/849] selftests: ncdevmem: dont retry EFAULT
Date: Tue, 11 Nov 2025 09:40:31 +0900
Message-ID: <20251111004547.573571372@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 8c0b9ed2401b9b3f164c8c94221899a1ace6e9ab ]

devmem test fails on NIPA. Most likely we get skb(s) with readable
frags (why?) but the failure manifests as an OOM. The OOM happens
because ncdevmem spams the following message:

  recvmsg ret=-1
  recvmsg: Bad address

As of today, ncdevmem can't deal with various reasons of EFAULT:
- falling back to regular recvmsg for non-devmem skbs
- increasing ctrl_data size (can't happen with ncdevmem's large buffer)

Exit (cleanly) with error when recvmsg returns EFAULT. This should at
least cause the test to cleanup its state.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250904182710.1586473-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/ncdevmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/hw/ncdevmem.c b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
index 72f828021f832..147976e55dac2 100644
--- a/tools/testing/selftests/drivers/net/hw/ncdevmem.c
+++ b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
@@ -631,6 +631,10 @@ static int do_server(struct memory_buffer *mem)
 			continue;
 		if (ret < 0) {
 			perror("recvmsg");
+			if (errno == EFAULT) {
+				pr_err("received EFAULT, won't recover");
+				goto err_close_client;
+			}
 			continue;
 		}
 		if (ret == 0) {
-- 
2.51.0



