Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43D3218CA;
	Mon, 18 Aug 2025 13:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522551; cv=none; b=h5zi8dW591fkhBKPEyLEMuwYRR7251Y35zIYgjsXFxxxvZOFrWTtALZMrs8b2rSyDdwoLwFw5B3+G125CVOeBUYYdNdFfOdV2rAaZ641zd4dzqMyPcT+jRbZ8Fj4Kv3PeukhYQZkkK5H1saVS8jKho2fkVnkwR7Ry1zvPn34LS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522551; c=relaxed/simple;
	bh=u/3ElNYB7qyEyDvS3YiXjeJc9d8gj6qmxuQ9zW6qeN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxY+lMnZJXqovf0VUMv5AF0D6f4WZp+uY17DClYDWf/PAXuyDVL5pb+LUHAWCJJFVLltUkNWukX4cA/Aow0kV8KvPzUeP+cW8okrxtgNR0V5mQEWykNtNNGikE/ityHKZZBy8j9o1tc5vfE1wKD/dmQbUhJOOXmoVZPLL8AuBCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nxUClUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nxUClUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA78C4CEEB;
	Mon, 18 Aug 2025 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522550;
	bh=u/3ElNYB7qyEyDvS3YiXjeJc9d8gj6qmxuQ9zW6qeN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nxUClUV8T4DNnye/cEU+qheXbDhZ/d/2f5N/He30POpPgI3ImceAPKIh9bz3uJca
	 hEHYctlcBnF4Dc+bcFheL+kf2tmXbL8ew7erfDgYfDM1W44t+AYSi7PyB4+S3rOG5P
	 6upu0ADrUk28yKmJOQvmapQ8bGZkkmpyVlckDkEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/444] ipmi: Use dev_warn_ratelimited() for incorrect message warnings
Date: Mon, 18 Aug 2025 14:46:15 +0200
Message-ID: <20250818124502.008876061@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ec50ec378e3fd83bde9b3d622ceac3509a60b6b5 ]

During BMC firmware upgrades on live systems, the ipmi_msghandler
generates excessive "BMC returned incorrect response" warnings
while the BMC is temporarily offline. This can flood system logs
in large deployments.

Replace dev_warn() with dev_warn_ratelimited() to throttle these
warnings and prevent log spam during BMC maintenance operations.

Signed-off-by: Breno Leitao <leitao@debian.org>
Message-ID: <20250710-ipmi_ratelimit-v1-1-6d417015ebe9@debian.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 6a4a8ecd0edd..09405668ebb3 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4617,10 +4617,10 @@ static int handle_one_recv_msg(struct ipmi_smi *intf,
 		 * The NetFN and Command in the response is not even
 		 * marginally correct.
 		 */
-		dev_warn(intf->si_dev,
-			 "BMC returned incorrect response, expected netfn %x cmd %x, got netfn %x cmd %x\n",
-			 (msg->data[0] >> 2) | 1, msg->data[1],
-			 msg->rsp[0] >> 2, msg->rsp[1]);
+		dev_warn_ratelimited(intf->si_dev,
+				     "BMC returned incorrect response, expected netfn %x cmd %x, got netfn %x cmd %x\n",
+				     (msg->data[0] >> 2) | 1, msg->data[1],
+				     msg->rsp[0] >> 2, msg->rsp[1]);
 
 		goto return_unspecified;
 	}
-- 
2.39.5



