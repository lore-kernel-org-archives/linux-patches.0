Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1809D1A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wg80ijAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E79EC433C8;
	Mon,  9 Oct 2023 13:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857899;
	bh=FNaUEuZyx/z/bqXG87F267eBDzQTHk11B6XOXdFYaUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wg80ijAuq3wlfll/GqsZSwp4IB6hC/AtN+ksdBgIpSAy7rJsBsRdaCfma+0yhYt1l
	 l3RseXIxk94MqeJRWLU0Tr0DADFk4z0w0s1juvBT/PgYLjVTL+g5YSr3nvaMgwZMH9
	 n+kQJhDBCqc2UPtAkvycZOI7PVV+fFL0IlB2kf3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/75] HID: sony: Fix a potential memory leak in sony_probe()
Date: Mon,  9 Oct 2023 15:01:50 +0200
Message-ID: <20231009130112.216847429@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e1cd4004cde7c9b694bbdd8def0e02288ee58c74 ]

If an error occurs after a successful usb_alloc_urb() call, usb_free_urb()
should be called.

Fixes: fb1a79a6b6e1 ("HID: sony: fix freeze when inserting ghlive ps3/wii dongles")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sony.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 60ec2b29d54de..3ab18811b0090 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -3074,6 +3074,9 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return ret;
 
 err:
+	if (sc->ghl_urb)
+		usb_free_urb(sc->ghl_urb);
+
 	hid_hw_stop(hdev);
 	return ret;
 }
-- 
2.40.1



