Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E70A3B52FF;
	Tue, 21 Jul 2026 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671932; cv=none; b=tqZH/AnrIYrZWZL2uRP4p3IJWWuQXa7Av0yzngzfTC8a06Tcan1VT/HDGX3PMniFrE9eKl4+BNiJuWcgSzrD7u5km40pWWnDXJC3EQfURSs0R9nienISByh7hKKw3fp/aZNwx1cDWi6Pb6aIs3HimR9R5silmmMS3n41ZJpTm3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671932; c=relaxed/simple;
	bh=fYTlYwS88g9Rt9QCeYN536Ox4yVlN1Vfjz2d8d8VGiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3K9HhimZXY6ObLbw/CFFDXhUK6w2KdU3ldm3FAHSZL9WT8uiHhM1zI7olTXLGNRM8fdBpfiGudEsHPfwnPEdDKiKyZDYbWlzRPgaPLdnB37DpLvShe5tDZsdr8Zi0jM3wPvJENE3S4u0dsOCSwMkYhIoNzGo9LHMxU3aecvwCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B50XkV+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B50XkV+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C5B1F000E9;
	Tue, 21 Jul 2026 22:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671930;
	bh=Qgu6Ggl6LRJGA4nJbH97wBtI5yNdcssVpbkDPFkqa24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B50XkV+GdkIBw8PsOM7HzAut49fCKaClUDVUm5a8lMMZrdmAZvnYjrm3LwAcRQazI
	 P9h9uZwtGG89C7KU+hJRxAoyrYqxXR+5a1khlXVlzWv1sPEedqHZkMqvHm5umqM+lK
	 fXc3WScOil4eU4fmDn38P9iZPOTD/eXgoCsnOz0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/843] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:21:07 +0200
Message-ID: <20260721152415.752704305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index abdce5e52b026c..3bfdadaa133709 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -208,6 +208,7 @@ static int apparmor_secmark_init(struct aa_secmark *secmark)
 		return PTR_ERR(label);
 
 	secmark->secid = label->secid;
+	aa_put_label(label);
 
 	return 0;
 }
-- 
2.53.0



