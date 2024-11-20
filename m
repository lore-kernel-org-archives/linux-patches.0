Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4171AE843;
	Wed, 20 Nov 2024 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107591; cv=none; b=GuQWK4VVd+jR5l66Whz/UrsYQwHRJw4if0cplRo+D8l+dMAwYuOYDXzByRm0qWbHrj0/dQ4/BL7x6XB9Fz5VRWd0naVDvqBI5usSdF/in0bA4pICAwmo5xOAVv+NeVqFy/j4zQkU3x+bQEydO8G3aEC7r1VIicqbF1z0DxhRsxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107591; c=relaxed/simple;
	bh=hmuPY7qPgO2N9bwh6zLjfW8vTxtUY8IyAfRNTVXST1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpRZgrHF0HAErlWuW5bjrkPsnzcKxdpBl64KgMf5EFzijwzzHLZPKSgB16s95T6ZECummJXLp3r3iODhW25nGHFWoUFKbbMwbVjWntvi8/gMw6ZPTrDXocNat7sADHCK9lJR/DgkIDubZx5G2/lguM+XS+nJxIs5erMDMqSwvQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwf63ubM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwf63ubM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EB2C4CECD;
	Wed, 20 Nov 2024 12:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107591;
	bh=hmuPY7qPgO2N9bwh6zLjfW8vTxtUY8IyAfRNTVXST1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwf63ubMvXBa/f36QmRPfE9k2C91TCdyjSauOCIe50Jz9+W6kDm/Y+pOvuzFvfFxn
	 vcpQ13roDaE6TdDdEBNBoqSg52JavFyreQNS6bh5+XL5mQtbrXv2c/3De80KdLjMGY
	 AnwvTDzB44HunXPjCFz2XAFrhm9gRLHJmjHPfE7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Enrico Bravi (PhD at polito.it)" <enrico.bravi@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.6 35/82] ima: fix buffer overrun in ima_eventdigest_init_common
Date: Wed, 20 Nov 2024 13:56:45 +0100
Message-ID: <20241120125630.403545516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


