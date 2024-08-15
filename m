Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89F01AB53B;
	Thu, 15 Aug 2024 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731265; cv=none; b=I10z3eD2egoXI3Xmwpe7W1utE5xhFE3B7W2ogHFhwpqfjNFBwEwBZXgc6W3vTqWRIHNbnMY4aIxLG8ugVoWHqZ9soR2jAQIXXVh1ffWSeIBDz6RGuSw9Mixx+zb6D7z13Tmf6xu77kh3eAtpHhfDWcjkyfNQdvgxIKLvDibah2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731265; c=relaxed/simple;
	bh=Y9q130KcbAxiPn7Xh+PmbHBDv2ozXNjrFG/o7Kf/tkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3K6w8aEBwPvv2SzMdq8UIZ9F2RgE3kNpYPLnk5tkouP9v0BEU409KKiKodcmWMjtWBC4remTuc6bVT5ZWOSOOzxDGc22azrcdsGT7oVyCdJFayWsK4B0D6NCeXXek0XFS9ZQ+IeDeSFVzN3bigcepkSryczbMHMe7s9Q62uweU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFDzIFNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFDzIFNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A0FC4AF0A;
	Thu, 15 Aug 2024 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731265;
	bh=Y9q130KcbAxiPn7Xh+PmbHBDv2ozXNjrFG/o7Kf/tkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFDzIFNYMW8HedAsE9juQUDfZk80rXNr6xFjrnXHVPPDpI/uO9gcxWiy4EnMoPLdC
	 vYgZyqr0Kn6DxQMnMSn5KK4/kDyhXnuSncDvufjhdyyASeIvSlYfVwKzVOB0UJgudN
	 ltvn7mmF04siAJGlohl36Jp9Jvsjf0WIlYZ5JlmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/259] Input: elan_i2c - do not leave interrupt disabled on suspend failure
Date: Thu, 15 Aug 2024 15:23:28 +0200
Message-ID: <20240815131905.699036298@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index aaef8847f8862..5fc4edbb70a9a 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1295,6 +1295,8 @@ static int __maybe_unused elan_suspend(struct device *dev)
 	}
 
 err:
+	if (ret)
+		enable_irq(client->irq);
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
-- 
2.43.0



