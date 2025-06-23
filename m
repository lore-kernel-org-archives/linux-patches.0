Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C72252917;
	Mon, 23 Jun 2025 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684218; cv=none; b=Fr/52Uk57wLOtA+DKwZuDS1uZ6Zho3PO0rY2sfviBYdrv36hImeGd62Dcsy+SVnlZTI5vFIP2a3jpsceeV/74BtV+jh/PCTdzI3kB7h+J6JJqym7RNjtrTPHrbRBV/V/RoMuqY7e/eyJkQEZbFh8Bzqk6UZFddTCcyv6PRTlIiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684218; c=relaxed/simple;
	bh=9/WB7l1EyFr1V2tkpLTkNTJkgM6hhSlozuqqote6fPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDykcTcCYHPXxd7mqFpwJRNh7MqiT6WHle8QbFEjIYma+t3zEZ5No9TcmjxqzrHNSbfZWX5duMWdSTz+PMvgEVm7lcyu1CA6LLaqULFCNHRRoVgb1JHSjElEWO0O3zyxvYNIGsZQaZ0GVERk/WasEG+fsu7F3+HBKsPmX9PYvNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MexsSwFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MexsSwFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CD8C4CEEA;
	Mon, 23 Jun 2025 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684218;
	bh=9/WB7l1EyFr1V2tkpLTkNTJkgM6hhSlozuqqote6fPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MexsSwFOcm5gjHq/3tLWSrFwsJYdqIuAoFgrYlm8VGiWufXQnmY4n8mFQP7r1K/Ls
	 dsKekIylUbF8cskcq9ZvFoEoUI6BgI+mmdmvGVttB8Xk6XGdH9LIXjiLO1l0VLw0xW
	 2y4sZjPL8ryLCSRTqEXEHDVbuNhZWk5SilrFct/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Breno Leitao <leitao@debian.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 6.15 002/592] configfs: Do not override creating attribute file failure in populate_attrs()
Date: Mon, 23 Jun 2025 14:59:20 +0200
Message-ID: <20250623130700.275944923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit f830edbae247b89228c3e09294151b21e0dc849c upstream.

populate_attrs() may override failure for creating attribute files
by success for creating subsequent bin attribute files, and have
wrong return value.

Fix by creating bin attribute files under successfully creating
attribute files.

Fixes: 03607ace807b ("configfs: implement binary attributes")
Cc: stable@vger.kernel.org
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250507-fix_configfs-v3-2-fe2d96de8dc4@quicinc.com
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -619,7 +619,7 @@ static int populate_attrs(struct config_
 				break;
 		}
 	}
-	if (t->ct_bin_attrs) {
+	if (!error && t->ct_bin_attrs) {
 		for (i = 0; (bin_attr = t->ct_bin_attrs[i]) != NULL; i++) {
 			if (ops && ops->is_bin_visible && !ops->is_bin_visible(item, bin_attr, i))
 				continue;


