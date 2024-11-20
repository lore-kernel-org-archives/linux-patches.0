Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147A11ABEC5;
	Wed, 20 Nov 2024 13:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107698; cv=none; b=TmJ2g13NyFTlMl6AjIEGtbeTyi6DwpjFeOqnA3J3wlbocFwtgfMmvM4yvBsRHfs0Xc7yKn7D0vQKPSP250lHzHDH0SqxZeElOl4P3DcVgHqnT0IFgszhfVIApcQ49sDMT/mD0zHhWz6EkPngFuWTgY2zFEd+pa+TyBbZo8kzn48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107698; c=relaxed/simple;
	bh=r7+NYWb4pCG048+V98/vNzre5FuZGg2B1EDnNc2JPXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuIs/G+JtNHdHoDP5vgaTjXZwGBo8hkmxFb74x9dQxF7Ya4ql8tvn3s7KuOWdyJtRHqIQeJbCBDj2a9rdE02MbY83u1Gmu9yf7n0fJP9yIr7vNfMmQf4b75dEGjBPh0olycFYHACPg4bQUMb4d9s4nrKUZ9usn21ZK2EWFkEC8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uH5NGg9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uH5NGg9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DF4C4CECD;
	Wed, 20 Nov 2024 13:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107698;
	bh=r7+NYWb4pCG048+V98/vNzre5FuZGg2B1EDnNc2JPXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uH5NGg9M421I7wdcLUT3IhoduFUbMreRaaLne6UPZItxkuRNjbWofLhkYLvAzI9tx
	 /odABMC0PdQ5QVm8Vx/GSgDuHja7V/XwWuGNtijgsnlzgs+kzlq3L/BJ4PyCBRJ+02
	 UZPbMqLObqirgk0IOd1sK0K6b9+ObrC0Qprdtvjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Enrico Bravi (PhD at polito.it)" <enrico.bravi@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.1 21/73] ima: fix buffer overrun in ima_eventdigest_init_common
Date: Wed, 20 Nov 2024 13:58:07 +0100
Message-ID: <20241120125810.126285081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

commit 923168a0631bc42fffd55087b337b1b6c54dcff5 upstream.

Function ima_eventdigest_init() calls ima_eventdigest_init_common()
with HASH_ALGO__LAST which is then used to access the array
hash_digest_size[] leading to buffer overrun. Have a conditional
statement to handle this.

Fixes: 9fab303a2cb3 ("ima: fix violation measurement list record")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Tested-by: Enrico Bravi (PhD at polito.it) <enrico.bravi@huawei.com>
Cc: stable@vger.kernel.org # 5.19+
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_template_lib.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 4183956c53af..0e627eac9c33 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -318,15 +318,21 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
 				      hash_algo_name[hash_algo]);
 	}
 
-	if (digest)
+	if (digest) {
 		memcpy(buffer + offset, digest, digestsize);
-	else
+	} else {
 		/*
 		 * If digest is NULL, the event being recorded is a violation.
 		 * Make room for the digest by increasing the offset by the
-		 * hash algorithm digest size.
+		 * hash algorithm digest size. If the hash algorithm is not
+		 * specified increase the offset by IMA_DIGEST_SIZE which
+		 * fits SHA1 or MD5
 		 */
-		offset += hash_digest_size[hash_algo];
+		if (hash_algo < HASH_ALGO__LAST)
+			offset += hash_digest_size[hash_algo];
+		else
+			offset += IMA_DIGEST_SIZE;
+	}
 
 	return ima_write_template_field_data(buffer, offset + digestsize,
 					     fmt, field_data);
-- 
2.47.0



