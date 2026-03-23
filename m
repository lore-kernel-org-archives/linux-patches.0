Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BC73AC0D2;
	Mon, 23 Mar 2026 13:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274007; cv=none; b=qJsCXNxL4iqWibG7nMfbVrhRHNofJh7W8B9qeb6toXq9FAbwOi4BbS/SSBVFam0YYNO/IA8WqYM/3pld5R9gF+0uE8SjiOkRVROsHb5wPmR6vQaZdixO37NgGXNp+7LnmRYpSKCWJ2M6Siaqr3Zdwb7vTTkISWV2DTnm69cGtBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274007; c=relaxed/simple;
	bh=2CttGzqroPkaRbD3LMsjWJTY6yrT7qBvHebTZlyOhwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg/N6bM4WZ5+ICU8TbUD+ft56L9VuyjXJobiFHkwMNmXTvwUzk0HT3+Nv1mb0Es8M4e3u8tmRuCj11uAIGkrp40kMFNioTiTrlfvdtdtxRABamyTHECJiSk/aiUoT7xrnRAkqa3tPwcNPB486ZP9EFc26MIIcdydYMJLe8k6CEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkU/2rXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkU/2rXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ABBC2BC9E;
	Mon, 23 Mar 2026 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274007;
	bh=2CttGzqroPkaRbD3LMsjWJTY6yrT7qBvHebTZlyOhwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkU/2rXFoVuMmkRzMVijqAF8NMYqwEApAaRzXylBLw+9KEkBquGTBv95kFcZCVDSJ
	 VnO7DIMfEMHqzUqtpYDYJ/ch0ODFsXZlM6dKj14GD+tk7q1zb8wqUGcAwJxpfxO4Tm
	 EFjLCJhICcdjUfrDE4LTu73Vk/uqH6TF28HEdgHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 035/220] netconsole: fix sysdata_release_enabled_show checking wrong flag
Date: Mon, 23 Mar 2026 14:43:32 +0100
Message-ID: <20260323134505.691271900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 5af6e8b54927f7a8d3c7fd02b1bdc09e93d5c079 ]

sysdata_release_enabled_show() checks SYSDATA_TASKNAME instead of
SYSDATA_RELEASE, causing the configfs release_enabled attribute to
reflect the taskname feature state rather than the release feature
state. This is a copy-paste error from the adjacent
sysdata_taskname_enabled_show() function.

The corresponding _store function already uses the correct
SYSDATA_RELEASE flag.

Fixes: 343f90227070 ("netconsole: implement configfs for release_enabled")
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260302-sysdata_release_fix-v1-1-e5090f677c7c@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -508,7 +508,7 @@ static ssize_t sysdata_release_enabled_s
 	bool release_enabled;
 
 	mutex_lock(&dynamic_netconsole_mutex);
-	release_enabled = !!(nt->sysdata_fields & SYSDATA_TASKNAME);
+	release_enabled = !!(nt->sysdata_fields & SYSDATA_RELEASE);
 	mutex_unlock(&dynamic_netconsole_mutex);
 
 	return sysfs_emit(buf, "%d\n", release_enabled);


