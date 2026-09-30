Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB5451B16C;
	Wed, 30 Sep 2026 18:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792807; cv=none; b=RJSI7D7QS+HNplV4eQ6Z3VBtBuzhBwR5Q6rgYqTpnePPWfuKtHy0TgKwS/aHBAX1S3vcxwcQ2V3C5FJCUQiw6mAG56gcDTeZR39MIoayJbo9b6O9KDJMZrJHnKxnk9C/oPPfhlVcNiz9Wnl1YNK49CAToRuhAfRA5IBqye1L6Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792807; c=relaxed/simple;
	bh=2wZ1veSU373gRX4bseQe2TKLPVO3ycrBAv9IDHQ3BoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QglB2APUOgbG2lYE2yHFP30i/acmJD9+TFKuvxLztoy9O81WtM5N26BbUybWulAeFhgNFNte63kC74Y0K+T19ul1cvbJvVwC+e4hQI6lR+U2Kgb5GpFz+gYvOz7DrwUJcithWB6BKalQl1DBoDuugPxLLuxyR2lL9ZLbXXDa3M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkKRD/v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkKRD/v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89F21F000FF;
	Wed, 30 Sep 2026 18:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792806;
	bh=KvXIBEr2aVA7h4Dy/v1Xq37yp+oooiHJsZq9socQuzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkKRD/v/9GJJ2uCFgGy0P5Htlg4m+JSIRBFl0h9hPdDx/eYQZ0RYEuVHf0Tqu+w/t
	 edqOvysG75rIMRG1ggON70kdnVA4i5fPEue8m6c8+EDOYQbHdeGjD/F0gJI9JY1kRs
	 4eRFHkTOaaqAZpWfL/fPWLIkat9icHbqMDS+V48s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Eiden <seiden@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/395] s390/uv: Prevent potential out-of-bounds read
Date: Wed, 30 Sep 2026 17:24:31 +0200
Message-ID: <20260930152340.813289638@linuxfoundation.org>
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
index 92abeb54f9c1b..d49206bf74155 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -857,7 +857,7 @@ static int find_secret_in_page(const u8 secret_id[UV_SECRET_ID_LEN],
 {
 	u16 i;
 
-	for (i = 0; i < list->total_num_secrets; i++) {
+	for (i = 0; i < list->num_secr_stored; i++) {
 		if (memcmp(secret_id, list->secrets[i].id, UV_SECRET_ID_LEN) == 0) {
 			*secret = list->secrets[i].hdr;
 			return 0;
-- 
2.53.0



