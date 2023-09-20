Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D1515ACC
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8D3C433C8;
	Wed, 20 Sep 2023 12:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212992;
	bh=mYIslGX3w7KzJ/t/hkigEZP/kEiff8fEMYUDBPsrYzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki2yFUSXi7tKGasAcNoM0abYB7W4C8CotWzkoA00kfw92Lfj8+uPAN0weareA1Ogq
	 kGHL3fgGa+X3ytxXO33csn0JSmRXc/fT2AyPqk+xrzom9hRrNUHk9eBW+8yGB0dMYp
	 1ChK39DPUIOR84VRXjTVyU1hxUFmj1y1xKAsSdJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/367] smackfs: Prevent underflow in smk_set_cipso()
Date: Wed, 20 Sep 2023 13:28:17 +0200
Message-ID: <20230920112901.752438250@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3ad49d37cf5759c3b8b68d02e3563f633d9c1aee ]

There is a upper bound to "catlen" but no lower bound to prevent
negatives.  I don't see that this necessarily causes a problem but we
may as well be safe.

Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 6b6fec04c412b..a71975ea88a94 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -895,7 +895,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	}
 
 	ret = sscanf(rule, "%d", &catlen);
-	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
+	if (ret != 1 || catlen < 0 || catlen > SMACK_CIPSO_MAXCATNUM)
 		goto out;
 
 	if (format == SMK_FIXED24_FMT &&
-- 
2.40.1



