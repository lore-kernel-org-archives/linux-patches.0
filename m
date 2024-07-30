Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEB81A6192;
	Tue, 30 Jul 2024 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359115; cv=none; b=S10O4Uw+j9NtwXVui0OsuW3F9k0xxwr6VzG8Pic9AsfXWMSE4wWV6DbWUpcrYbWQB4JJIGN6F20eeP2jTfV6zKYcJFvC/rE5PNqHio5dOwq0uHOds8cAbrdRNVqgkLReleNvSj4db+sKbkTK/e4Ow1cdFxMr/mlXeOQwC9CuuFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359115; c=relaxed/simple;
	bh=ChZT42jbFhNDWYgFO8dBUNh1Y9lTVJ2F7Pih0Gv3+uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl/tkne3rf1sGk6puni1AcldI59R2bJDWpYbuOYIfDa7R5iYmCY9UzmKjN0aYdSlGUnqAI+9jRPT3xcMSowHjbDvEbe7wjRz4Hdb4kzeI2KuiA7dt5Ez7qLyAijGPpD/CVWlRjDopApfSlVBcfru4moDrGqeV+aWZb/nqHzs0PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBQ9Qqrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBQ9Qqrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7653AC32782;
	Tue, 30 Jul 2024 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359114;
	bh=ChZT42jbFhNDWYgFO8dBUNh1Y9lTVJ2F7Pih0Gv3+uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBQ9Qqrh2O2oCjRW8SaQ6CM8ybz4be0eKySuAF293vhqn8r3Sl/sd1n52ZcRQE7Vp
	 84qlLXXwB3vSp9T8KJ959pqgoz9TVM4t6UCwoeVmz0VkN1e4KnqkHJUEdP1ZcMk+JJ
	 tDp9A98dOPIQz4pb3olo4hemmeB/3Uy9o1NPP70w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 435/809] Input: elan_i2c - do not leave interrupt disabled on suspend failure
Date: Tue, 30 Jul 2024 17:45:11 +0200
Message-ID: <20240730151741.884365153@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5f82c1e04721e7cd98e604eb4e58f0724d8e5a65 ]

Make sure interrupts are not left disabled when we fail to suspend the
touch controller.

Fixes: 6696777c6506 ("Input: add driver for Elan I2C/SMbus touchpad")
Link: https://lore.kernel.org/r/ZmKiiL-1wzKrhqBj@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elan_i2c_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index c2aec5c360b3b..ce96513b34f64 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1356,6 +1356,8 @@ static int elan_suspend(struct device *dev)
 	}
 
 err:
+	if (ret)
+		enable_irq(client->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
-- 
2.43.0



