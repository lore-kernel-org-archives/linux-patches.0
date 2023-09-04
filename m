Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA69C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9BEC433C8;
	Mon,  4 Sep 2023 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852404;
	bh=/y7HtFDQaPPgd/tnSNCdxlJ4Oaza/xZ5cu/PZlxvvm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqYoaRCXXbRVULY19wS1IRiILqsgeCES5MNvbjzAQ6f/s+JvZiIuS/eHKHIUVOrJg
	 uiTDxNjFGamIrPw7rG8piTH2EU9+M8E7EvzJBj9AY0ocqq7N39P8EMY54LpZo8Jnsx
	 qP822fDkXLM5ptf25O2iM8oeClQZL3taIRfc/wxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.4 02/32] ksmbd: fix wrong DataOffset validation of create context
Date: Mon,  4 Sep 2023 19:30:00 +0100
Message-ID: <20230904182948.011582020@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>
References: <20230904182947.899158313@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 17d5b135bb720832364e8f55f6a887a3c7ec8fdb upstream.

If ->DataOffset of create context is 0, DataBuffer size is not correctly
validated. This patch change wrong validation code and consider tag
length in request.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21824
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1492,7 +1492,7 @@ struct create_context *smb2_find_context
 		    name_len < 4 ||
 		    name_off + name_len > cc_len ||
 		    (value_off & 0x7) != 0 ||
-		    (value_off && (value_off < name_off + name_len)) ||
+		    (value_len && value_off < name_off + (name_len < 8 ? 8 : name_len)) ||
 		    ((u64)value_off + value_len > cc_len))
 			return ERR_PTR(-EINVAL);
 


