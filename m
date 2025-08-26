Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DCF223335;
	Tue, 26 Aug 2025 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217337; cv=none; b=nM9tMOkEinvVaIqgokKSAP9JDFZ9kDavjLTXGAIv8zMPsltbM622+qKTquSqBj/4VvHuQRdW456UXgq1xBHVgo27cYxvlf+ZlXkz7qd11tiQ6y5yqoCHOtnPmm5uhWIvrmhjyqXw8UyKQNJ2q5qOAz3Yq18otmQ1ABGOA55VEcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217337; c=relaxed/simple;
	bh=kgrqdfcQZJ15uygipZhogQfcW0TZdtF7WbFl4EIiVyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcAXEfO+sAFRrB7PFZ1/i/TFrP28zSwL4zP6JTeAWuRQUR8nM0214xfqxNmNQIQJrgVhq3UXKm+d8v3luCP1nYTGJrO7LABjMQUFNntjPd1fdS7MLW8jRhs6rHXD1S8Xmd7r/sakKPRv/HdMCrca2XE3V/sApR4lfCdOkh6Hi7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRWSTGsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRWSTGsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DA8C4CEF1;
	Tue, 26 Aug 2025 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217337;
	bh=kgrqdfcQZJ15uygipZhogQfcW0TZdtF7WbFl4EIiVyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRWSTGsXPvEfJr9RUezDau45KJbcf4hK9tEWw7jS6/xgYZXiyaQR41L33DSiX1W0k
	 mnCcT8iS+k2jYx1Gh4/LiICqSl4taDqJ8aa194AbQtIclq6mSbtZ5/ZOiBOnmY5Opt
	 wiFzfPPoe4C5bVrkeSUtA2Pib1PvanY6TsE1BoRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiwen <forbidden405@outlook.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 064/523] i2c: qup: jump out of the loop in case of timeout
Date: Tue, 26 Aug 2025 13:04:34 +0200
Message-ID: <20250826110926.159249308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiwen <forbidden405@outlook.com>

commit a7982a14b3012527a9583d12525cd0dc9f8d8934 upstream.

Original logic only sets the return value but doesn't jump out of the
loop if the bus is kept active by a client. This is not expected. A
malicious or buggy i2c client can hang the kernel in this case and
should be avoided. This is observed during a long time test with a
PCA953x GPIO extender.

Fix it by changing the logic to not only sets the return value, but also
jumps out of the loop and return to the caller with -ETIMEDOUT.

Fixes: fbfab1ab0658 ("i2c: qup: reorganization of driver code to remove polling for qup v1")
Signed-off-by: Yang Xiwen <forbidden405@outlook.com>
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250616-qca-i2c-v1-1-2a8d37ee0a30@outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -452,8 +452,10 @@ static int qup_i2c_bus_active(struct qup
 		if (!(status & I2C_STATUS_BUS_ACTIVE))
 			break;
 
-		if (time_after(jiffies, timeout))
+		if (time_after(jiffies, timeout)) {
 			ret = -ETIMEDOUT;
+			break;
+		}
 
 		usleep_range(len, len * 2);
 	}


