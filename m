Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E1815B0FE;
	Tue,  2 Jul 2024 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940360; cv=none; b=T+VV0+Xr+33jKNBcba/QZHaLrmtDt9NgWRQaswEZ3EavA/JWwz4QJ/QDumzoKccBNkBIwcpS47JDK6DNfymkbT0284B28HIyWsV7L0aJMxX2efTqvokOd6zCzPpmnVmFYyaML+uRjWrvSEzFPBIP5RicEGjd5V96sOPdppY9fSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940360; c=relaxed/simple;
	bh=tpzRYEoRd7TKUlxnT2U0iNCv+a5I4IOqSbAKI0mHWAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvTh5B4nAeI7H3rsBr3HZ9rTvM+77flC7iRFgyVakRYI5e0dqd63/F0PAMJiYNJj5wpLPryS3Sw4SyIzK3zCVjcWdh1KIYp5rU3FxCbdCixiM4z4IMLu9R3tPdBXRCehEnSxLCZjaFKdi/8MN2o/TH0en8nhdf/ZMWR3BtdMTtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzEiv3+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzEiv3+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270BBC116B1;
	Tue,  2 Jul 2024 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940360;
	bh=tpzRYEoRd7TKUlxnT2U0iNCv+a5I4IOqSbAKI0mHWAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzEiv3+wd0rIwglMRxbJzSq+fSGHyERZsewu+vRFToTks3brBEfnzocnOyHzUOagM
	 qQeXpVkLokxHr6kaZRmivlNCyw6adL98UNIdUUi8Kl3XJC5DyUI9Y7nXtu5JvcIngw
	 n37H1yk6K45uPf8ciAfuqif1dCuLb5fNVmdPpPKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 132/222] i2c: testunit: dont erase registers after STOP
Date: Tue,  2 Jul 2024 19:02:50 +0200
Message-ID: <20240702170249.015554191@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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
index a49642bbae4b7..a5dcbc3c2c141 100644
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



