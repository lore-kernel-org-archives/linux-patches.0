Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E756E4FECD3;
	Wed, 30 Sep 2026 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786929; cv=none; b=hBplk+8zA9AYfZnW2s9hcaScPYNHCYlhVZZdx63MEQokAoFOi7Qxg8Yzc58zqwBPF0cyNzLfr7hcUHoGpG755qxLkeSNhwk59POKSMpjUp7KfShySDQn3iAKJUhO4k0vXN62Pkn6QSIeDKr6cBH+t9ToOXm6LmjwEHRe+QsCIT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786929; c=relaxed/simple;
	bh=ldFvkRgj+uQaFcz5qq1zy5XdvALAK/U+/7ere0LPoJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuXMV9mQtFZazbjh/zmIrivhqJ+f0i+s+6BEyNpPibPR+/xbHBgZTQ7fJVBzyJndRB1SqaXH2MZgo9eOZHdM5xPh3WKbqEdJX+g4FAYsTsH4si/CYzbH3CQjLfvRLAca8fnRXitcF/fvXIvLggVv2LpkO9e4cmTeD4XX7Q16p3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExYiHy+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExYiHy+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA81A1F00893;
	Wed, 30 Sep 2026 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786927;
	bh=JzzLgNF5pBNUxLJrNik/49oh0JxVnuaDBmEzVMbShFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExYiHy+6dq0pMkd/3fcn+JiiRTqr8j7nHeSunRr68B79ENPfO/FKzkjjvWBepg6un
	 Cs1le2Tm9JNJwr3an2rLeVvqfTHKpRObIDenFrhNNUAEPzlvogeddmMHW6Rw5r3qPz
	 vMtnOdyqg+LvKaNyTnQp5YLk1yJHE+jvQbDx+D9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Eiden <seiden@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 014/457] s390/uv: Prevent potential out-of-bounds read
Date: Wed, 30 Sep 2026 17:21:59 +0200
Message-ID: <20260930152346.338921307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Eiden <seiden@linux.ibm.com>

[ Upstream commit f47190b08b71e8482072978373ee88cb2dfbdaf4 ]

When the system has more than 85 secrets, the uv_secret_list struct
array only holds up to 85 items per page, resulting in an out of bounds
read in find_secret_in_page if the targeted secret is in the next page
or not stored at all.

Fix this by looping over the number of stored secrets which is the
per sub-list count of stored secrets and not the overall count.

Fixes: 7c9137af2042 ("s390/uv: Retrieve UV secrets support")
Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260812-uv_secrets_fix-v3-2-a85bd29e0666@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index d970b15ef126d..e70acad09cd5f 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -760,7 +760,7 @@ static int find_secret_in_page(const u8 secret_id[UV_SECRET_ID_LEN],
 {
 	u16 i;
 
-	for (i = 0; i < list->total_num_secrets; i++) {
+	for (i = 0; i < list->num_secr_stored; i++) {
 		if (memcmp(secret_id, list->secrets[i].id, UV_SECRET_ID_LEN) == 0) {
 			*secret = list->secrets[i].hdr;
 			return 0;
-- 
2.53.0



