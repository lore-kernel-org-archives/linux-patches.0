Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1601F6698;
	Tue,  3 Dec 2024 14:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237782; cv=none; b=Be3FxGivoZ0tcCcvmnxoFt5asTuW3TzsA/64fQK25BKYA1netQ33CNUgm0XudDL5CyEQ5A5GEngKCtHlNXaK2GjrB0OyP6YcQ45oAQzpcsRQgjp3FCsTiWeIDr6z1uX/h1AR8Elmno8TTHmj+rM5BlbUiAQX25Hl7D6sqLd4NX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237782; c=relaxed/simple;
	bh=H0xQND0Ka/zrpSzsyn3EdMIEqDjQL0wYcb0jsK6eJFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBVYZD585IFJsxIauROak55KIOHVZUNJ37L/0i12EJyspKoN/2aCVjCE1ePZNZMNjifUsfCzFNnTO+J+t4IQHixx/30AKTjaW/nS9idTpoj/4i/6Qt1XnU6t8TWIgDBMGSwYft16jzqv/YT+KRV2DNJLVkAP4MRx/R+EWlAqZd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6fNNfGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6fNNfGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CEAC4CED6;
	Tue,  3 Dec 2024 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237782;
	bh=H0xQND0Ka/zrpSzsyn3EdMIEqDjQL0wYcb0jsK6eJFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6fNNfGDJIrV2wan7hARGDAehItq/555OSz55QcGb/ztZooSAFPcSoxElW0pMVtjX
	 UeCsx6l0LiYmaBqsclFQ0rZN3xcaPfq5+iWo7vM3KSHisEb+CGltN2Z49y3TW8jpEo
	 CUfz9DfgQVwsgplvQW0dpbb/TImP8HPkPB6R+/FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 037/817] integrity: Use static_assert() to check struct sizes
Date: Tue,  3 Dec 2024 15:33:29 +0100
Message-ID: <20241203143957.100526724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 08ae3e5f5fc8edb9bd0c7ef9696ff29ef18b26ef ]

Commit 38aa3f5ac6d2 ("integrity: Avoid -Wflex-array-member-not-at-end
warnings") introduced tagged `struct evm_ima_xattr_data_hdr` and
`struct ima_digest_data_hdr`. We want to ensure that when new members
need to be added to the flexible structures, they are always included
within these tagged structs.

So, we use `static_assert()` to ensure that the memory layout for
both the flexible structure and the tagged struct is the same after
any changes.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Tested-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/integrity.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 660f76cb69d37..c2c2da6911233 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -37,6 +37,8 @@ struct evm_ima_xattr_data {
 	);
 	u8 data[];
 } __packed;
+static_assert(offsetof(struct evm_ima_xattr_data, data) == sizeof(struct evm_ima_xattr_data_hdr),
+	      "struct member likely outside of __struct_group()");
 
 /* Only used in the EVM HMAC code. */
 struct evm_xattr {
@@ -65,6 +67,8 @@ struct ima_digest_data {
 	);
 	u8 digest[];
 } __packed;
+static_assert(offsetof(struct ima_digest_data, digest) == sizeof(struct ima_digest_data_hdr),
+	      "struct member likely outside of __struct_group()");
 
 /*
  * Instead of wrapping the ima_digest_data struct inside a local structure
-- 
2.43.0



