Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338061487DB;
	Tue, 23 Jan 2024 00:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969156; cv=none; b=Hvn2sDnx/QVq10aQSQJaKsYsBOTw7t+gB7+1iAS5EEfd0mCrYjf4sJmlx3PyiJ0ZPhpKPxgBPrNhSlYdFx4y3pF48sfG40+nJNRCR/5soWcsoNfZC/CCga5e7s8kioNIfBx0zLWkjQCR9k39knnDgwhph3kSH1YkKbKCyNGD0BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969156; c=relaxed/simple;
	bh=3UORLJF23EX2cz/4UzIgd772ZEusQ8GKgCKrSCZYMNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmQR9j0Ec4HFEaPjQXzrGHQ3LpIpexEf2Gd2EdBGPwXZRwpBPKOPQCJVLtoPhTyRdP+TFrDNbgTBZs4+gSxqwQztz1SsirPiiaqPxXzQx9WQf6W1PYUlUBZT+jFrnaulfQ3FqA5nl4o2XYd6L9RWhtbdYQeoukFweDzo0HyQdrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I53z3oey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I53z3oey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F01C43399;
	Tue, 23 Jan 2024 00:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969156;
	bh=3UORLJF23EX2cz/4UzIgd772ZEusQ8GKgCKrSCZYMNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I53z3oeyVXyQl7LEcwYBgIXXRUUykLYuSao7NqIIyuRVtDnyF/L9SGETiuMOf9UfM
	 UgPnqrcW/KEzKj5LfIDAsE3pth5kGoQCdfAYSHkR/Xiyuen2MeEAMN2uWs8TPCKE2b
	 menY5245/pmbxCjZSKIr8xs0bYmij3GV3QXzPndA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 026/641] KEYS: encrypted: Add check for strsep
Date: Mon, 22 Jan 2024 15:48:50 -0800
Message-ID: <20240122235818.914706597@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b4af096b5df5dd131ab796c79cedc7069d8f4882 ]

Add check for strsep() in order to transfer the error.

Fixes: cd3bc044af48 ("KEYS: encrypted: Instantiate key with user-provided decrypted data")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/encrypted-keys/encrypted.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 8af2136069d2..76f55dd13cb8 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -237,6 +237,10 @@ static int datablob_parse(char *datablob, const char **format,
 			break;
 		}
 		*decrypted_data = strsep(&datablob, " \t");
+		if (!*decrypted_data) {
+			pr_info("encrypted_key: decrypted_data is missing\n");
+			break;
+		}
 		ret = 0;
 		break;
 	case Opt_load:
-- 
2.43.0



