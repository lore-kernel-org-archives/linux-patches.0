Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ED347125D;
	Tue, 21 Jul 2026 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657506; cv=none; b=LKkgDCcwnENZq3O/YDZ25HLwO1ujH1nbloyXMlPD2dch9vU0FmKUWUFhKVNc0Ku75555Rr8mRRynvEBuOzEaGjE2himnZDP0w3WYl/XDq6ryEMI0GiEGWAXJPOOxsIuV+JZdRvmvMXesxepdA2v6q9w0LLKve9SWPLW6wX9YroU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657506; c=relaxed/simple;
	bh=rVJ1hj02k+wXrtF4zUrrQM0xd73W2Mq2dtoIzBBrI/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsTh1ubMnqKqhkT92l2ixA3WmF/mYf3vhi+vOJZ+aalwlqiLKmCTRgGUVGS8rZMGaTxgfbzYwyvPgFudWlD9HvgLjnnaqFgy8Yox15L4S7Nt+xfchWf47Zd8n343TqVpj5sJ2Sc/uTtLimS1y4jDtLO/RXRc4hIuSEEDMPd6Rx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k91vYbtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k91vYbtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7361F000E9;
	Tue, 21 Jul 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657504;
	bh=dZExlqSiK84FJsLLGnlDamS5oZG5PqTFPRezl6/aZI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k91vYbtlhu/LkokIxyieN1/+j5Erf4zBuQmttbvAT7qKhHAx7sCP0gF4U35LKMwRs
	 UfD8+vK+6YrIReUR9UoiVwC4d/BwYp5KK6dThKCzfRXWfe+cFtgOUpS684tKww3jGO
	 Ke/fJsDM85ZRhYYkd/KHia+Rbp8DQ2ImJmrA195A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0747/1611] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:14:23 +0200
Message-ID: <20260721152532.176429172@linuxfoundation.org>
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

[ Upstream commit 340372688bb87da45ff8d4e2f82ccfd1b64c65ff ]

apparmor_secmark_init() parses a configured secmark label to obtain its
secid.  aa_label_strn_parse() returns a refcounted label, but the success
path kept that reference after copying the secid.

Fixes: ab9f2115081a ("apparmor: Allow filtering based on secmark policy")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index 1fc6145ccbb8d4..cf590dd08540c8 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -356,6 +356,7 @@ static int apparmor_secmark_init(struct aa_secmark *secmark)
 		return PTR_ERR(label);
 
 	secmark->secid = label->secid;
+	aa_put_label(label);
 
 	return 0;
 }
-- 
2.53.0



