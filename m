Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A17544376;
	Thu, 15 Aug 2024 13:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729648; cv=none; b=WPSZd8CJn86snCTNfPzt6lJMXrTk76e6Rrc0u9VQaFwFtzp8p5n9ztJmicaiKepfffz6EWhATV83Ng21I0jZznc4asbvJAODyqfeyohpJ9GRqsP1NaT1r0fHndWTp6/HNE6UnXfy8WP18XN/sfP3+hCh2ErZ+Chu/zsExM6Fo6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729648; c=relaxed/simple;
	bh=Mfvrx7i0l5aeuW48kQTX5N5ibXvvazA6JM7fv/m2RbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvfpwUIeiBWmXMRjsL8WSh4YQLoXXDuzaS9A1yHP6IT3iREJw9reEfG/lYphTtBQPEcOOmRu88Im080ZPBT7jusqNkSdb7xB3RibDxqJv1KT7GpGt9EgeFg9ktLimYBVUoEDiBsKx7vHLz03ksWj7tj3H1ZDRggK8ZM1cND/y3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEdxR0b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEdxR0b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F381DC32786;
	Thu, 15 Aug 2024 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729648;
	bh=Mfvrx7i0l5aeuW48kQTX5N5ibXvvazA6JM7fv/m2RbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEdxR0b+vUvcez3MtpW58Alhjaax6YuleWeGwQHxvomHCQdzTn7r1Iu2QtupLcZQT
	 zGuluKXaDs11DIuJQUdRQSZjFPMId1kmysqzGLONG8XICBWRjyBqEywKgBYZ72heTy
	 cTLX0lEk3EoulRlfG2WisvEBfM5+glWzFvxtXuXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/484] Input: elan_i2c - do not leave interrupt disabled on suspend failure
Date: Thu, 15 Aug 2024 15:19:51 +0200
Message-ID: <20240815131946.543575748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index e1758d5ffe421..a5f067b93ab9a 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1378,6 +1378,8 @@ static int __maybe_unused elan_suspend(struct device *dev)
 	}
 
 err:
+	if (ret)
+		enable_irq(client->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
-- 
2.43.0



