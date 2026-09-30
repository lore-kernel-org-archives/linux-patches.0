Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7865051B16A;
	Wed, 30 Sep 2026 18:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792804; cv=none; b=SaIIWffd06pk1br5c8tH8Rr92Eg5At2zzbctzmynvsOyayet/PKcRPMs/NuxyYAPgh0acU9QXzSU06P5bsszaVVpl+PupqXhD1Bh+OYYKZVtj4L48jauSlhVffQKBxQy3Y1sIowegt7vz3JL7I2DBBKZ4Cf3/anEcnbWaLvhCho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792804; c=relaxed/simple;
	bh=ZTznmHNFcmLFAuvzxWJA8i8SWYkcALx0sEWQEFxuxZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAkAtguZsXnZVD7N1guReCyiX/3lB0dKWoaXU2JYmJ8dHxMNQizLlLALx0mfSWRteGiNh2uQ/gxvJhi1byB8z9kjPElesKaN0u1gWsdgrqAXiChpX0yu3xxD/J2FykeQpivPEDxlCwITsiepnV2Ot3t/gBgH2B1haGahr0wK7OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWGfgaW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWGfgaW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C6B1F000FF;
	Wed, 30 Sep 2026 18:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792803;
	bh=xdVXpNWcHmpqIRj21qOmiaVzp6CMLOQfer7nGdcG9Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWGfgaW7jpf1UuFJLTfh2X1CaxM7BQxgiMKshyBEXKWiiEKJVsS6G0EfSKDYenoOg
	 Yhr3R9znjyHMy82FElcfniV/tuREA1CD0NGnNGKb5FdIGi8yHZbEP8fRU+tDIvfh+k
	 tZeW7k1e6KEJ+aiEYB3CgTwxTcN9PsCnEzvZUmg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/395] s390/uv: Fix loop condition in uv_find_secrets
Date: Wed, 30 Sep 2026 17:24:30 +0200
Message-ID: <20260930152340.791382095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Eiden <seiden@linux.ibm.com>

[ Upstream commit d12ce6bce5ec5175c3581e01c71e7a5abb286d9b ]

Systems with more than 85 UV secrets got -ENOENT for any secret past the
first page.

Fix this by setting the start index at the beginning of the loop in
uv_find_secret() and not at the end. First test if there are more
secrets left by comparing start_idx with list->next_secret_idx, and then
set the start index to the next secret index.

Fixes: 7c9137af2042 ("s390/uv: Retrieve UV secrets support")
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260812-uv_secrets_fix-v3-1-a85bd29e0666@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 5d17609bcfe1d..92abeb54f9c1b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -878,11 +878,14 @@ int uv_find_secret(const u8 secret_id[UV_SECRET_ID_LEN],
 		   struct uv_secret_list *list,
 		   struct uv_secret_list_item_hdr *secret)
 {
-	u16 start_idx = 0;
+	u16 start_idx;
 	u16 list_rc;
 	int ret;
 
+	list->next_secret_idx = 0;
+
 	do {
+		start_idx = list->next_secret_idx;
 		uv_list_secrets(list, start_idx, &list_rc, NULL);
 		if (list_rc != UVC_RC_EXECUTED && list_rc != UVC_RC_MORE_DATA) {
 			if (list_rc == UVC_RC_INV_CMD)
@@ -893,7 +896,6 @@ int uv_find_secret(const u8 secret_id[UV_SECRET_ID_LEN],
 		ret = find_secret_in_page(secret_id, list, secret);
 		if (ret == 0)
 			return ret;
-		start_idx = list->next_secret_idx;
 	} while (list_rc == UVC_RC_MORE_DATA && start_idx < list->next_secret_idx);
 
 	return -ENOENT;
-- 
2.53.0



