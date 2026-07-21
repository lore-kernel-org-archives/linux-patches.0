Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317175801;
	Tue, 21 Jul 2026 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657487; cv=none; b=IbMXFp0pT83clyyMN4Y4UK5ju9CklVcrhlh4WnuOGBIYg+PdKkBTLtin+HkmR5MAAimZ2w4zB/H6x7CbRgqopb2+bHW2fpYhmGQO2zv9PLZbRFcrOCPn9woo9nXOQw/oj/n9fDW6H0Qric0cTDDTfJyW6aqCH/E1oJ9SsSJ+QKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657487; c=relaxed/simple;
	bh=59PsJmBkVOVRWoDpLAEmHlYHKw1vgd4BSINaC0nU4uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4ELU5c62aBVdoxI/D85UYCOx3Wwv+c9Mfk5D10T8LpZIITz1QKUhhJYDqn+iLwILedNfzaQid1LrxoqkuHybZIXb8+YJ89gYUEJrfrNem1uICOnFnibOK9ZKxGGGNfDXYuo/u7oupqn+lt2EjLFutQ/07+jDgJDCN5mRwIP4E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6+H2nyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6+H2nyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D5C1F000E9;
	Tue, 21 Jul 2026 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657486;
	bh=3/AAiwfby8Iub4WkaTbbYTDewYPoDA7F78wzzCXzmcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6+H2nyHkcgHxpam8Vwld/La0nueY3s/WA8szj2dZyoE/WaGZmcel+At4KaaNASfe
	 HoicLqP+bB6mZk0b6VAf3FKlqIGtX1TRSJ2MX06U7gTu8YkTTW1OQi78PyfXha/tA0
	 5dBpnw76XRYgE8rIklhpEWhkbDyi5t9etc1q7xUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0746/1611] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:14:22 +0200
Message-ID: <20260721152532.153684015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index ce40f15d4952d6..c07b6e8fd9c93c 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -54,6 +54,8 @@ int aa_getprocattr(struct aa_label *label, char **string, bool newline)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



