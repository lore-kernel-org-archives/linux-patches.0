Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ECB23DF
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7351CC433C8;
	Sun, 17 Sep 2023 19:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979030;
	bh=V7aXnkm8c14k0phaBAh829TCfPd2JTzDwFqbL1EUepU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2kQjtpQBZS+OwWrnXBPjdqEqdJEIoRkRi5VmHm26EbooMp3EJrKyC0eQ+4iEblig
	 f21Wfts9p2NbrFDRYdDFN2E6qjXf6w0I3PIyQ/ErvnOuQ83ngMDc4YuCLnaaFAfa8I
	 2rIRLCGjS+DqqJA0HRADwfrnoZMDis1gC2HNKGqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Corey Minyard <minyard@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/406] ipmi:ssif: Add check for kstrdup
Date: Sun, 17 Sep 2023 21:10:23 +0200
Message-ID: <20230917191105.646393702@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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
index a3745fa643f3b..87aa12ab8c66f 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1614,6 +1614,11 @@ static int ssif_add_infos(struct i2c_client *client)
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



