Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3524F18A6C4;
	Tue, 26 Aug 2025 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214641; cv=none; b=fZBn/xMXJuEnKVZPvcxYAbJNzplyoInx4fIlBh4//NqJxmaicl2QWfWmE8rLh+TlsTYpV83Ldok0v5oMgg4bkiYJrW/yMlQSR3qinhvA1vAzavAITUOW/1aYTweM8w4IXSCDmO4HjO9szr9sE4P0aUVYwaYbqIS373cSjUFX/Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214641; c=relaxed/simple;
	bh=iiOmpmj/WxstmKW8KO3U7AUoeUZjIXiGrf5VTb3UqYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiYyySEjT1NGnA89g8eMbhVZrJeREpbc/j8v6rAXpKZ4HjvvZYkCRb54ROMW2OCM4ocy0yRTPNuX0q0HuZtAeaxhq+w4HkIC09VY+W+hp/tCa8YaCv4sWzebgqxs9dvg4xbkhD1aI35PJ99jcW+aVuXG+4USuCxvzGmg7e6VDgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXb9JkaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXb9JkaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CB7C4CEF1;
	Tue, 26 Aug 2025 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214641;
	bh=iiOmpmj/WxstmKW8KO3U7AUoeUZjIXiGrf5VTb3UqYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXb9JkaOwwRNsU2u6AngtM5rAjvc7Yeaw1PWs+x24vV7KI6Aq5YTTHaSOLXLI2bZt
	 VcYJO6hqDPsIniGmMLyImFO3f9JihEvvXvCNgWx77FEizSzvCNihUQsjzS0HyvvZlu
	 wj12+VZaU3nAwxRQOVp4yANGTSAWnwHpGz7bsNVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Marques <jorge.marques@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/482] i3c: master: Initialize ret in i3c_i2c_notifier_call()
Date: Tue, 26 Aug 2025 13:07:46 +0200
Message-ID: <20250826110936.039313537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 290ce8b2d0745e45a3155268184523a8c75996f1 ]

Set ret to -EINVAL if i3c_i2c_notifier_call() receives an invalid
action, resolving uninitialized warning.

Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250622-i3c-master-ret-uninitialized-v1-1-aabb5625c932@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 513c79e26d9a..019fd9bd928d 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2413,6 +2413,8 @@ static int i3c_i2c_notifier_call(struct notifier_block *nb, unsigned long action
 	case BUS_NOTIFY_DEL_DEVICE:
 		ret = i3c_master_i2c_detach(adap, client);
 		break;
+	default:
+		ret = -EINVAL;
 	}
 	i3c_bus_maintenance_unlock(&master->bus);
 
-- 
2.39.5



