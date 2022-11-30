Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F2A79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FE5C433D6;
	Wed, 30 Nov 2022 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833238;
	bh=y5UgD859p+CTJ4HK6UJ4KZu6Bn1Py07EItTPJ2LfZvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXUV4FesDcLoWvZD8LnqAwNoF4hxYTp1PCJBfJL9wweQ8J63s8QI24wsy0M5VCblZ
	 zU5bH7peKVPPZRcDZDRS9HOIzYbHp0o2H0p/K3EjLTtLVapOjB6hsHtOzD2NNrh7np
	 zpMoV2xl/o9fCUxol7JVya9IHayrAGCbZNudPtU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/206] wifi: airo: do not assign -1 to unsigned char
Date: Wed, 30 Nov 2022 19:21:27 +0100
Message-Id: <20221130180533.885730215@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit e6cb8769452e8236b52134e5cb4a18b8f5986932 ]

With char becoming unsigned by default, and with `char` alone being
ambiguous and based on architecture, we get a warning when assigning the
unchecked output of hex_to_bin() to that unsigned char. Mark `key` as a
`u8`, which matches the struct's type, and then check each call to
hex_to_bin() before casting.

Cc: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221024162843.535921-1-Jason@zx2c4.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 65dd8cff1b01..fc19ecbc4c08 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5233,7 +5233,7 @@ static int get_wep_tx_idx(struct airo_info *ai)
 	return -1;
 }
 
-static int set_wep_key(struct airo_info *ai, u16 index, const char *key,
+static int set_wep_key(struct airo_info *ai, u16 index, const u8 *key,
 		       u16 keylen, int perm, int lock)
 {
 	static const unsigned char macaddr[ETH_ALEN] = { 0x01, 0, 0, 0, 0, 0 };
@@ -5284,7 +5284,7 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
 	int i, rc;
-	char key[16];
+	u8 key[16];
 	u16 index = 0;
 	int j = 0;
 
@@ -5312,12 +5312,22 @@ static void proc_wepkey_on_close(struct inode *inode, struct file *file)
 	}
 
 	for (i = 0; i < 16*3 && data->wbuffer[i+j]; i++) {
+		int val;
+
+		if (i % 3 == 2)
+			continue;
+
+		val = hex_to_bin(data->wbuffer[i+j]);
+		if (val < 0) {
+			airo_print_err(ai->dev->name, "WebKey passed invalid key hex");
+			return;
+		}
 		switch(i%3) {
 		case 0:
-			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
+			key[i/3] = (u8)val << 4;
 			break;
 		case 1:
-			key[i/3] |= hex_to_bin(data->wbuffer[i+j]);
+			key[i/3] |= (u8)val;
 			break;
 		}
 	}
-- 
2.35.1



