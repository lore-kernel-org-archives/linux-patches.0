Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7879963C;
	Thu, 15 Aug 2024 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732201; cv=none; b=lw/aN2NgPkNp0gtD/rFxHbU7FJfVqXl0FbVVvZ+oRFYP6joclGeOOCrgcHy/0q2BsMzP+O3KWZN57mBqQd707uqp2UinTbBurvr5msxdHlN0RHedGmvuPx2hI5jiTjVfxeIgS1xpOOUH4zBFEuDJuIg2M7PNBm7IhWQzvfm7cQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732201; c=relaxed/simple;
	bh=YaFHMk7RjM921jw28kEgJhMUx4UIrqsdoGrXPQP8m54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dngAOXSRSGzZMcmCvXKlYKy6iUlI4RXLKNE6McKutiZ2JLIx7VR2/MUKHjwubzsQuwfsXcq6FGqOh6K7mfWA1Ens+MBma6fEQeN55ih2lmSdWSgeIZ4sINNlPyUOB8+TR7gTlQHpin6uRu3Jy4WwoXE/uiOjop3ZJwbb/eu4iPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XS+efajU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XS+efajU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B05C4AF11;
	Thu, 15 Aug 2024 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732201;
	bh=YaFHMk7RjM921jw28kEgJhMUx4UIrqsdoGrXPQP8m54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XS+efajUNqWciFoTPyKF2YgaiLklVaZRXC99xz8DxOW9/CSUbnvOQu6xdw/K5Jt0j
	 QTbLr/XOHmk+eCBjE4Ljw3z3AthXkACieWkKM4sUtfzBXEJQ3MBPa0B6LE8YnGdVDr
	 SeAfH+nqZ7wLstdIbi9pBNlg5NA/uJ4hqgSBQucQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/352] Input: elan_i2c - do not leave interrupt disabled on suspend failure
Date: Thu, 15 Aug 2024 15:22:51 +0200
Message-ID: <20240815131923.317704082@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f59c8b245f24..14c2c66414f4e 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1340,6 +1340,8 @@ static int __maybe_unused elan_suspend(struct device *dev)
 	}
 
 err:
+	if (ret)
+		enable_irq(client->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
-- 
2.43.0



