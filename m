Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864EF6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEEDC433EF;
	Mon,  3 Apr 2023 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532615;
	bh=YpKGVIZwXXwpPXYfMjguBK41oZD5x+E7M/c8749YMQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1DfnN6eN74siqC6/n4LPP2hqACA4pCN0UYvWERdYRQh5KYAvZZ9p3Tn7cGebRYj5
	 KlbR+fCuhqE/kWyDuR5tTJ5d7d8Csxo7lfWV9qvF1jvi1+ZFQufzTQ9vHHBq2Fnb/O
	 STKHm0KPV12GTOai863d+iMm9XcsuQSI6ZbQ10n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/181] ALSA: asihpi: check pao in control_message()
Date: Mon,  3 Apr 2023 16:08:04 +0200
Message-Id: <20230403140416.752461760@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 9026c0bf233db53b86f74f4c620715e94eb32a09 ]

control_message() might be called with pao = NULL.
Here indicates control_message() as sample.

(B)	static void control_message(struct hpi_adapter_obj *pao, ...)
	{                                                   ^^^
		struct hpi_hw_obj *phw = pao->priv;
		...                      ^^^
	}

(A)	void _HPI_6205(struct hpi_adapter_obj *pao, ...)
	{                                      ^^^
		...
		case HPI_OBJ_CONTROL:
(B)			control_message(pao, phm, phr);
			break;          ^^^
		...
	}

	void HPI_6205(...)
	{
		...
(A)		_HPI_6205(NULL, phm, phr);
		...       ^^^^
	}

Therefore, We will get too many warning via cppcheck, like below

	sound/pci/asihpi/hpi6205.c:238:27: warning: Possible null pointer dereference: pao [nullPointer]
		 struct hpi_hw_obj *phw = pao->priv;
		                          ^
	sound/pci/asihpi/hpi6205.c:433:13: note: Calling function '_HPI_6205', 1st argument 'NULL' value is 0
		  _HPI_6205(NULL, phm, phr);
		            ^
	sound/pci/asihpi/hpi6205.c:401:20: note: Calling function 'control_message', 1st argument 'pao' value is 0
	   control_message(pao, phm, phr);
	                   ^
Set phr->error like many functions doing, and don't call _HPI_6205()
with NULL.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87ttypeaqz.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpi6205.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 27e11b5f70b97..c7d7eff86727f 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -430,7 +430,7 @@ void HPI_6205(struct hpi_message *phm, struct hpi_response *phr)
 		pao = hpi_find_adapter(phm->adapter_index);
 	} else {
 		/* subsys messages don't address an adapter */
-		_HPI_6205(NULL, phm, phr);
+		phr->error = HPI_ERROR_INVALID_OBJ_INDEX;
 		return;
 	}
 
-- 
2.39.2



