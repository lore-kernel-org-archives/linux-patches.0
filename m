Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004941FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F0FC433C8;
	Tue,  1 Aug 2023 09:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883265;
	bh=WVRwoKwrLONAYgMK5eNciSc9jTW6AGrgvZ0VpqpNpgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Me2LOiJKq4AYBRANVEsLIqgI/v7AgFybkekeVIt0OFPZ7VSNuci2UcR33LqCEbPr8
	 ld9nHGsNKPH0lJs0pIiS4mgtfCPa6gRBEwTfxNsjyB4mzIT0aT3YmJrf++5Yv3dsvF
	 n1QjR+oCsXDrh+doixvfyCa3vrgQSgU44JGiAn9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.4 174/239] staging: ks7010: potential buffer overflow in ks_wlan_set_encode_ext()
Date: Tue,  1 Aug 2023 11:20:38 +0200
Message-ID: <20230801091931.916187852@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Shurong <zhang_shurong@foxmail.com>

commit 5f1c7031e044cb2fba82836d55cc235e2ad619dc upstream.

The "exc->key_len" is a u16 that comes from the user.  If it's over
IW_ENCODING_TOKEN_MAX (64) that could lead to memory corruption.

Fixes: b121d84882b9 ("staging: ks7010: simplify calls to memcpy()")
Cc: stable <stable@kernel.org>
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/tencent_5153B668C0283CAA15AA518325346E026A09@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/ks7010/ks_wlan_net.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/ks7010/ks_wlan_net.c
+++ b/drivers/staging/ks7010/ks_wlan_net.c
@@ -1583,8 +1583,10 @@ static int ks_wlan_set_encode_ext(struct
 			commit |= SME_WEP_FLAG;
 		}
 		if (enc->key_len) {
-			memcpy(&key->key_val[0], &enc->key[0], enc->key_len);
-			key->key_len = enc->key_len;
+			int key_len = clamp_val(enc->key_len, 0, IW_ENCODING_TOKEN_MAX);
+
+			memcpy(&key->key_val[0], &enc->key[0], key_len);
+			key->key_len = key_len;
 			commit |= (SME_WEP_VAL1 << index);
 		}
 		break;


