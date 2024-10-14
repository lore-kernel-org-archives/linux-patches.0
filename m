Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344673A1B6;
	Mon, 14 Oct 2024 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918452; cv=none; b=Dzk80wBIHfdjeWIrn+C7DevAIgKXUi7wPgTS6+JDauzoTidXcDWGU4GE+d7q4WWF6hk9VtndF0SsADeXiBjjK6LYDYsLkxf9Y3+hSUU9SDq8E01VKc0+H9aQXQP9GcxET293Rmkl3cmEVlvwXzotT8hQuUkRSD7QXcTKlxoeOO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918452; c=relaxed/simple;
	bh=3n43i3R/oCgoU6/ejgh1AQdu6TOrLCqCzeVQcyR3qiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiZb5IZddqQL2Cm1dTWIYf6bicWKmuxM5RFTujw+6YnldqqnEDL98rbh9VqtDvCvCeJzQEHWAIDy2p8exbacTcmxAO9S3GtxFIyZJkuHVzkzngVZuOEQpSaQ2bXjIiPS738V/4tkU91kA4SyuPZKc7GQkzM+1Qlx4Um2vyyneTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NI3KVCu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NI3KVCu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1097C4CEC7;
	Mon, 14 Oct 2024 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918452;
	bh=3n43i3R/oCgoU6/ejgh1AQdu6TOrLCqCzeVQcyR3qiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NI3KVCu4HxDBeD4HSwJnlwS4u3D5uBOgkdpc5KA34iAR225F6uQmd5c15KZU73QR4
	 tIEC8VH7dVD1gYbSCMKEAjFCRMGfllx/KVbnOe85xaddldBBSjhLvDuezcdvt8/sHp
	 CVZC3LKwlpqk7yKcXt3z42BCBGYhlrAxcSPW7hXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 296/798] KEYS: prevent NULL pointer dereference in find_asymmetric_key()
Date: Mon, 14 Oct 2024 16:14:10 +0200
Message-ID: <20241014141229.570619478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Roman Smirnov <r.smirnov@omp.ru>

commit 70fd1966c93bf3bfe3fe6d753eb3d83a76597eef upstream.

In find_asymmetric_key(), if all NULLs are passed in the id_{0,1,2}
arguments, the kernel will first emit WARN but then have an oops
because id_2 gets dereferenced anyway.

Add the missing id_2 check and move WARN_ON() to the final else branch
to avoid duplicate NULL checks.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Cc: stable@vger.kernel.org # v5.17+
Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AKID")
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/asymmetric_type.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -61,17 +61,18 @@ struct key *find_asymmetric_key(struct k
 	char *req, *p;
 	int len;
 
-	WARN_ON(!id_0 && !id_1 && !id_2);
-
 	if (id_0) {
 		lookup = id_0->data;
 		len = id_0->len;
 	} else if (id_1) {
 		lookup = id_1->data;
 		len = id_1->len;
-	} else {
+	} else if (id_2) {
 		lookup = id_2->data;
 		len = id_2->len;
+	} else {
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* Construct an identifier "id:<keyid>". */


