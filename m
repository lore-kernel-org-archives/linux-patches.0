Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B924B7CF1F;
	Wed,  3 Jul 2024 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006126; cv=none; b=NdzPzjS41z3IA0Fwz++wJj5f4J1C76ILm7sy27771inXcVA5U2F8njXrkbKoKrXvtKwQPd8+4Tow+0Voau6Tcg0GWaJ3Oalzy+5xPOqmXmY4v+Rp9+IxLVe0C+9KdzyHokX6pD+p6GZW0kdajpA+GZzwijfh9TE/CPrBMPpryYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006126; c=relaxed/simple;
	bh=TaV2VHwRX2Hyqr2bpvpBbvXUXe/bYULoVYogMLlNCw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=np6vobDxu21ySH5lDMbY4MRphhA417A19JkxdBk9lYSWQ+ovFwhTjEOPDp8Y1ynK8OxA4qMJOU+9TliUfnNVnuU2GPYJHRSyehpEOJ05XFJQIFgKmsC1B9AKp7A/n2ydc8ZklTyxBqZaFR5xRKzB4syg0OCIzb+Y5HCbDUQcifk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lE6QaHpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lE6QaHpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356B0C2BD10;
	Wed,  3 Jul 2024 11:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006126;
	bh=TaV2VHwRX2Hyqr2bpvpBbvXUXe/bYULoVYogMLlNCw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lE6QaHpzFgDZ3oh0VdfCfZ3Io3TAK8yK/zRpC9dpzkts6BQ3zy6V7JGACjzUKlNcm
	 OkWFH1csjSslbisGYkfpPmRkLrQHiL1PJARgViKZYRKAHOxVzMmWNMGK15EP4g2KhU
	 sXCjTlQ61PZzIfJ4j9HpckX+u3eyUea9MdljfBSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/356] i2c: testunit: dont erase registers after STOP
Date: Wed,  3 Jul 2024 12:40:44 +0200
Message-ID: <20240703102924.766059770@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c422b6a630240f706063e0ecbb894aa8491b1fa1 ]

STOP fallsthrough to WRITE_REQUESTED but this became problematic when
clearing the testunit registers was added to the latter. Actually, there
is no reason to clear the testunit state after STOP. Doing it when a new
WRITE_REQUESTED arrives is enough. So, no need to fallthrough, at all.

Fixes: b39ab96aa894 ("i2c: testunit: add support for block process calls")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-slave-testunit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-slave-testunit.c b/drivers/i2c/i2c-slave-testunit.c
index 56dae08dfd489..1beae30c418b8 100644
--- a/drivers/i2c/i2c-slave-testunit.c
+++ b/drivers/i2c/i2c-slave-testunit.c
@@ -118,7 +118,7 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 			queue_delayed_work(system_long_wq, &tu->worker,
 					   msecs_to_jiffies(10 * tu->regs[TU_REG_DELAY]));
 		}
-		fallthrough;
+		break;
 
 	case I2C_SLAVE_WRITE_REQUESTED:
 		memset(tu->regs, 0, TU_NUM_REGS);
-- 
2.43.0



