Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F53385D97;
	Wed, 30 Sep 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791296; cv=none; b=WpUGGUhDzLZp0QX8rQPOmPm0OKkgnNg9O63fU1BYwFp2VATfz5Cv1Gtn/En8A+dTiPAz4KVCx995QjZEf85l9oIC4sXu0DOmukDt3L9J9FR+HrsA1ihXL49XRd9vVNVxh6WnYjMs/YRnckXnE57wthTruGpBXw5g96MEFvLu/iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791296; c=relaxed/simple;
	bh=6lunNFRUc6j+ujpqq6Vof2HY48Ah0HEdmcQyop+eWQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4Qm995LXBy1paJqLkJQ52xgI8CgyE1+eUTy5Rz+oEo3kiYUFHhhoahdLefaKrjOzNy7E84doaWp4fmuygZgyyMMmUWqW/Jd/DTCs7HE+u/MvmwklNkyeJrhrX0FLbVkTIHsy17bWcxDgcJpcHPtX0xSeUtvdYKUVhqRhmKPEPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVj3Xdf/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVj3Xdf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3CE1F000FF;
	Wed, 30 Sep 2026 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791295;
	bh=w1SsFeTd55bKKO1LivZOPKMCozCl8n7Um/wxEbm93mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVj3Xdf/uO9xjevx5ND6SnlCXVDbjqEyUwyt/uECxxDqKy4SY0x0q0uaEIWxvWQZc
	 3ygaECcmTyrBv/ILbqHMeyt7UZfG0ILFwNHeX7DVP3G3wEA5FCd719Na17W2xFkPx+
	 yZq/4mdUBg3uK+wl6Qle9aHCwfzl36onqqdGtjRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/752] ksmbd: rate limit unmapped SID errors
Date: Wed, 30 Sep 2026 17:22:01 +0200
Message-ID: <20260930152403.710377628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit feca5e70fc963b088377b20879e8cd8237c2fd7d ]

A client can include many structurally valid but unmapped SIDs in a DACL.
Logging every mapping failure lets one request generate hundreds of kernel
error messages.

Rate limit the message to prevent an authenticated client from flooding
the kernel log.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index a41964531c3ca..05c7682257571 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -509,8 +509,8 @@ static void parse_dacl(struct user_namespace *user_ns,
 			temp_fattr.cf_uid = INVALID_UID;
 			ret = sid_to_id(user_ns, &ppace[i]->sid, SIDOWNER, &temp_fattr);
 			if (ret || uid_eq(temp_fattr.cf_uid, INVALID_UID)) {
-				pr_err("%s: Error %d mapping Owner SID to uid\n",
-				       __func__, ret);
+				pr_err_ratelimited("%s: Error %d mapping Owner SID to uid\n",
+						   __func__, ret);
 				continue;
 			}
 
-- 
2.53.0



