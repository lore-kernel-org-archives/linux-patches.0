Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AF6BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F3CC4339B;
	Tue,  7 Mar 2023 18:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213334;
	bh=sudEGX5W3BmZp3WlcZvi252H6S5xawGJzPodbomXd9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bro+9CM2qaxqRFRKa0C4KgJn7x78glqSeidi/BQdumYKAR7TSUYcE52O0Obwrk/GR
	 JTAU2FCQegxMdv+fs1EHTR4U4u2sL5J/PqlI9FkLgDuTosuN56MRxtX5r26pZcxyzr
	 HNZdEXv0N5GbuXwHqDhu6h+nnONpa9qpg5cis2Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 444/885] drivers: base: transport_class: fix possible memory leak
Date: Tue,  7 Mar 2023 17:56:18 +0100
Message-Id: <20230307170021.735702114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a86367803838b369fe5486ac18771d14723c258c ]

Current some drivers(like iscsi) call transport_register_device()
failed, they don't call transport_destroy_device() to release the
memory allocated in transport_setup_device(), because they don't
know what was done, it should be internal thing to release the
resource in register function. So fix this leak by calling destroy
function inside register function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221110102307.3492557-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/transport_class.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 63076fb835e34..2efc271a96fa6 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -70,8 +70,14 @@ void transport_destroy_device(struct device *);
 static inline int
 transport_register_device(struct device *dev)
 {
+	int ret;
+
 	transport_setup_device(dev);
-	return transport_add_device(dev);
+	ret = transport_add_device(dev);
+	if (ret)
+		transport_destroy_device(dev);
+
+	return ret;
 }
 
 static inline void
-- 
2.39.2



