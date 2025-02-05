Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD3A202F83;
	Wed,  5 Feb 2025 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766517; cv=none; b=Uppav05P00ZT0MrjcaUcSKh/bGhKSjCHZIpeLA54DNjI4xGZjmer8RL+NhHh3/SF963ZEVPjsNPcmveAWkFI9XxvBpMUGVvf8+h9Om0yAmAOCKqfWbSAko8OinDDwigqvVLfTnit1zogdnB56KVVrM3UjtUE5BOR4XML9+1U6T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766517; c=relaxed/simple;
	bh=QSxoIHs2aqgAyQMoEUZ4uU0zY76qdKQiNcw3uFvL0XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0ZSsGU8oJRYW6J+G1l3LyMnlRUXOAsHqUkcsRFeF63N42Ci5ayPLzonLXi91WMePmIcUsUyfPB0eYckKSFZXIiLMTHrXziFeIDU/wMAWSQC4fct2cBX07fDQs3SSI+ACCYbEMbYN1TlRV1/hkujAL0lpW5S4tIhkqQlZZSBiYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO7gnuPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO7gnuPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8693FC4CED6;
	Wed,  5 Feb 2025 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766517;
	bh=QSxoIHs2aqgAyQMoEUZ4uU0zY76qdKQiNcw3uFvL0XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OO7gnuPXKZvK0n7cktqMVZUDhNCkP2YZ9Qr2UCU28w0vZMvb/pKis+th07CnHzkZd
	 vfRflDXOAQTNxwwWWULVSWA3m7fQ93aC4WIVZEvf3DcvyOq19+ebxvS9IF2vAOKCzD
	 mdq3g/wd8u7hFNKffMt6UtMawEoasN1A2xDTtZnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/590] RDMA/srp: Fix error handling in srp_add_port
Date: Wed,  5 Feb 2025 14:41:26 +0100
Message-ID: <20250205134507.940466628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit a3cbf68c69611188cd304229e346bffdabfd4277 ]

As comment of device_add() says, if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count.

Add a put_device() call before returning from the function to decrement
reference count for cleanup.

Found by code review.

Fixes: c8e4c2397655 ("RDMA/srp: Rework the srp_add_port() error path")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20241217075538.2909996-1-make_ruc2021@163.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2916e77f589b8..7289ae0b83ace 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3978,7 +3978,6 @@ static struct srp_host *srp_add_port(struct srp_device *device, u32 port)
 	return host;
 
 put_host:
-	device_del(&host->dev);
 	put_device(&host->dev);
 	return NULL;
 }
-- 
2.39.5



