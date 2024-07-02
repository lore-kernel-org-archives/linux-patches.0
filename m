Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE03463D;
	Tue,  2 Jul 2024 17:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941470; cv=none; b=UNBh849o/CecchK21R7eykj20v0zBGRjryPsg6h0XNi3o4/qJ//mI64CfsH1/9Mi3r2mVkNeJOuNfFMgJMQKhLxjoUT5auVGYYwYhDOkqX0D9KFB6TDFRbc8zkGSB9PsUDejILOLTLXXnFywyZYGrgvazIUFCijAdezChcUK2b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941470; c=relaxed/simple;
	bh=UQIi11XPVsESqEQcCrq2Z0Ny+tC8QGqMNKVSuJ1N0Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljKTQsPXirN8h9WNgqmvKWfz2nEbNNTt3tmbhE0qhvQG2OhYitQJrzfacpqOcdtJvFP7weSYkAebAAqyRzU3WKgh9EB38d+f4gI5AP1l1V/6vmHrqhV4bjBOFFhRBa2qSdiZ1lhoE1bKohk3kHtA7QodiUNGOeZmGzUZjolyx1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVyDX8F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVyDX8F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC21C116B1;
	Tue,  2 Jul 2024 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941470;
	bh=UQIi11XPVsESqEQcCrq2Z0Ny+tC8QGqMNKVSuJ1N0Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVyDX8F5fAs5Msls1b4sUWGurVIjC0uQIfgjlJQrc/uAWC0EioRfgA2w0LXZBpDLa
	 zAhtMfE4j54rvKBgW+hppPK2npX+VWPN48IMco78LCE9hBjoV0MVkw1pA31C26jAKV
	 +qm5IRDjvBc+zBHaL54tpDSGDT0wD41WkDKP3Abs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/128] i2c: testunit: dont erase registers after STOP
Date: Tue,  2 Jul 2024 19:04:35 +0200
Message-ID: <20240702170229.029699920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
index 75ee7ebdb614f..4945adc69d78d 100644
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



