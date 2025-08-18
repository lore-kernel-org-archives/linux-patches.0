Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32AA27B33A;
	Mon, 18 Aug 2025 13:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522605; cv=none; b=lA/PG5DzRFXF3/fDLnLYaVtqNsean2cpUoO7dD3ZE3BjvlePzV8IPSmiM/rrUYhBXz8l0NOcO3utv1Q8NkpBbVJsZAQ9Y/BlP24qnz1I5Y1EFFmx38fIqHTdbvAmMwSNqM4DaG+njXv2HKYnRwl/F4KqpCUw3+9tUVZfpSlm018=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522605; c=relaxed/simple;
	bh=w0nLIXYHF9W/qTkDEuzwIRE7ChgtavOvUZqZf7ozRNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRwVhWLcthazIXgGI2HhprtZkUaI1xuoyVlhqfzrd3vhDa8vSYHNvDHHByNEL5Qsjf9XCd2FJxCH5SNiKQr6SrpReEF+MPoCGIg9IsCkKHG6osf21SDLRChJttWWbqrLCi5N0hws9QbiJe17OSPa2WBOzJifY/8BCa9Xdnf+Ekc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+0UaCFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+0UaCFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23097C4CEEB;
	Mon, 18 Aug 2025 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522605;
	bh=w0nLIXYHF9W/qTkDEuzwIRE7ChgtavOvUZqZf7ozRNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+0UaCFdVDgdgZ3WpI/qQZqUPs1IElV87UHoomGBtLVbSLVsCRTFnnR7+1LNo4V9Y
	 ao5nPM1RYqfhQtMGli6uBGbqm2CK9p7PGWNK4X7KbKypWEiC6dYqXeCx9GIUqwezIf
	 2LF8TSP1LAJ+AUtAynauTx/sgw2b52kMJdaLr0o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Marques <jorge.marques@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/444] i3c: master: Initialize ret in i3c_i2c_notifier_call()
Date: Mon, 18 Aug 2025 14:45:59 +0200
Message-ID: <20250818124501.420966556@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9b7a34f9eca2..c8e5c9291ea4 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2471,6 +2471,8 @@ static int i3c_i2c_notifier_call(struct notifier_block *nb, unsigned long action
 	case BUS_NOTIFY_DEL_DEVICE:
 		ret = i3c_master_i2c_detach(adap, client);
 		break;
+	default:
+		ret = -EINVAL;
 	}
 	i3c_bus_maintenance_unlock(&master->bus);
 
-- 
2.39.5



