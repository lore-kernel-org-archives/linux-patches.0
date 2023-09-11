Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F3C11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98C1C433C8;
	Mon, 11 Sep 2023 14:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443520;
	bh=skXZl1EARMAgyaPznX1qmRxLDOh0bsYTkYNhUen53sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afd2FRbuaEDggt+EFf976E3rnZzd9LgpCAWPq2L+EFsp42t5WdA6JlNXLj3foN3wy
	 ZQQeGe+ZfGnFFq8KU0+FMQnU7C9sFXRR6x++TimDCBO2sb09ZnyLhe6zR6FEfQwocE
	 fywqigBlQaPxyOPeBCdCUv6bwZrgl6gVm0HeM0Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Corey Minyard <minyard@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 407/737] ipmi:ssif: Add check for kstrdup
Date: Mon, 11 Sep 2023 15:44:26 +0200
Message-ID: <20230911134701.993604290@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c5586d0f711e9744d0cade39b0c4a2d116a333ca ]

Add check for the return value of kstrdup() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: c4436c9149c5 ("ipmi_ssif: avoid registering duplicate ssif interface")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Message-Id: <20230619092802.35384-1-jiasheng@iscas.ac.cn>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 3b921c78ba083..3b87a2726e994 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1600,6 +1600,11 @@ static int ssif_add_infos(struct i2c_client *client)
 	info->addr_src = SI_ACPI;
 	info->client = client;
 	info->adapter_name = kstrdup(client->adapter->name, GFP_KERNEL);
+	if (!info->adapter_name) {
+		kfree(info);
+		return -ENOMEM;
+	}
+
 	info->binfo.addr = client->addr;
 	list_add_tail(&info->link, &ssif_infos);
 	return 0;
-- 
2.40.1



