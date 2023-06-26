Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380A5134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC866C433C0;
	Mon, 26 Jun 2023 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803978;
	bh=4unQ5CooluLlrhjnz4V4S0iXgBW2jpLyCCQZc6t9YZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1wpkg20klZirYqrpe+OumIIf2ZkrM4e/ZrBgf0MUF9mBmrysUDpa5pqnRXe3vEbD
	 iAqVDeqrq0X9Gz6bGCzT0e5hnga6dg91Gh2ZamaJaFir9HqK0HLiaTXeAMs6sG0eUP
	 yYm3s9w/nB+YyPbWxQBI30zzXtJQcdcWGVbr7llo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/41] HID: wacom: Add error check to wacom_parse_and_register()
Date: Mon, 26 Jun 2023 20:11:53 +0200
Message-ID: <20230626180737.408377567@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit 16a9c24f24fbe4564284eb575b18cc20586b9270 ]

   Added a variable check and
   transition in case of an error

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_sys.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 4e4a3424c1f9f..c50b26a9bc445 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2390,8 +2390,13 @@ static int wacom_parse_and_register(struct wacom *wacom, bool wireless)
 		goto fail_quirks;
 	}
 
-	if (features->device_type & WACOM_DEVICETYPE_WL_MONITOR)
+	if (features->device_type & WACOM_DEVICETYPE_WL_MONITOR) {
 		error = hid_hw_open(hdev);
+		if (error) {
+			hid_err(hdev, "hw open failed\n");
+			goto fail_quirks;
+		}
+	}
 
 	wacom_set_shared_values(wacom_wac);
 	devres_close_group(&hdev->dev, wacom);
-- 
2.39.2



