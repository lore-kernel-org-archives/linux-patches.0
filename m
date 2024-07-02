Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E68915218A;
	Tue,  2 Jul 2024 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940984; cv=none; b=RnY4Rsk5SNLxKq7udeuhmOpHHeTklEjejHGovyjPDN43PPMLjersiVC2J8AUj3rZ1SDh4qJjfw6Jm5xqjjztvmfTfHmLXL9pD2ykrV0XWrqJwl07bKKlZlSiH9E8Kkxis5OohFlJfZ1bhhWma3hUDpEUoOADce+wW/BfIDBViaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940984; c=relaxed/simple;
	bh=1KKCAx4bRt48W3Z3sDEKZ5670V6pxyYbKw/2Ok00ieg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSfQhCqCRniumGNcKD9/7w4UJllewriGdrWjOoprpI8B9iLIJek+6dkyf8rva09fsRpi2r0Lroon8K14ITaffHc/RnzBXqNz6KuOygyI/5x9zwkBv6vCxdLxnajTg6NgsDlGA1eM3WkiP9THLsLoQ13vwX12Z9H0DaphAlGiXy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQAtE2G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQAtE2G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBB8C116B1;
	Tue,  2 Jul 2024 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940983;
	bh=1KKCAx4bRt48W3Z3sDEKZ5670V6pxyYbKw/2Ok00ieg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQAtE2G3Ks7odo/c64IUnUgewEDRhX0TdBeN61fyEUusu3JdXQTRWRNmXLF/+eKU4
	 S/eal5a7kLm47wXmC+WbzoL7baDyn7Pj0fT4vEDTWZUSa1E4fILu0i+Q0SGdE4Fh1v
	 33rFzCzVKH1AYEP02yrwM6Xu3W1JIepS5ZvqfOyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/163] i2c: testunit: dont erase registers after STOP
Date: Tue,  2 Jul 2024 19:03:28 +0200
Message-ID: <20240702170236.621263408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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



