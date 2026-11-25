Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623925;
	b=M/oMrbbdnyyk6Y7JTUtfzGP8RREoXxB05LL84yfLbvMa04VbrgVY+NNNqTDw22BTvaKa
	 +yRbgtQAQvw3IS4LPgO73aMqYuG1zbgfnhctSF4hyFOSIHoD7vNUpzw8fqIOOUNLoXm9J
	 qcMR2Qh+176eWUB8MumG4LUoM4Z1ZKjL2a0brruI7o137KlDnNbQGKU0c6J/C7b7vk4gU
	 qHFSN/WJvrsL2vyQO9auNHpyj3lZP7JX18z4cJcW/HR1IlZxUWlYiOx2npl3ZmLQzMJ59
	 MRVfjwOhFq9OZ+e0s3f1rBuWcOunRB1AKUxFMhfX0ypdV5SD4Ut4/bAoIgFRJUaQNPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+FZPjj7XUzq5E72yv3zIVle38JyGez5/WibpCioMmM=;
	b=0Nog7ZU9O00qh/45MbgCFzNFigY1NSzJWB1mmWwz58HJeNPfGpBa89Fyn21ue7UiMeR5
	 huiHPr34IQJg0wjsstXOfQcPXqWLrG9RsMFXdIUUzhlYhu4etdCB/qMD00fIbdKhdRVhF
	 Ahz2Ise73pEQPVyR5ozUMm67eiZcbztobwCAEI2GUGRecwFHOTfTuNzzmzRYNg+9PYtII
	 16kH9dWXsY0CsZjfmQVUruiTB2fxsen8ggTFURj+SGRIkrq6GCSksIrQqnCb79/iAQwWo
	 U5ItaWdicAgTgnR7MwYrApmkSXm9DkqqXbY2xl8TykkQ1Wt7RYLUUEK5WJl5jC9NVBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAUScg06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD0606A323;
	Wed, 25 Nov 2026 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAUScg06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23CB1F000C4;
	Wed, 25 Nov 2026 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623925;
	bh=v+FZPjj7XUzq5E72yv3zIVle38JyGez5/WibpCioMmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAUScg06xNOE5hF6F/o7JCH/9ajVqLU0hyao45RDJPS3bX2E4UBnyTIMKaCLpVXMp
	 EOEyLctg/M6ile2rCZTtSQu1QXdFhnHU6hNpLTicFpYaArXG7Nl+hBQvBoHFJI+hms
	 FCMKVi6BaPNI06qeYpiNxP6fT8yMYb87UiTKCbAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/816] udf: validate VAT inode size for old VAT format
Date: Wed, 25 Nov 2026 15:26:17 +0100
Message-ID: <20261125143849.891422783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 5163e6ee1ea744d412fe516235bfd9cab15141dc ]

Validate VAT inode is large enough to contain at least the header for
pre-2.00 UDF media format.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8d3d758714da2..ea9cd593ffbbb 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1319,6 +1319,11 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 
 	if (map->s_partition_type == UDF_VIRTUAL_MAP15) {
 		map->s_type_specific.s_virtual.s_start_offset = 0;
+		if (sbi->s_vat_inode->i_size < 36) {
+			udf_err(sb, "Too short VAT inode size %lld\n",
+				sbi->s_vat_inode->i_size);
+			return -EFSCORRUPTED;
+		}
 		map->s_type_specific.s_virtual.s_num_entries =
 			(sbi->s_vat_inode->i_size - 36) >> 2;
 	} else if (map->s_partition_type == UDF_VIRTUAL_MAP20) {
-- 
2.53.0



