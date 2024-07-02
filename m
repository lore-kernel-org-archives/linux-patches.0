Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AC163D;
	Tue,  2 Jul 2024 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941474; cv=none; b=ZMfYbpZ8bTiiGrcf9PT/JzB+zWd7izgu1VQOb11TM/4+zMc9xqfSHPzR2pW4J2trTUqSrs3afmr0CdcOJaQQN8Dg0ijXczAu+GHxBla/45yNN8Z+44wduHYt4YGa9p+FmPcHujHsHaFpo3IPIJhG/rSa8ZvlKhWoH++ITU6iXmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941474; c=relaxed/simple;
	bh=eL/a3J80ZsPNyjRx75RgApiYKSyQAGVkaYVzD8a24Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UejTqC7P2e3S9DVHBQy9QaCudAvRRR353uXKnZRBOI3EAlPIeHWzwg3TCcLNOIk0Ow3UjRv0VScR0G7MqpN35yrInhgydSbGjMBJfTtUFhP8HIpYg/RRmb6BugdjrDIoiRzbzdJ84HJ7it+qsmOiiDOyfa0FoqxzhPv58oTZndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wb9AXold; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wb9AXold"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453F5C116B1;
	Tue,  2 Jul 2024 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941474;
	bh=eL/a3J80ZsPNyjRx75RgApiYKSyQAGVkaYVzD8a24Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wb9AXoldwm+dZDbf1qasBnHHUmueL+jv0RRmcihrCXK21DG5mCqNZesFxWXqCynUA
	 vU+XE7NipdKHL3g1ReSW05nsfSMSGn8P4VNhrgTqAqtRhcXsj9r2BjOz6Y5PatSCDU
	 dgiCWhrUIu92p0EBg+fQiIdnQ1AxMQpj4uaVaH3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/128] i2c: testunit: discard write requests while old command is running
Date: Tue,  2 Jul 2024 19:04:36 +0200
Message-ID: <20240702170229.067448024@linuxfoundation.org>
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

[ Upstream commit c116deafd1a5cc1e9739099eb32114e90623209c ]

When clearing registers on new write requests was added, the protection
for currently running commands was missed leading to concurrent access
to the testunit registers. Check the flag beforehand.

Fixes: b39ab96aa894 ("i2c: testunit: add support for block process calls")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-slave-testunit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-slave-testunit.c b/drivers/i2c/i2c-slave-testunit.c
index 4945adc69d78d..54c08f48a8b85 100644
--- a/drivers/i2c/i2c-slave-testunit.c
+++ b/drivers/i2c/i2c-slave-testunit.c
@@ -121,6 +121,9 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 		break;
 
 	case I2C_SLAVE_WRITE_REQUESTED:
+		if (test_bit(TU_FLAG_IN_PROCESS, &tu->flags))
+			return -EBUSY;
+
 		memset(tu->regs, 0, TU_NUM_REGS);
 		tu->reg_idx = 0;
 		break;
-- 
2.43.0



