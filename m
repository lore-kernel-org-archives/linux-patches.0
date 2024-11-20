Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE21A4F19;
	Wed, 20 Nov 2024 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107523; cv=none; b=NXa2FhuVDcwioTxN0elZDUomvmCOfqC2f5D7MGqzCnvjR/bCLBCn82Xu6NvAmaG4/1hkv+zCWFHcfXwdpJglOFsnlTY2F5Pke326HuR4ndk7f5DU9BV69vpUN6qh4HZrTnsYR/bkoZzsrdFXtOyraXpeQvE8EMO7GjE/z85awu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107523; c=relaxed/simple;
	bh=jXwm8+blZSpdgP3w4IMjh+4FrG/6SjMpvSf5IOdhD9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+Mv5fh97TIaNr2VkaI7UfHA4f9HMzHmdc0wWDyuRZCr4G6rychbc6bSc6Rup68Kd2OrFYPCoYNWpOTajy1d+mrpJcxF6AqKkeftoO3WFIfZZBk3f8At3zUMLlA5Ux6cRAlfGiuXmac7SxqiQKAWg6Aq4VSbLdtiuShmtI5g/WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXt/8aCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXt/8aCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048EC4CED2;
	Wed, 20 Nov 2024 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107521;
	bh=jXwm8+blZSpdgP3w4IMjh+4FrG/6SjMpvSf5IOdhD9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXt/8aCC6u5RnLF4DlTZANiZXEge7VJ+FNDU6OeH3apjgUobpDN7g6sYbFbLDf5PX
	 /47ZxlectwcFEa0aBhuBmJjntT+reqV4NGeBcc3gfc/9xVyvl8Y36CMIEv3M9RUZ23
	 t/YciSDDNTaHsRJkEXvEStSNjLwhKJPOkXlJ4lps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Enrico Bravi (PhD at polito.it)" <enrico.bravi@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.11 052/107] ima: fix buffer overrun in ima_eventdigest_init_common
Date: Wed, 20 Nov 2024 13:56:27 +0100
Message-ID: <20241120125630.849424288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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
 security/integrity/ima/ima_template_lib.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -318,15 +318,21 @@ static int ima_eventdigest_init_common(c
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


