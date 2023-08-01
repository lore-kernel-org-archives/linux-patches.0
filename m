Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C121FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1491FC433C7;
	Tue,  1 Aug 2023 09:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882710;
	bh=klIyRPhZk1qjMfAf/bEyH2s8w7OPj8rpn0B/fHo3njE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ov/hcT14i2ohqNbPaT3Ol9niqFrH6pbsTV2kRg9shgnMIZqS/H8vOZqqf1PUqUuWe
	 Q1HNltrvWoLIf/SnTTbERcY6spA8Qy3TlSL0xG80HByAM7DWRlFrMWAS87D9dezDkO
	 2kwXwNI1SV8ihIHxBEfLSIVzS/ULE33NDSMT4Vn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.1 176/228] staging: ks7010: potential buffer overflow in ks_wlan_set_encode_ext()
Date: Tue,  1 Aug 2023 11:20:34 +0200
Message-ID: <20230801091929.230743107@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
@@ -1584,8 +1584,10 @@ static int ks_wlan_set_encode_ext(struct
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


