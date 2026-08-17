Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39735280CE5;
	Mon, 17 Aug 2026 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976772; cv=none; b=PiVr3avSyptKcwedIkfqhFFQf88UNj4XOjX25xMBanv0iIuixypSiyhHGVdFZEBUlbvpdmOGbJXaOb7436ttgw2PN7kCdJpOjQsG0rKeB8PQDy8fyCVZW4idOsNqn10CuwXLAgICrSfdBihKaFL07or5WvqtrB5n1rXA9AIt9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976772; c=relaxed/simple;
	bh=3YWdL6Q2hHQcNXO6xY+eKQZtDnc9ONovjr7qLtJkW9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHunLui9jbz9e1cJtAIdDeM2U/+5tbPh9l3vU0oYPlB54EA1Ak08b9C96oZgYq9ztQ7f5dmASaLGXNha8bgpIVB8Jr6PJqD2w8qmCMV6GWy2HnDNRQ+WlFC1Bu3mYBkJEahem2pvA+M7ei7az2H0vk3ROYAnfxQYZMHGYwfErSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbHf3Bn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbHf3Bn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C38D1F00A3D;
	Mon, 17 Aug 2026 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976770;
	bh=zqD/amSRIVhyUitV3nAuWT2zKs4Psw9FAjc/DhWG/8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbHf3Bn2xuH4YwW0Y3B07RjAzOn+zdqlAq1o/iB72P3P+tNt5LSTz9ebXD/uYokR2
	 5KFy3+H86cEQY2KlXegPX/wlPQCYuN2LAqcUUnHBrh+r/GDs4Mtw/VMDeHjrSZ3/OB
	 /4EE5z3gSO7DqTc+4a//qHJPjOLKueol7B2H4emg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.15 061/456] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Mon, 17 Aug 2026 15:27:31 +0200
Message-ID: <20260817132542.434201255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit fc3afb5728e297994863f8a2a01b88a920bbf53e upstream.

The probe() calls pm_runtime_use_autosuspend(), but remove() does not call
pm_runtime_dont_use_autosuspend(). This can lead to a usage_count leak if
autosuspend_delay is set to a negative value.

The pm_runtime_use_autosuspend() also notes that it's important to undo
this with pm_runtime_dont_use_autosuspend() at driver exit time.

Fixes: 1f874edcb731 ("usb: chipidea: add runtime power management support")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260716104126.2763454-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1246,6 +1246,7 @@ static int ci_hdrc_remove(struct platfor
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


