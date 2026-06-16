Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606D1449ECA;
	Tue, 16 Jun 2026 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624321; cv=none; b=N0M7Y4u5cO6RCMIpcnezBZu4c3Ett2Lt5zVCOd9mirEuB62UzUvzE7C+OdmoiFkk3b8+rE4QcbQLSfBNio7V0VNBGX5bOsL7DhZq3vDFh+TYCOvc3XZ0PwPrHSKhDUi021yXx7SuCGG6tbEHb0gHhvUptPkrD9zo+N29/dDKMyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624321; c=relaxed/simple;
	bh=O4oRHQli4C5CeGzG57lYaV4YVWE98wUYs70z4w0elYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpoNzRTiCuuZb2T0FTswcQ7l+dFu2cEZ8PQdnYwKOIYlH3cPRtxmmHgxfAN0oa4U9f4NprYOhVdovHEuQXy5gLtK51yGA2UIFfOSaE7rYu7esnrM8B6bzOUB164Xe0mg5RA53pEG4I38IOBsX+f2B1QzYlJa5K0ADb/D2ezOMOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEkIy/o/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEkIy/o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596841F000E9;
	Tue, 16 Jun 2026 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624320;
	bh=TPbNxRXlWFxxP4uYNaQS04RZclr20Mj8LgTi90yJDk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEkIy/o/9lcPYk7oTz+1FAm68vavEePKh8cyHxKpwEp2wtJVx8dnKcbR45hQLvZI+
	 zHktWLBxhsGH9z7G27GUZpXMHGWCUObIhchZKig2zBXgkSbeN5gCqlXdybBD4NTLNQ
	 bhlaXx7KlKgk3DVdBYOhaO9tlNj6sPPSCJchgh7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitor Soares <vitor.soares@toradex.com>,
	Kendall Willis <k-willis@ti.com>,
	Sebin Francis <sebin.francis@ti.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.0 314/378] pmdomain: ti_sci: add wakeup constraint to parent devices of wakeup source
Date: Tue, 16 Jun 2026 20:29:05 +0530
Message-ID: <20260616145126.780241607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kendall Willis <k-willis@ti.com>

commit 4db207599acfc9d676340daa2dc6b52bfca17db4 upstream.

Set wakeup constraint for any device in a wakeup path. All parent devices
of a wakeup device should not be turned off during suspend. This ensures
the wakeup device is kept on while the system is suspended.

Cc: stable@vger.kernel.org
Fixes: 9d8aa0dd3be4 ("pmdomain: ti_sci: add wakeup constraint management")
Reported-by: Vitor Soares <vitor.soares@toradex.com>
Closes: https://lore.kernel.org/linux-pm/c0fe43a2339c802e9ce5900092cd530a2ba17a6b.camel@gmail.com/
Signed-off-by: Kendall Willis <k-willis@ti.com>
Reviewed-by: Sebin Francis <sebin.francis@ti.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/ti/ti_sci_pm_domains.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/ti/ti_sci_pm_domains.c
+++ b/drivers/pmdomain/ti/ti_sci_pm_domains.c
@@ -86,7 +86,7 @@ static inline void ti_sci_pd_set_wkup_co
 	const struct ti_sci_handle *ti_sci = pd->parent->ti_sci;
 	int ret;
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev) || device_wakeup_path(dev)) {
 		/*
 		 * If device can wakeup using IO daisy chain wakeups,
 		 * we do not want to set a constraint.


