Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE752AD00;
	Sun,  7 Jun 2026 10:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827420; cv=none; b=HD45zwTrFtFhJvznmkvtsMjU52OYvp4fAM+M6ZYt+AW9FF43HoD+uDRwVx8cp1Yen4W1QoO+MdurG5LFCFhbAm9KPVZzHVDq9zt/kU6ZQAwMQgDvW6ldFc6Uiq00SCvF4zuZ8vopUAEVP7sDwWMLqOLaQhAACvZUa1qJ5osMyfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827420; c=relaxed/simple;
	bh=k20N0kdZnWvi8hzgqnlRKO7hl2PVCcZFcqPc2REa0e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/zowUrX5scv3fD8j36yPnrODkYXEJDQmA06YNz6kflbMzzVQXviQw2sZgQ1kF7N2LJdSrRMOrRh7AQFg7vLK59NEkVjwx42hJ3LuVhZ6WJxuzjC7MQ+VjmylElIwsGjeOkiBwlLrOg+s3zy4hCX3oE3okdPQLR5xB1p6Dp83pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCauaYI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCauaYI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B57B1F00893;
	Sun,  7 Jun 2026 10:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827419;
	bh=15geUMSGi4ufT+FLP0QjA/4NztakTxcJ2Xynf/bon/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCauaYI1Nn2Fa8U1dwf9tyshXqSEDsGZkyfF8SRNvZ2LgX7wgI//4tjn9xhvO9Zg4
	 7k3j/8aSnptqDCbtfSEd59cV0EiL6RSWW8xv/LXWPhJp5lXi2Wa72Pf8tVu+oJIOco
	 Diqkn2kpc8tzO7mvpF/cN1EiMh4QfzhSwzS1Ph/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/315] ethtool: eeprom: add missing ethnl_ops_begin() / _complete() during fallback
Date: Sun,  7 Jun 2026 11:57:39 +0200
Message-ID: <20260607095730.259392573@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2376586f85f972fefe701f095bb37dcfe7405d21 ]

All ethtool driver op calls should be sandwiched between
ethnl_ops_begin() / ethnl_ops_complete(). In Netlink eeprom code,
if the paged access failed we fall back to old API, but we
first call _complete() and the fallback never does its own
ethnl_ops_begin(). Move the fallback into the _begin() / _complete()
section.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-10-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/eeprom.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 3b8209e930fd3a..03cb418a15823b 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -140,12 +140,11 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	return 0;
 
 err_ops:
+	if (ret == -EOPNOTSUPP)
+		ret = eeprom_fallback(request, reply);
 	ethnl_ops_complete(dev);
 err_free:
 	kfree(page_data.data);
-
-	if (ret == -EOPNOTSUPP)
-		return eeprom_fallback(request, reply);
 	return ret;
 }
 
-- 
2.53.0



