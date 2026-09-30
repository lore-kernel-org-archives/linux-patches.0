Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9376E521887;
	Wed, 30 Sep 2026 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790998; cv=none; b=VIOTgiZpOmKzjs2GjVuet9g6mLc/q3LnliU6t3C2jEwE5JN7X4ZVyuUalFN25V3zz+YywJuyU2JoJSS5QGWDnmTd3jbS1k7CZizRe2K4hVFJGzXLZ3yM6BTldufkkYq33gMsmhS/lT6Yq9AgyY1XZFLxsskMvv0m93xYgw+NKFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790998; c=relaxed/simple;
	bh=kXgBmaK2aw3YCO8IYmTr9vn2dzDr5jtrDSi6zzeKwjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYfnbs4osINfghQ1wyDwPkb7qcyR+shalZtDrhBnr0dUdvJ7jRH2I6dUUIr+ihbekfk6a3wx9tL4L1JO71KdraXN3ar9sK+00qll0cmsxN3YMHl1SJt5TEG9kwICLXfQpfmgHXUqLqoScMBIayW3lTbGDRIu8kJ1jggk9uHhmq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIAhFMJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIAhFMJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE351F000FF;
	Wed, 30 Sep 2026 17:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790997;
	bh=TuJi9Piqh3vMWlaIqUQCJatDQd8+Blae/tlijGiTmds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIAhFMJMBzRYt8XQOqoig0q3Dv4AJ1Zgk5PCCKbLdzH4LSlQbq6QKJgsraBzmI2+/
	 a/2Tmip85n+8TvUBjjxzUZuMY4GSRulzbxmwtGWryuXubHMGTRL41nxkiTV0nDDGAI
	 Vk91dwpMzGdRRksT/FQObiN4l2OSzOZoeSCE6DjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/752] ptp: ocp: add shutdown callback
Date: Wed, 30 Sep 2026 17:20:18 +0200
Message-ID: <20260930152401.386312855@linuxfoundation.org>
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

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit f6f955cbf9d4e02deebe54ca91c118b53be9ffe6 ]

The shutdown callback was never implemented for this driver, but it's
needed because .remove() callback is never called during kexec/reboot
process. That leaves HW with some interrupts enabled and may cause
spurious interrupt while booting into a new kernel during with kexec.
If it happens that I2C interrupt fires during kexec, the whole I2C bus
is disabled leaving TimeCard with no devlink communication. The same
happens if timestampers were enabled, leaving the card without
timestamper interrupts until full reboot cycle.

Implement .shutdown() callback with the same function as remove
callback.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260611190333.787132-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 22accc0222451..e5aa923cb0f55 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1506,6 +1506,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.id_table	= ptp_ocp_pcidev_id,
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
+	.shutdown	= ptp_ocp_remove,
 };
 
 static int
-- 
2.53.0



